#elliptic curve y^2=x^3+x+1 in normal form
#compute the rank and torsion of the curve over \QQ
E=EllipticCurve([0,0,0,1,1])
E.rank()

#compute torsion points
E.torsion_points()

#curve is not smooth over F_2 at the point (x,y)=(1,1), so not elliptic
#it has a singularity since both partial derivatives vanish there
#E2=EllipticCurve(GF(2), [0,0,0,1,1]) returns an error appropriately

#we can still compute the number of points over extensions F_2
#let's compute for fields where the exponent m of 2^m divides the exponent n of 2^n
#find points of curve over extensions of F_2^1, e.g. F_2^2=4, F_2^4=16, F_2^5=32
def g(x,y):
    return y^2-x^3-x-1

#after the change of variables x->x+1, y->y+1, we obtain the curve y^2=x^2(x+1)
Q.<x,y> = PolynomialRing(GF(2))
show(g(x+1,y+1))

#arithmetic over field extensions of F_2
P.<x> = PolynomialRing(GF(2))
f = x^3 + x + 1 # Fano Polynomial
k.<a> = GF(2^3, modulus=f
k.modulus()
x^3+x+1
a^(2^3)

#the curve is singular at the point (x,y)=(1,1)
#as both partial derivatives \del_x g(x,y), \del_y g(x,y) vanish
k(g(1,1))==0 and mod(1,7) != 0

#perform a grid search for points over F_8
raise_to = lambda a,k: a^k if k != oo else 0
exponents = [i for i in range(2^3)]+[oo]
solutions_over_F_8 = []
for i in exponents:
    for j in exponents:
        #check that it's a point on the curve
        if k(g(raise_to(a,i),raise_to(a,j))) == 0:
            #check that it's not a singular point where x=1
            if i != 0 and i!= 7:
                solutions_over_F_8.append((i,j))
solutions_over_F_8

#evaluate curve over F_7
E2=EllipticCurve(GF(7), [0,0,0,1,1])

#compute the points over F_7
E2.points()

#compute number of points
E2.order()

#the Zeta function over F_7 is a rational function of T. What is it? Only need q^n for all n.
#for algebraic closure of F_7, \union_{m|n}F_7^m. Dylan Yott? Community seminar? Is this a bug?
#dividing_exponents_seven = [7^1,7^2,7^4,7^8]
#Rob: the number of points over 7^n are determined by the number of points over F_7, and \alpha, \beta
N=10
number_of_points_over_extensions_of_F_7 = []
for n in range(1,N):
    number_of_points_over_extensions_of_F_7+=[EllipticCurve(GF(7^n), [0,0,0,1,1]).order()]

#build the Zeta function for the finite field F_7 and the elliptic curve y^2=x^3+x+1
#the shape of the Zeta function should be something like (1-\alpha*T)*(1-\beta*T)/((1-T)*(1-qT)) where
#q is the order of the finite field of interest, for instance q=7^m. Setting m=1, we can look at q=7.
#What are the complex numbers \alpha and \beta?

#let's examine the algebraic variety E3 over the finite field F_7, and compute an approximation of the Zeta function
var('T')
def zeta(q,T):
    return sum(exp(number_of_points_over_extensions_of_F_7[n]*T**n/n) for n in range(1,N-2))

#zeta(7,T) = (1-\alpha*T)(1-\beta*T)/((1-T)*(1-qT)) thanks to Joe Silverman.
#\alpha = (3+\sqrt{19}*i)/14, \beta = \overline{\alpha}
#define the Zeta function using the formulas found in Silverman, pp. 140 - 144
#compute \alpha and \beta
n_7 = number_of_points_over_extensions_of_F_7[0]
a_7 = 7+1-n_7
h(T)=1-a_7*T+7*T^2
alpha=h(T).roots()[1][0]
beta=h(T).roots()[0][0]
def zeta_silverman(q,T):
    return (1-alpha*T)*(1-beta*T)/((1-T)*(1-q*T))

#computes the Zeta function of y^2=x^3+x+1 over F_7
print("The Zeta function of the elliptic curves y^2=x^3+x+1 over F_7 is ...")
print(zeta_silverman(7,T))

#the number of points over extensions of F_7 can be computed by evaluating the n-th derivative of the zeta function
zeta_diff = lambda T : diff(zeta_silverman(7,T),T)
