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

- GAP appears to be not looking up the data, but rather computing conjugacy classes of the matrix group, then using character theory to just derive the entire table from scratch without knowing much about the actual representations or Greene's theory
- as for Greene's theory, it only computes the characters, and doesn't actually compute the representations
- it sounds like this may just be hard, or like people have either been avoiding this or it requires extremely complicated techniques