include("structs.jl")

using .TP_objets

"""

Function that transforms a given constraint into 
a structure representing the general form of a linear equation (i.e.
y = ax + b)

# Arguments
-  `c::Constraint`: a given object of type Constraint
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


function line_intercept(tup::Tuple{LineEq,LineEq,Constraint,Constraint})::Point

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

        if pX > 0

            y_for_l1 = a * pX + b
            y_for_l2 = a_prime * pX + b_prime

            if y_for_l1 == y_for_l2

                pY::Float64 = y_for_l1
                return Point(round(pX, digits=3), round(pY, digits=3))

            end
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


function check_constraints(arr_constraints, arr_points)::Vector{Point}

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

function get_result(p::Point)::Float64
    res = f(getproperty(p, :x), getproperty(p, :y))

    return res
end

#TESTING

#Target function
f(x, y) = 30x + 40y

a::Constraint = Constraint(4, 9, 40)
b::Constraint = Constraint(5, 5, 25)
c::Constraint = Constraint(10, 3, 30)
# a::Constraint = Constraint(1, 2, 14)
# b::Constraint = Constraint(10, 10, 100)
# c::Constraint = Constraint(20, 10, 190)

l1::LineEq = get_lineEq(a)
l2::LineEq = get_lineEq(b)
l3::LineEq = get_lineEq(c)


t1::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l2, a, b)
t2::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l3, a, c)
t3::Tuple{LineEq,LineEq,Constraint,Constraint} = (l2, l3, b, c)

# println(line_intercept(tup))
# exit()

# inter_l1_l2 = get_intersection(l1, l2)
# inter_l1_l3 = get_intersection(l1, l3)
# inter_l2_l3 = get_intersection(l2, l3)

# line_intercept(t1)

line_intercept(t3)

constraints = [a, b, c]
intersections = [line_intercept(t1), line_intercept(t2), line_intercept(t3)]
# intersections = [inter_l1_l2, inter_l1_l3, inter_l2_l3]

# f(x, y) = 315x + 205y - 10

# a::Constraint = Constraint(1, 2, 14)
# b::Constraint = Constraint(10, 10, 100)
# c::Constraint = Constraint(20, 10, 190)
# d::Constraint = Constraint(4, 0, 37)
# e::Constraint = Constraint(0, 1, 6)
# gf::Constraint = Constraint(-4, 1, 4)
# g::Constraint = Constraint(-5, -5, -10)
# h::Constraint = Constraint(-25, -15, -40)
# i::Constraint = Constraint(-1, 0, 0)
# j::Constraint = Constraint(0, -1, 0)

# l1::LineEq = get_lineEq(a)
# l2::LineEq = get_lineEq(b)
# l3::LineEq = get_lineEq(c)
# l4::LineEq = get_lineEq(d)
# l5::LineEq = get_lineEq(e)
# l6::LineEq = get_lineEq(gf)
# l7::LineEq = get_lineEq(g)
# l8::LineEq = get_lineEq(h)
# l9::LineEq = get_lineEq(i)
# l10::LineEq = get_lineEq(j)


# #   TESTING
# inter_l1_l2 = get_intersection(l1, l2)
# inter_l1_l3 = get_intersection(l1, l3)
# inter_l2_l3 = get_intersection(l2, l3)

# constraints = [a, b, c]
# intersections = [inter_l1_l2, inter_l1_l3, inter_l2_l3]

println("Ci-dessous se trouvent le(s) point(s) d'intersections trouvé(s) par le programme")

for i in intersections
    println(string(i))
end

possibilites = check_constraints(constraints, intersections)

println(" ")
println("Le résultat optimisé est obtenu au point du tableau ci-dessous auquel correspond la plus grande valeur: ")
println(" ")

for p in possibilites
    println(string(p) * " -> " * string(round(get_result(p), digits=3)))
end



