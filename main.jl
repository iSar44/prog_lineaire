include("functions.jl")

######### Exo - Glacier ##############

# Fonction à optimiser
# f(x, y) = 30x + 40y

# constraints::Vector{Constraint} = [
#     Constraint(4, 9, 40),
#     Constraint(5, 5, 25),
#     Constraint(10, 3, 30)
# ]

######################################


############ Defi - TP0 ##############

# 1er exercice
# f(x, y) = 315x + 205y - 10

# # 2ème exercice
f(x, y) = 4x + 3y + 25

constraints::Vector{Constraint} = [
    Constraint(1, 2, 14),
    Constraint(10, 10, 100),
    Constraint(20, 10, 190),
    Constraint(4, 0, 37),
    Constraint(0, 1, 6),
    Constraint(-4, 1, 4),
    Constraint(-5, -5, -10),
    Constraint(-25, -15, -40),
    Constraint(-1, 0, 0),
    Constraint(0, -1, 0)
]

######################################


######## Révision - Exam blanc #######

# Fonction à optimiser
# f(x, y) = -20x + 10y + 5

# constraints::Vector{Constraint} = [
#     Constraint(1, 1, 20),
#     Constraint(-3, 1, 0),
#     Constraint(-2, 3, 20),
#     Constraint(-2, -2, -10),
#     Constraint(9, -3, 75),
#     Constraint(0, -1, 0)
# ]

######################################


lines::Vector{LineEq} = []


for c in constraints
    push!(lines, get_lineEq(c))
end

pairs::Vector{Tuple{LineEq,LineEq,Constraint,Constraint}} = make_pairs(lines, constraints)


intersects::Vector{Point} = []

for pair in pairs
    push!(intersects, line_intersect(pair))
end

# println("Ci-dessous se trouvent le(s) point(s) d'intersections trouvé(s) par le programme")

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

