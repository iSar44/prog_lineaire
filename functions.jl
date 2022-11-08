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

        res = round(arr[2] / arr[1], digits=1)

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

        y_for_l1 = round(a * pX + b, digits=3)
        y_for_l2 = round(a_prime * pX + b_prime, digits=3)

        if y_for_l1 == y_for_l2

            pY::Float64 = y_for_l1
            return Point(round(pX, digits=3), round(pY, digits=3))

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

            return Point(round(res, digits=3), round(l1.b, digits=3))

        end

        if !(isdefined(l2, :x_intercept))

            return Point(round((l2.b + ((-1) * l1.b)) / l1.a, digits=3), round(l2.b, digits=3))
        end

        if !(isdefined(l1, :y_intercept))

            return Point(l1.a, round(l2.a * l1.a + l2.b, digits=3))
        end

        if !(isdefined(l2, :y_intercept))

            return Point(l2.a, round(l1.a * l2.a + l1.b, digits=3))
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

            tmp = round(getproperty(i, :u) * getproperty(arr_points[cmpt], :x) + getproperty(i, :v) * getproperty(arr_points[cmpt], :y), digits=2)

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

TODO


# Argument
- `arr_lines::Vector{LineEq}`: TODO
- `arr_constraints::Vector{Constraint}`: TODO

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