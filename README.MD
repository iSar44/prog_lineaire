# Utilisation

### 1) Définir les contraintes sous forme de variables

```julia

a::Contraint = Contraint(u0, v0, w0)
b::Contraint = Contraint(u1, v1, w0)

```

où uN, vN et wN sont vos valeurs respectives

### 2) Appeler la fonction get_lineEq() qui transformera vos contraintes en structures d'équation linéaire

```julia

l1::LineEq = get_lineEq(a)
l2::LineEq = get_lineEq(b)

```

### 3) Assignez à un tuple vos contraintes et vos équations linéaire

```julia

t1::Tuple{LineEq,LineEq,Constraint,Constraint} = (l1, l2, a, b)

```

### 4) Initialisez un tableau dans lequel vous allez appeler la fonction line_intersect() en lui passant en paramètre votre tuple

```julia

intersects = [line_intersect(t1)]

```

### 5) Finalement, il ne vous reste plus qu'à sauvegarder le fichier et l'exécuter depuis la ligne de commande

```bash

$ julia prog_lin.jl

```
