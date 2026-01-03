# zipfs law

This is a mathematical model of a process which gives rise to
Zipf's law. The model uses a Markov chain in which transition
probabilities are constructed to reflect the motto "the rich get richer".
It is split into three cases (static, semi-static, dynamic) depending on
whether we allow the transitions probabilities to depend or not on the changing
quantities.

Zipf's "law" is a rank-frequency distribution which
which occurs in various settings, e.g. for a large
corpus of natural language text, count the number of times each
word occurs (its frequency, f), and order by this
value to obtain an index (the rank, k), and plot f vs. k.
this data is well approximated by a power law f(k)=1/k^s.
Normalizing to get a probability distribution, we get
f(k)=1/(H_N,S * k^s) where H_N,s is the N-th generalized
harmonic number sum_{n=1}^{N} 1/n^s where N is the number
of words in the corpus. in the limit as N -> infty, this
is the Riemann zeta function.

Zipf's law also shows up in naturally occurring measures like populations of cities. To come up
with a model that explains the resulting distribution, let's assume that people are more likely
to move to a city if either

1) it is nearby
2) it is more populated

SETTING UP THE MARKOV CHAIN:
----------------------------

Viewing the cities as n nodes in a network (city_1,city_2,...,city_n), the probability to move from city_1 to city_2 as p_12,...,p_ij,...,p_nn (the transition matrix), we can write down a Markov-chain model where each step in the process is viewed as unit of time t_1,...,t_max. Assuming the cities lie in a 2d plane (more generally an n-dim'l vector space), we can compute the symmetric distance (or similarity) matrix d_ij. Let the population of a city (or quantity) be f_1,...,f_n.

CASE I (STATIC): p_ij does not depend on time. A person is more likely to move to a city that is closer, so

p_ij ~ 1/d_ij

CASE II (SEMI-STATIC): p_ij depends on time, but is constant on intervals where the order of the
populations is constant. That is, we only care whether the population (Q_i) of one city is greater than another,
not by how much.

Let boole(statement) = {0 if statement is False, 1 if statement is True}. Then

p_ij ~ boole(Q_j-Q_i > 0)/d_ij

CASE III (DYNAMIC): pi_j depends on both the population difference and the distance between cities,

p_ij ~ |Q_j - Q_i|/d_ij, if Q_i < Q_j, else 0.

Since p_ij is the probability of a transition/move from city_i to city_j, the amount of people
we expect to move out of city_i and into city_j is Q_i*p_ij.

DISCRETE:

That is, we need to sum over all incoming (+) and outgoing (-) cities/nodes to get
the total population change between times t_r and t_r+1:

Q_i(t_r+1) = Q_i(t_r) + sum_k Q_i(t_r)*p_ki - sum_k Q_i(t_r)*p_ik

Since p_ij represent probabilities, we require that the outgoing row sum
sum_k p_ik = 1. Simplifying, get a linear system:

Q_i(t_r+1) = sum_k Q_k(t_r)*p_ki

In matrix notation,

Q(t_r+1) = Q(t_r)P = ... = Q(t_0)P^r

STATIC, DISCRETE CASE:

P is constant and only depends on the distances, d_ij. We can solve for this
process by diagonalizing the probability transition matrix P. The eigenvalues
will give the rates, and the limit as t or r -> infty will give the steady
state.

SEMI-STATIC, DISCRETE CASE:

P is piecewise constant, only depending on the order of Q. We just need to find
times t* where a transposition, or swap, in the order of quantities is occurring.
When there is such a change, we get a new transition matrix P*. To solve, construct
a piecewise solution.

DYNAMIC, DISCRETE:

Here P depends on the differences Q_i-Q_j, which depend on time. The general
recurrence reads

Q(t_r+1) = Q(t_r)P(t_r) = ... = Q(0) P(t_0)P(t_1)...P(t_r)

To solve, one can just compute and multiply the matrices at each time step.

In the simplest case when p_ij = (Q_j-Q_i), if Q_i < Q_j, 0 otherwise one could
potentially plug into the recurrence to get

Q_i(t_r+1) = sum_k Q_k(t_r)*(Q_j(t_r) - Q_i(t_r))

and actually solve the quadratic recurrences to obtain an exact solution.

STATIC, CONTINUOUS:

To get the continuous Markov chain, we rearrange to obtain

Q_i(t_r+1) - Q_i(t_r) = sum_k Q_k*p_ki

which, when t_r+1 - t_r is very small, we can write in matrix form as

dQ(t)/dt = Q(t)(P - I_n)

where I_n is the nxn identity matrix. A solution is given by

Q(t) = Q(0)exp(t(P-I_n))

SEMI-STATIC, CONTINUOUS:

Same solution as static case, but piecewise whenever P changes.

DYNAMIC, CONTINUOUS:

Equations for Q_i(t) become a Lotka-Volterra type system of quadratic ODEs.