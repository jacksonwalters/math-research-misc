#SEMI-STATIC CASE
#p_ij = boole(Q_j - Q_i > 0)/d_ij
#meaning transitions from i->j only when population at Q_j exceeds Q_i
#starting with slow solution - updating transition matrix each time

import math
import numpy as np
from scipy.linalg import expm
import random
import matplotlib.pyplot as plt

n=1000  #number of quantities
max_quant=100000   #maximum quantity
grid_size=100   #max x,y in location grid/map
p_ii = 100   #diagonal determines proportion of quantity "held"

#inital quantities as integers
q = [np.array([random.randint(0,max_quant) for i in range(n)])]

#generate random 2d locations for cities and compute distances
x = [(grid_size*random.random(),grid_size*random.random()) for i in range(n)]
d = [[math.dist(x[i],x[j]) for j in range(n)] for i in range(n)]

#transition probabilities are given by p_ij = 1/d_ij where d_ij
#is the distance from node i to node j.
def p(i,j,t):
    return bool(q[t][i]-q[t][j] < 0)/math.dist(x[i],x[j]) if i != j else p_ii
def P(t):
    #probabilities at time t
    P_t = [[p(i,j,t) for j in range(n)] for i in range(n)]
    #normalize so that row sums (outgoing) are 1
    row_sum = [sum(row) for row in P_t]
    P_t = np.array([[P_t[i][j]/row_sum[i] for j in range(n)] for i in range(n)])
    #make sure row sums are 1 within numerical error
    for row in P_t:
        assert(sum(row) - 1 < 10**-9)
    return P_t

#to solve (for now) multiply matrices
#faster to find transposition points and run cont. until those
#times are hit
def Q(t):
    #if t=0, return inital quantities
    if t == 0:
        return q[0]
    #if t is exactly length of q, just reference list
    if t == len(q):
        q_t = np.matmul(q[t-1],P(t-1))
        q.append(q_t)
        return q[t]
    #otherwise compute recursively
    if t > len(q):
        q_t = np.matmul(Q(t-1),P(t-1))
        q.append(q_t)
        return q[t]
    #if already computed, just return it
    if t < len(q):
        return q[t]

#plot the initial distribution for reference
init=list(Q(0))
init.sort(reverse=True)
plt.plot(init)

#plot the initial distribution for reference
quantities=list(Q(5))
quantities.sort(reverse=True)
plt.plot(quantities)

#sort list in ascending order to get rank-freq. dist
quantities=list(Q(10))
quantities.sort(reverse=True)
plt.plot(quantities)


plt.show()
plt.clf()
