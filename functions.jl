include("structs.jl")

using .TP_objets

"""
# Description

Function that transforms a given constraint into 
a structure representing the general form of a linear equation (i.e.
y = ax + b)

# Argument
- `c::Constraint`: a given object of type Constraint

# Return type
- `::LineEq` 
"""
function get_lineEq(c::Constraint)::LineEq

    line = LineEq()
    a = 0
    b = 0

    if getproperty(c, :u) != 0 && getproperty(c, :v) != 0

        a = ((-1) * getproperty(c, :u) / getproperty(c, :v))
        b = (getproperty(c, :w) / getproperty(c, :v))

        line = LineEq(a, b)

        res::Float64 = 0
        arr = [getproperty(line, :a), (-1) * getproperty(line, :b)]

        res = arr[2] / arr[1]

        line.x_intercept = Point(res, 0)
        return line

    elseif getproperty(c, :u) == 0 && getproperty(c, :v) != 0

        # Horizontal line
        b = getproperty(c, :w) / getproperty(c, :v)
        line.y_intercept = Point(a, b)


    elseif getproperty(c, :u) != 0 && getproperty(c, :v) == 0

        # Vertical line
        a = getproperty(c, :w) / getproperty(c, :u)
        line.x_intercept = Point(a, b)

    else

        println("Une erreur est survenue. Le U ou le V de votre contrainte doit obligatoirement être non nul!")
        exit(1)

    end

    line.a = a
    line.b = b

    return line
end


"""
# Description

Function that finds the intersect between two lines.
If no intersect is found, the output of the function will look 
like this: Point(Inf, Inf), due to a division by zero

# Argument
- `tup::Tuple{LineEq,LineEq,Constraint,Constraint}`: a tuple containing both of the lines as well as their respective constraints

# Return type
- `::Point`
"""
function line_intersect(tup::Tuple{LineEq,LineEq,Constraint,Constraint})::Point

    isNotSpecialCase::Bool = false

    for i in tup

        if typeof(i) == LineEq
            if isdefined(i, :x_intercept) && isdefined(i, :y_intercept)
                isNotSpecialCase = true
            else
                isNotSpecialCase = false
                break
            end
        else
            break
        end

    end

    if isNotSpecialCase

        a = getproperty(tup[1], :a)
        b = getproperty(tup[1], :b)
        a_prime = getproperty(tup[2], :a)
        b_prime = getproperty(tup[2], :b)

        #GENERAL SOLUTION
        pX::Float64 = (b_prime - b) / (a - a_prime)

        y_for_l1 = trunc(a * pX + b, digits=10)
        y_for_l2 = trunc(a_prime * pX + b_prime, digits=10)

        if y_for_l1 == y_for_l2

            pY::Float64 = y_for_l1

            return Point(round(pX, digits=10), round(pY, digits=10))
        end

    else

        l1 = tup[1]
        l2 = tup[2]

        c1 = tup[3]
        c2 = tup[4]

        if !(isdefined(l1, :x_intercept))

            numerator = c2.w + (-1) * (c1.w * c2.v / c1.v)
            denom = c2.u

            res::Float64 = numerator / denom

            return Point(res, l1.b)


        end

        if !(isdefined(l2, :x_intercept))

            return Point((l2.b + ((-1) * l1.b)) / l1.a, l2.b)

        end

        if !(isdefined(l1, :y_intercept))

            return Point(l1.a, l2.a * l1.a + l2.b)

        end

        if !(isdefined(l2, :y_intercept))

            return Point(l2.a, l1.a * l2.a + l1.b)

        end

    end
end


