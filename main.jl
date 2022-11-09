include("functions.jl")

#region Exo - Glacier
######################################

# Fonction à optimiser
# f(x, y) = 30x + 40y

# constraints::Vector{Constraint} = [
#     Constraint(4, 9, 40),
#     Constraint(5, 5, 25),
#     Constraint(10, 3, 30)
# ]

######################################
#endregion

#region Défi - TPO
######################################

# 1er exercice
# f(x, y) = 315x + 205y - 10

# # 2ème exercice
# f(x, y) = 4x + 3y + 25

# constraints::Vector{Constraint} = [
#     Constraint(1, 2, 14),
#     Constraint(10, 10, 100),
#     Constraint(20, 10, 190),
#     Constraint(4, 0, 37),
#     Constraint(0, 1, 6),
#     Constraint(-4, 1, 4),
#     Constraint(-5, -5, -10),
#     Constraint(-25, -15, -40),
#     Constraint(-1, 0, 0),
#     Constraint(0, -1, 0)
# ]

######################################
#endregion

#region Révision - Exam blanc
######################################

# Fonction à optimiser
f(x, y) = -20x + 10y + 5

constraints::Vector{Constraint} = [
    Constraint(1, 1, 20),
    Constraint(-3, 1, 0),
    Constraint(-2, 3, 20),
    Constraint(-2, -2, -10),
    Constraint(9, -3, 75),
    Constraint(0, -1, 0)
]

######################################
#endregion

lines::Vector{LineEq} = []
intersects::Vector{Point} = []


for c in constraints
    push!(lines, get_lineEq(c))
end

pairs::Vector{Tuple{LineEq,LineEq,Constraint,Constraint}} = make_pairs(lines, constraints)

for pair in pairs
    push!(intersects, line_intersect(pair))
end


possibilites = check_constraints(constraints, intersects)


println("********************************************************************")
max_val(possibilites)
println(" ")
min_val(possibilites)
println("********************************************************************")



