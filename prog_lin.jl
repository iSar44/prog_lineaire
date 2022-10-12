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

#Exo - Glacier 

#Target function
# f(x, y) = 30x + 40y

# a::Constraint = Constraint(4, 9, 40)
# b::Constraint = Constraint(5, 5, 25)
# c::Constraint = Constraint(10, 3, 30)

# l1::LineEq = get_lineEq(a)
# l2::LineEq = get_lineEq(b)
# l3::LineEq = get_lineEq(c)


# t1::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l2, a, b)
# t2::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l3, a, c)
# t3::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l3, b, c)

# constraints = [a, b, c]
# intersections = [line_intercept(t1), line_intercept(t2), line_intercept(t3)]


# 1er exercice
f(x, y) = 315x + 205y - 10

# # 2ème exercice
# f(x, y) = 4x + 3y + 25

a::Constraint = Constraint(1, 2, 14)
b::Constraint = Constraint(10, 10, 100)
c::Constraint = Constraint(20, 10, 190)
d::Constraint = Constraint(4, 0, 37)
e::Constraint = Constraint(0, 1, 6)
gf::Constraint = Constraint(-4, 1, 4)
g::Constraint = Constraint(-5, -5, -10)
h::Constraint = Constraint(-25, -15, -40)
i::Constraint = Constraint(-1, 0, 0)
j::Constraint = Constraint(0, -1, 0)

constraints::Vector{Constraint} = [a, b, c, d, e, gf, g, h, i, j]

l1::LineEq = get_lineEq(a)
l2::LineEq = get_lineEq(b)
l3::LineEq = get_lineEq(c)
l4::LineEq = get_lineEq(d)
l5::LineEq = get_lineEq(e)
l6::LineEq = get_lineEq(gf)
l7::LineEq = get_lineEq(g)
l8::LineEq = get_lineEq(h)
l9::LineEq = get_lineEq(i)
l10::LineEq = get_lineEq(j)

# L1 w/ the rest
t1::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l2, a, b)
t2::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l3, a, c)
t3::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l4, a, d)
t4::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l5, a, e)
t5::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l6, a, gf)
t6::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l7, a, g)
t7::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l8, a, h)
t8::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l9, a, i)
t9::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l10, a, j)

# L2 w/ the rest
t10::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l3, b, c)
t11::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l4, b, d)
t12::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l5, b, e)
t13::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l6, b, gf)
t14::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l7, b, g)
t15::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l8, b, h)
t16::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l9, b, i)
t17::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l10, b, j)

#L3 w/ the rest
t18::Tuple{LineEq,LineEq,Constraint,Constraint} = (l3, l4, c, d)
t19::Tuple{LineEq,LineEq,Constraint,Constraint} = (l3, l5, c, e)
t20::Tuple{LineEq,LineEq,Constraint,Constraint} = (l3, l6, c, gf)
t21::Tuple{LineEq,LineEq,Constraint,Constraint} = (l3, l7, c, g)
t22::Tuple{LineEq,LineEq,Constraint,Constraint} = (l3, l8, c, h)
t23::Tuple{LineEq,LineEq,Constraint,Constraint} = (l3, l9, c, i)
t24::Tuple{LineEq,LineEq,Constraint,Constraint} = (l3, l10, c, j)

#L4 w/ the rest
t25::Tuple{LineEq,LineEq,Constraint,Constraint} = (l4, l5, d, e)
t26::Tuple{LineEq,LineEq,Constraint,Constraint} = (l4, l6, d, gf)
t27::Tuple{LineEq,LineEq,Constraint,Constraint} = (l4, l7, d, g)
t28::Tuple{LineEq,LineEq,Constraint,Constraint} = (l4, l8, d, h)
t29::Tuple{LineEq,LineEq,Constraint,Constraint} = (l4, l9, d, i)
t30::Tuple{LineEq,LineEq,Constraint,Constraint} = (l4, l10, d, j)

# L5 w/ rest
t31::Tuple{LineEq,LineEq,Constraint,Constraint} = (l5, l6, e, gf)
t32::Tuple{LineEq,LineEq,Constraint,Constraint} = (l5, l7, e, g)
t33::Tuple{LineEq,LineEq,Constraint,Constraint} = (l5, l8, e, h)
t34::Tuple{LineEq,LineEq,Constraint,Constraint} = (l5, l9, e, i)
t35::Tuple{LineEq,LineEq,Constraint,Constraint} = (l5, l10, e, j)

# L6 w/ rest
t36::Tuple{LineEq,LineEq,Constraint,Constraint} = (l6, l7, gf, g)
t37::Tuple{LineEq,LineEq,Constraint,Constraint} = (l6, l8, gf, h)
t38::Tuple{LineEq,LineEq,Constraint,Constraint} = (l6, l9, gf, i)
t39::Tuple{LineEq,LineEq,Constraint,Constraint} = (l6, l10, gf, j)

# L7 w/ rest
t40::Tuple{LineEq,LineEq,Constraint,Constraint} = (l7, l8, g, h)
t41::Tuple{LineEq,LineEq,Constraint,Constraint} = (l7, l9, g, i)
t42::Tuple{LineEq,LineEq,Constraint,Constraint} = (l7, l10, g, j)

# L8  w/ rest
t43::Tuple{LineEq,LineEq,Constraint,Constraint} = (l8, l9, h, i)
t44::Tuple{LineEq,LineEq,Constraint,Constraint} = (l8, l10, h, j)

# L9 w/ rest
t45::Tuple{LineEq,LineEq,Constraint,Constraint} = (l9, l10, i, j)


intersects::Vector{Point} = [
    line_intersect(t1),
    line_intersect(t2),
    line_intersect(t3),
    line_intersect(t4),
    line_intersect(t5),
    line_intersect(t6),
    line_intersect(t7),
    line_intersect(t8),
    line_intersect(t9),
    line_intersect(t10),
    line_intersect(t11),
    line_intersect(t12),
    line_intersect(t13),
    line_intersect(t14),
    line_intersect(t15),
    line_intersect(t16),
    line_intersect(t17),
    line_intersect(t18),
    line_intersect(t19),
    line_intersect(t20),
    line_intersect(t21),
    line_intersect(t22),
    line_intersect(t23),
    line_intersect(t24),
    line_intersect(t25),
    line_intersect(t26),
    line_intersect(t27),
    line_intersect(t28),
    line_intersect(t29),
    line_intersect(t30),
    line_intersect(t31),
    line_intersect(t32),
    line_intersect(t33),
    line_intersect(t34),
    line_intersect(t35),
    line_intersect(t36),
    line_intersect(t37),
    line_intersect(t38),
    line_intersect(t39),
    line_intersect(t40),
    line_intersect(t41),
    line_intersect(t42),
    line_intersect(t43),
    line_intersect(t44),
    line_intersect(t45)
]

println("Ci-dessous se trouvent le(s) point(s) d'intersections trouvé(s) par le programme")

for i in intersects
    println(string(i))
end

possibilites = check_constraints(constraints, intersects)

println(" ")
println("Le résultat optimisé est obtenu au point du tableau ci-dessous auquel correspond la plus grande valeur: ")
println(" ")

for p in possibilites
    println(string(p) * " -> " * string(round(get_result(p), digits=3)))
end



