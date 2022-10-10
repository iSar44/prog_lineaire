include("structs.jl")

# using Plots
using .TP_objets


function get_lineEq(c::Constraint)::LineEq

    if (getproperty(c, :v) != 0)

        a = ((-1) * getproperty(c, :u) / getproperty(c, :v))
        b = (getproperty(c, :w) / getproperty(c, :v))
    else
        a = getproperty(c, :u)
        b = 0

    end
    line = LineEq(a, b)

    res::Float64 = 0
    arr = [getproperty(line, :a), (-1) * getproperty(line, :b)]

    res = round(arr[2] / arr[1], digits=1)

    # if res == 0
    #     x_axis::Point = Point(getproperty(line, :a), 0)
    #     line.x_intercept = x_axis
    #     return line
    # end
    x::Point = Point(res, 0)
    line.x_intercept = x
    return line

end


function get_intersection(l1::LineEq, l2::LineEq)::Point


    x_axis::Float64 = (getproperty(l2, :b) - getproperty(l1, :b)) / (getproperty(l1, :a) - getproperty(l2, :a))

    f(x) = getproperty(l1, :a) * x + getproperty(l1, :b)

    y_axis::Float64 = f(x_axis)

    intersection = Point(round(x_axis, digits=3), round(y_axis, digits=3))

    return intersection

end

function check_constraints(arr_constraints, arr_points)::Vector{Point}

    valid_points::Vector{Point} = []
    cmpt = 1

    for i in arr_constraints
        while cmpt <= length(arr_points)

            tmp = getproperty(i, :u) * getproperty(arr_points[cmpt], :x) + getproperty(i, :v) * getproperty(arr_points[cmpt], :y)

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
# println(constraints)
intersections = [inter_l1_l2, inter_l1_l3, inter_l2_l3]
# println(lines)


z = check_constraints(constraints, intersections)

shot_at_target = f(getproperty(z[1], :x), getproperty(z[1], :y))

print("LE RÉSULTAT EST: ")
println(shot_at_target)

print("L'optimisation est obtenue au ")
println(z[1])

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

