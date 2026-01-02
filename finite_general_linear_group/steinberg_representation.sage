F = GF(2)
V = VectorSpace(F, 3)
G = GL(3, GF(2))

# list all 1-dimensional
points = [U for U in V.subspaces(1)]
print("len(points):", len(points))

# list 2-dimensional subspaces
planes = [U for U in V.subspaces(2)]
print("len(planes):", len(planes))

# create edges between points and planes
edges = []
for p in points:
    for H in planes:
        if p.is_subspace(H):
            edges.append((p, H))
len(edges)

# create index mappings
point_index = {points[i]: i for i in range(len(points))}
plane_index = {planes[i]: i for i in range(len(planes))}
edge_index = {edges[i]: i for i in range(len(edges))}

# initialize boundary matrix
num_vertices = len(points) + len(planes)
num_edges = len(edges)
boundary = Matrix(CDF, num_vertices, num_edges)

# fill boundary matrix
for (p, H), j in edge_index.items():
    i_p = point_index[p]
    i_H = plane_index[H] + len(points)

    boundary[i_H, j] = 1     # +H
    boundary[i_p, j] = -1    # -p

# compute kernel of boundary matrix
ker = boundary.right_kernel()
ker.dimension()

print("kernel of boundary matrix:", ker)

# display a basis vector of the Steinberg representation
steinberg_basis = ker.basis()
print("element of Stenberg basis: ", steinberg_basis[0])

def line_repr(L):
    """
    Canonical representative for a 1-dim subspace over F_2:
    return its unique nonzero vector.
    """
    for v in L.basis():
        if v != 0:
            return tuple(v)
        
def linear_form_str(a):
    """
    a is a vector in F_2^3, printed as a linear equation a·x = 0
    """
    terms = []
    for i, ai in enumerate(a):
        if ai != 0:
            terms.append(f"x{i+1}")
    if not terms:
        return "0"
    return " + ".join(terms)

def plane_repr(H):
    """
    Represent a plane as a readable equation like x1 + x2 = 0
    """
    V = H.ambient_vector_space()
    for a in V:
        if a != 0:
            if all(a * v == 0 for v in H.basis()):
                return "{" + linear_form_str(a) + " = 0}"
            
def edge_repr(edge):
    p, H = edge
    return f"{line_repr(p)} ⊂ {plane_repr(H)}"

def pretty_print_cycle(v, edges):
    for j, coeff in enumerate(v):
        if coeff != 0:
            print(f"{coeff:+} · [{edge_repr(edges[j])}]")

print("Pretty print of Steinberg basis element:")
pretty_print_cycle(steinberg_basis[0],edges)

from itertools import permutations

# Given a group element g in GL(3,2), construct the corresponding apartment cycle
def apartment_cycle_from_g(g, edges, edge_index):

    basis = [g.matrix().column(i) for i in range(3)]
    lines = [V.subspace([v]) for v in basis]

    cycle = vector(CDF, len(edges))

    for w in permutations([0, 1, 2]):
        sign = Permutation([i+1 for i in w]).signature()
        p = lines[w[0]]
        H = lines[w[0]] + lines[w[1]]
        j = edge_index[(p, H)]
        cycle[j] += sign

    return cycle

g = G.random_element()

v_A = apartment_cycle_from_g(g, edges, edge_index)
print("apartment cycle v_A from random basis element g \in GL_3(F_2):", v_A)

#verify this is actually a cycle by multiplying by boundary map
print("\del * v_A"(boundary * v_A).is_zero())

print("Pretty print of apartment cycle v_A:")
pretty_print_cycle(v_A,edges)

###### DEFINE G-ACTION ON STEINBERG REPRESENTATION #######

def g_act_on_subspace(g, S):
    """
    Given g in GL_3(F_2) and a subspace S of W,
    return g(S) as a subspace of W.
    """
    W = S.ambient_vector_space()
    basis = S.basis_matrix().transpose()
    transformed_columns = [g * basis.column(i) for i in range(basis.ncols())]
    vecs = [W(v) for v in transformed_columns]  # convert each to W-element explicitly
    return W.subspace(vecs)

def g_action_on_edge_indices(g, edges, edge_index):
    """
    Returns a dictionary mapping edge indices under the action of g.
    """
    new_index_map = {}
    for i, (p, H) in enumerate(edges):
        gp = g_act_on_subspace(g, p)
        gH = g_act_on_subspace(g, H)
        j = edge_index[(gp, gH)]
        new_index_map[i] = j
    return new_index_map

def g_action_on_vector(g, v, edges, edge_index):
    perm_map = g_action_on_edge_indices(g, edges, edge_index)
    # create a zero vector of same dimension
    v_new = vector(CDF, len(v))
    for i, val in enumerate(v):
        if val != 0:
            j = perm_map[i]
            v_new[j] += val
    return v_new

v0 = steinberg_basis[0]
g_v0 = g_action_on_vector(g, v0, edges, edge_index); 

print("Steinberg basis element: ",v0)
print("g · Steinberg basis element: ",g_v0)

# verify the action is in fact a G-action on H(\Delta; \C), the Steinberg representation

h = G.random_element()
lhs = g_action_on_vector(g, g_action_on_vector(h, v0, edges, edge_index), edges, edge_index)
rhs = g_action_on_vector(g * h, v0, edges, edge_index)
assert lhs == rhs, "G-action property failed!"
print("G-action property verified: g(h(v0)) == (gh)(v0)")