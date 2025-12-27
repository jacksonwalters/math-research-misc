# finite general linear group research plan

## goal

The goal of this project is to construct the representations of the finite general linear groups GL_n(F_q) over the complex numbers in SageMath.

For small values, these representations are understood well. For larger values, it is computationally intensive and requires understanding in detail how the representations are parameterized by partitions and cuspidal data.

We already have Specht modules for the symmetric group in SageMath. General finite group representations are lacking, and it may be necessary to just specify to a class just for these groups called Green's parameterization or similar.

## status

We can compute character tables easily, and these are probably from GAP.

We also have the MeatAxe algorithm from GAP which can compute modular decompositions, though it doesn't seem to be working and we're going to focus on the complex case for right now.

## next actions

- understand how GAP is computing the character tables for GL_n(F_q)
- read Greene (1955)

## progress

```
G := GL(2,3);
tbl := CharacterTable(G);
Display(tbl);
CT1

     2  4  1  4  1  3  3  3  2
     3  1  1  1  1  .  .  .  .

       1a 6a 2a 3a 4a 8a 8b 2b

X.1     1  1  1  1  1  1  1  1
X.2     1  1  1  1  1 -1 -1 -1
X.3     2 -1  2 -1  2  .  .  .
X.4     2  1 -2 -1  .  A -A  .
X.5     2  1 -2 -1  . -A  A  .
X.6     3  .  3  . -1  1  1 -1
X.7     3  .  3  . -1 -1 -1  1
X.8     4 -1 -4  1  .  .  .  .

A = -E(8)-E(8)^3
  = -Sqrt(-2) = -i2
```

## representations of GL_n(F_q)

- GAP appears to be not looking up the data, but rather computing conjugacy classes of the matrix group, then using character theory to just derive the entire table from scratch without knowing much about the actual representations or Greene's theory
- as for Greene's theory, it only computes the characters, and doesn't actually compute the representations
- it sounds like this may just be hard, or like people have either been avoiding this or it requires extremely complicated techniques
- it might be better to simply focus on implementing induced representations for now, and some sort of general class for finite group representations, or at least specific classes for these types of representations

## graph similarity over GL_n(F_q)

- it's also interesting to consider more general matrices GL_n(F_q) as a generalization of permutation matrices, which are a subgroup S_n \subset GL_n(F_q)
- since a graph has edge weights in {0,1}, these are in any field, so one can view the adjacency matrix of a graph as a symmetric matrix M in Mat_n(F_q)
- then we can consider \sigma \in GL_n(F_q) such that \sigma . M_0 . \sigma^{-1} == M_1 for two adjacency matrices M_1, M_2
- if M_0, M_1 are isomorphic as graphs, then some of the \sigma will be permutation matrices, i.e. their values will lie in {0,1} and row/column sums will be 1
- to compute these, one needs to check that the rational canonical forms are equal. then to get one actual solution you need to compute the Jordan normal form for both M_0, M_1 to get the change-of-basis matrix
- currently, there is no option to get the change-of-basis matrix with `rational_form*()`, and the Jordan canonical form fails for certain fields even when it should not
- I believe these are bugs that will need to be addressed with Travis. ideally we should be able to just compute the rational canonical form and change-of-basis matrix successfully for any finite field
- then, yes, computing the stabilizer is slow, so getting the entire set of similarity matrices is slow, but it might be instructive to look at this larger set of matrices. I think for permutation matrices it's generally only one (or two if you include the inverse) that make it work

## notes

- https://github.com/sagemath/sage/issues/25902