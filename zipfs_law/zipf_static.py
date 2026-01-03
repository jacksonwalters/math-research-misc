#STATIC CASE
#implementation of a Markov chain model demonstrating Zipf's law

import math
import numpy as np
from scipy.linalg import expm
import random
import matplotlib.pyplot as plt

#number of quantities
n=1000
max_quant=1000
grid_size=100
p_ii=1

#inital quantities as integers
q = [np.array([random.randint(0,max_quant) for i in range(n)])]

#generate random 2d locations for cities and compute distances
x = [(grid_size*random.random(),grid_size*random.random()) for i in range(n)]
d = [[math.dist(x[i],x[j]) for j in range(n)] for i in range(n)]

#transition probabilities are given by p_ij = 1/d_ij where d_ij
#is the distance from node i to node j.
def p(i,j):
    return 1/math.dist(x[i],x[j]) if i != j else p_ii
P = [[p(i,j) for j in range(n)] for i in range(n)]
row_sum = [sum(row) for row in P]
#normalize so that row sums (outgoing) are 1
P = np.array([[P[i][j]/row_sum[i] for j in range(n)] for i in range(n)])
#make sure row sums are 1 within numerical error
for row in P:
    assert(sum(row) - 1 < 10**-9)

#for cont. case, subtract 1 from diagonal to stochastic matrix A
def Q(t):
    A = P - np.identity(n)
    return np.matmul(q[0],expm(t*A))

#compute eigenvalues, eigenvectors, and stationary distribution
eig_val, eig_vec = np.linalg.eig(P)
pi = eig_vec[0]/sum(eig_vec[0])

#plot the initial distribution for reference
init=list(Q(0))
init.sort(reverse=True)
plt.plot(init)

#plot at t=5
quantities=list(Q(2))
quantities.sort(reverse=True)
plt.plot(quantities)

#sort list in ascending order to get rank-freq. dist
quantities=list(Q(10))
quantities.sort(reverse=True)
plt.plot(quantities)


plt.show()
plt.clf()
