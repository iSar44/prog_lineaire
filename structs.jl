module TP_objets

mutable struct Constraint
    u::Float64
    v::Float64
    w::Float64
    Constraint(u, v, w) = new(u, v, w)
end

mutable struct Point
    x::Float64
    y::Float64
    Point() = new()
    Point(x, y) = new(x, y)
end


mutable struct LineEq
    a::Float64
    b::Float64
    x_intercept::Point
    y_intercept::Point
    LineEq() = new()
    LineEq(a, b) = new(a, b, Point(), Point(0, b))
end


export Constraint, Point, LineEq

end