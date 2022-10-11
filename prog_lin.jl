include("structs.jl")

# using Plots
using .TP_objets


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

        x::Point = Point(res, 0)
        line.x_intercept = x
    else

        if getproperty(c, :u) == 0

            # Horizontal line

            b = getproperty(c, :w) / getproperty(c, :v)
            y_axis::Point = Point(a, b)

            line.y_intercept = y_axis


        else

            #Vertical line

            # a = getproperty(c, :u)
            a = getproperty(c, :w) / getproperty(c, :u)
            x_axis::Point = Point(a, b)

            line.x_intercept = x_axis
        end

        line.a = a
        line.b = b
    end

    return line

end


function get_intersection(l1::LineEq, l2::LineEq)::Point

    x(y) = getproperty(l2, :a) * y + getproperty(l2, :b)
    y(x) = getproperty(l2, :a) * x + getproperty(l2, :b)
    res::Float64 = 0

    if !(isdefined(l1, :x_intercept))

        res = x(getproperty(l1, :b))

        if res < 0
            res = ((-1) * getproperty(l1, :b) + getproperty(l2, :b)) / ((-1) * getproperty(l2, :a))
        end

        intersection = Point(round(res, digits=3), round(getproperty(l1, :b), digits=3))


    elseif !(isdefined(l1, :y_intercept))

        res = y(getproperty(l1, :a))
        intersection = Point(round(getproperty(l1, :a), digits=3), round(res, digits=3))

    elseif !(isdefined(l2, :x_intercept))

        y_value = x(getproperty(l1, :b))

        x_value = (getproperty(l2, :b) + (-1) * getproperty(l1, :b)) / getproperty(l1, :a)

        intersection = Point(round(x_value, digits=2), round(y_value, digits=2))


    elseif !(isdefined(l2, :y_intercept))

        res = y(getproperty(l1, :a))

        # res_x = x(getproperty(l1, :a))
        # res_y = y(res_x)

        if res < 0
            res *= -1
        end

        intersection = Point(round(getproperty(l2, :a), digits=3), round(res, digits=3))

        # intersection = Point(round(res_x, digits=3), round(res_y, digits=3))

    else

        x_axis::Float64 = (getproperty(l2, :b) - getproperty(l1, :b)) / (getproperty(l1, :a) - getproperty(l2, :a))

        f(x) = getproperty(l1, :a) * x + getproperty(l1, :b)

        y_axis::Float64 = f(x_axis)

        intersection = Point(round(x_axis, digits=3), round(y_axis, digits=3))


    end

    return intersection

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

#Target function
f(x, y) = 30x + 40y

a::Constraint = Constraint(4, 9, 40)
b::Constraint = Constraint(5, 5, 25)
c::Constraint = Constraint(10, 3, 30)

l1::LineEq = get_lineEq(a)
l2::LineEq = get_lineEq(b)
l3::LineEq = get_lineEq(c)


#   TESTING
inter_l1_l2 = get_intersection(l1, l2)
inter_l1_l3 = get_intersection(l1, l3)
inter_l2_l3 = get_intersection(l2, l3)

constraints = [a, b, c]
intersections = [inter_l1_l2, inter_l1_l3, inter_l2_l3]

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



































# println(z[1])

# #Target function
# f(x, y) = 8x + 9y

# a::Constraint = Constraint(2, 5, 12)
# b::Constraint = Constraint(10, 10, 45)
# c::Constraint = Constraint(50, 5, 150)
# d::Constraint = Constraint(5, 50, 100)


# l1::LineEq = get_lineEq(a)
# l2::LineEq = get_lineEq(b)
# l3::LineEq = get_lineEq(c)
# l4::LineEq = get_lineEq(d)


# #   TESTING
# inter_l1_l2 = get_intersection(l1, l2)
# inter_l1_l3 = get_intersection(l1, l3)
# inter_l1_l4 = get_intersection(l1, l4)
# inter_l2_l3 = get_intersection(l2, l3)
# inter_l2_l4 = get_intersection(l2, l4)
# inter_l3_l4 = get_intersection(l3, l4)



# constraints = [a, b, c, d]

# # targets_to_check = []
# # for i in constraints

# #     push!(targets_to_check, getproperty(i, :w))
# # end

# # println(targets_to_check)


# # println(constraints)
# intersections = [inter_l1_l2, inter_l1_l3, inter_l1_l4, inter_l2_l3, inter_l2_l4, inter_l3_l4]


# # println(lines)
# # println(intersections)


# z = check_constraints(constraints, intersections)




# println(z[1])


# shot_at_target = f(getproperty(z[1], :x), getproperty(z[1], :y))

# print("LE RÉSULTAT EST: ")
# println(shot_at_target)

