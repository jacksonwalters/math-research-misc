# symmetric-group-research

## free algebra quotient

Identifies the symmetric group algebra with a quotient of a free group algebra.

Let $G = \langle x,y \rangle / (x^2 = y^n = (xy)^{n−1} = 1, (xy^{−1}xy)^3 = 1, (xy^{−j}xy^j)^2 = 1 \text{ for } 2 \le j \le ⌊n/2⌋ )$ be a presentation of the symmetric group using generators and relation as a quotient of a free group on two generators.

Let $kG$ be the group algebra of $G$ over a field $k$. $kG \cong kS_{n}$ since $G \cong S_{n}$.

We compute the idempotents in $kS_n$ and pull them back to $kG$ along the isomorphism. 

We then compute the Groebner bases for these noncommutative polynomials using GAP's [GBNP package](https://www.gap-system.org/Packages/gbnp.html).

## fock space

Calculations involving the infinite dimensional Fock space associated to the symmetric group in Sage.

## number theory

Rust code to compute roots of unity in finite field, Chinese remainder theorem.

## graphs

Using the extended Cholesky decomposition, we could in principle factor any adjacency matrix $A$ as $UU^\ast$ since $A$ is symmetric.

## group-preference
This software is a mathematical model for a group making a binary choice. Let i = 1, ..., N index the choosers. 

Each has a probability, or preference, function p_i (t) which varies over time. A sigmoid function, sigma, which may be a disrete step function, is applied to make a binary choice. 

We then sum the values, and divide by the total. To get a smooth function, we can mollify by using logistic sigmoid with a parameter q. 

A standard example would be a poll tracker, as FiveThirtyEight has, which measures whether or not a group of individuals approves of the president's job performance or not. 