"""
# Description

Function that checks if a point complies with all the given constraints. Subsequently it will
return a vector containing all of the points that do in fact comply with the different requirements

# Arguments
- `arr_constraints::Vector{Constraint}`: a vector containing all the different constraints of a problem
- `arr_points::Vector{Point}`: a vector containing all the different intersects

# Return type
- `::Vector{Point}`
"""
function check_constraints(arr_constraints::Vector{Constraint}, arr_points::Vector{Point})::Vector{Point}

    valid_points::Vector{Point} = []
    cmpt = 1

    for i in arr_constraints
        while cmpt <= length(arr_points)

            tmp = round(getproperty(i, :u) * getproperty(arr_points[cmpt], :x) + getproperty(i, :v) * getproperty(arr_points[cmpt], :y), digits=3)

            if tmp <= getproperty(i, :w)

                if arr_points[cmpt] in valid_points
                    deleteat!(valid_points, findall(x -> x == arr_points[cmpt], valid_points))
                end
                push!(valid_points, arr_points[cmpt])

            else

                deleteat!(arr_points, cmpt)

                if cmpt <= length(arr_points)
                    cmpt -= 1
                else
                    cmpt = length(arr_points)
                end
            end

            cmpt += 1

            if cmpt == (length(arr_points) + 1)
                cmpt = 1
                break
            end
        end
    end

    return arr_points
end

"""

# Description

Given a vector of lines and a vector of constraints, this function returns a vector of pairs of lines between which
we're trying to find an intersect. We're also adding to each pair their respective constraints so that further down
the line we can verify if the intersect that was found complies at the very least with its own constraints 

# Argument
- `arr_lines::Vector{LineEq}`: a vector containing all the lines that were constructed from the initial constraints
- `arr_constraints::Vector{Constraint}`: a vector containing all the constraints of a given problem

# Return

- `::Vector{Tuple{LineEq,LineEq,Constraint,Constraint}}`
"""
function make_pairs(arr_lines::Vector{LineEq}, arr_constraints::Vector{Constraint})::Vector{Tuple{LineEq,LineEq,Constraint,Constraint}}

    len::Int32 = length(arr_lines)

    arr_pairs::Vector{Tuple{LineEq,LineEq,Constraint,Constraint}} = []

    for (idx_1,) in 1:len-1
        for (idx_2,) in idx_1+1:len

            push!(arr_pairs, (arr_lines[idx_1], arr_lines[idx_2], arr_constraints[idx_1], arr_constraints[idx_2]))

        end
    end

    return arr_pairs

end

"""
# Description

Function that, given a certain x value and y value, evaluates the result of the targeted function 

# Argument
- `p::Point`: an intersect

# Return type
- `::Float64`
"""
function get_result(p::Point)::Float64

    res = f(getproperty(p, :x), getproperty(p, :y))

    return res
end

"""
# Description

Function that finds the intersect at which the problem is maximized and prints out the result
as well as the corresponding point to the standard output


# Argument
- `arr_points::Vector{Point}`: a vector of points

# Return type
- `::Nothing`
"""
function max_val(arr_points::Vector{Point})::Nothing

    max_point::Point = Point(0, 0)

    inter_value::Float64 = 0
    maximum_value::Float64 = 0

    for (id, p) in enumerate(arr_points)

        inter_value = get_result(p)

        if id == 1
            maximum_value = get_result(p)
        end

        if inter_value >= maximum_value
            max_point = p
            maximum_value = inter_value
        end
    end

    println("La valeur MAXIMALE est égale à: $maximum_value. Elle correspond au POINT: $max_point")

end


"""
# Description

Function that finds the intersect at which the problem is minimized and prints out the result
as well as the corresponding point to the standard output

# Argument
- `arr_points::Vector{Point}`: a vector of points

# Return type
- `::Nothing`
"""
function min_val(arr_points::Vector{Point})::Nothing

    min_point::Point = Point(0, 0)

    inter_value::Float64 = 0
    minimum_value::Float64 = 0


    for (id, p) in enumerate(arr_points)

        inter_value = get_result(p)

        if id == 1
            minimum_value = get_result(p)
        end

        if inter_value <= minimum_value
            min_point = p
            minimum_value = inter_value
        end
    end

    println("La valeur MINIMALE est égale à: $minimum_value. Elle correspond au POINT: $min_point")
end