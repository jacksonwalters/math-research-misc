use reikna::totient::totient;
use reikna::factor::quick_factorize;
use std::collections::HashMap;

// Modular arithmetic functions using i64
fn mod_add(a: i64, b: i64, p: i64) -> i64 {
    (a + b) % p
}

fn mod_mul(a: i64, b: i64, p: i64) -> i64 {
    (a * b) % p
}

pub fn mod_exp(mut base: i64, mut exp: i64, p: i64) -> i64 {
    let mut result = 1;
    base %= p;
    while exp > 0 {
        if exp % 2 == 1 {
            result = mod_mul(result, base, p);
        }
        base = mod_mul(base, base, p);
        exp /= 2;
    }
    result
}

fn extended_gcd(a: i64, b: i64) -> (i64, i64, i64) {
    if b == 0 {
        (a, 1, 0)  // gcd, x, y
    } else {
        let (gcd, x1, y1) = extended_gcd(b, a % b);
        (gcd, y1, x1 - (a / b) * y1)
    }
}

pub fn mod_inv(a: i64, modulus: i64) -> i64 {
    let (gcd, x, _) = extended_gcd(a, modulus);
    if gcd != 1 {
        panic!("{} and {} are not coprime, no inverse exists", a, modulus);
    }
    (x % modulus + modulus) % modulus  // Ensure a positive result
}

// Compute n-th root of unity (omega) for p not necessarily prime
pub fn omega(modulus: i64, n: usize) -> i64 {
    let factors = factorize(modulus as i64);
    if factors.len() == 1 {
        let (p, e) = factors.into_iter().next().unwrap();
        let root = primitive_root(p, e); // primitive root mod p
        let grp_size = totient(modulus as u64) as i64;
        assert!(grp_size % n as i64 == 0, "{} does not divide {}", n, grp_size);
        return mod_exp(root, grp_size / n as i64, modulus) // order of mult. group is Euler's totient function
    }
    else {
        return root_of_unity(modulus, n as i64)
    }
}


pub fn divisors_with_given_lcm(phi: &[i64], n: i64) -> Option<Vec<i64>> {
    let n_factors = factorize(n);
    let phi_factors: Vec<HashMap<i64, u32>> = phi.iter().map(|&x| factorize(x)).collect();
    let num_phi = phi.len();
    let mut d: Vec<i64> = vec![1; num_phi];

    for (&prime, &n_power) in n_factors.iter() {
        let mut found = false;
        for i in 0..num_phi {
            if phi_factors[i].contains_key(&prime) && phi_factors[i][&prime] >= n_power {
                d[i] *= prime.pow(n_power);
                found = true;
                break;
            }
        }
        if !found {
            return None;
        }
    }

    Some(d)
}

pub fn root_of_unity(modulus: i64, n: i64) -> i64 {
    let factors = factorize(modulus);

    let mut result = 1;
    // Compute the divisors d_i such that lcm(d_i for all i) = n
    let phi: Vec<i64> = factors.iter().map(|(&p, &e)| (p - 1) * p.pow(e - 1)).collect();
    let divisors = divisors_with_given_lcm(&phi, n).expect("Could not find divisors with LCM equal to n");

    for (i, (&p, &e)) in factors.iter().enumerate() {
        let d = divisors[i];  // Use the divisor for the current factor
        if d > 1 {
            let g = primitive_root(p, e);  // Find primitive root mod p^e
            let phi = (p - 1) * p.pow(e - 1); // Euler's totient function
            let exp = phi / d; // Compute exponent for order d
            let order_d_elem = mod_exp(g, exp, p.pow(e)); // Element of order d

            // Combine with the running result using CRT
            result = crt(result, modulus / p.pow(e), order_d_elem, p.pow(e));
        }
    }
    result
}

/// Compute the prime factorization of `n` (with multiplicities).
fn factorize(n: i64) -> HashMap<i64, u32> {
    let mut factors = HashMap::new();
    for factor in quick_factorize(n as u64) {
        *factors.entry(factor as i64).or_insert(0) += 1;
    }
    factors
}

/// Fast computation of a primitive root mod p^e
pub fn primitive_root(p: i64, e: u32) -> i64 {
    
    let g = primitive_root_mod_p(p);

    // Lift it to p^e
    let mut g_lifted = g;
    for _ in 1..e {
        if g_lifted.pow((p - 1) as u32) % p.pow(e) == 1 {
            g_lifted += p.pow(e - 1);
        }
    }
    g_lifted
}

/// Finds a primitive root modulo a prime p
fn primitive_root_mod_p(p: i64) -> i64 {
    let phi = p - 1;
    let factors = factorize(phi); // Reusing factorize to get both prime factors and multiplicities
    for g in 2..p {
        // Check if g is a primitive root by checking mod_exp conditions with all prime factors of phi
        if factors.iter().all(|(&q, _)| mod_exp(g, phi / q, p) != 1) {
            return g;
        }
    }
    0 // Should never happen
}

pub fn crt(a1: i64, n1: i64, a2: i64, n2: i64) -> i64 {
    let n = n1 * n2;
    let m1 = mod_inv(n1, n2); // Inverse of n1 mod n2
    let m2 = mod_inv(n2, n1); // Inverse of n2 mod n1
    let x = mod_add(a1 * m2 * n2, a2 * m1 * n1, n);
    if x < 0 { x + n } else { x }
}