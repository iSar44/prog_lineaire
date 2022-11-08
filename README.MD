# Manuel d'utilisateur

### 1. Définir une fonction à optimiser

Cette fonction doit être du type $f(x,y) = p \cdot x + q \cdot y + r$ (avec $p,q,r \in \R$)

```julia
f(x, y) = 315x + 205y - 10
```

### 2. Déclarer un tableau de contraintes, dans lequel il faut insérer les diverses contraintes du problème.

```julia
constraints::Vector{Constraint} = [
    Constraint(1, 2, 14),
    Constraint(20, 10, 190),
    Constraint(4, 0, 37),
    Constraint(-4, 1, 4),
    Constraint(-5, -5, -10),
    Constraint(-25, -15, -40),
    Constraint(-1, 0, 0),
    Constraint(0, -1, 0)
]
```

**_Attention:_**
Dans le programme, les contraintes sont définies sous la forme: $u \cdot x + v \cdot y \leqslant w$

(où u et v sont les coefficients des variables x et y, w est la valeur à respecter de la contrainte)

Si vos contraintes sont sous la forme: $u \cdot x + v \cdot y \geqslant w$

Il vous faut $\cdot(-1)$ les deux côtés de la contraintes et par la suite l'insérer dans le tableau

### 3. Lancer le programme

```bash
julia main.jl
```
