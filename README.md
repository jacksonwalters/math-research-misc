# non-commutative_polynomials
Calculations in non-commutative polynomial rings

Identifies the symmetric group algebra with a quotient of a free group algebra.

Let $G = \langle x,y \rangle / (x^2 = y^n = (xy)^{n−1} = 1, (xy^{−1}xy)^3 = 1, (xy^{−j}xy^j)^2 = 1 for 2 \le j \le ⌊n/2⌋ )$ be a presentation of the symmetric group using generators and relation as a quotient of a free group on two generators.

Let $kG$ be the group algebra of $G$. Since $G \cong S_n$, $kG \cong kS_n$. 

We compute the idempotents in $kS_n$ and pull them back to $kG$ along the isomorphism. 

We then compute the Groebner bases for these noncommutative polynomials using GAP's GBNP package.
