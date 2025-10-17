use roots_of_unity::divisors_with_given_lcm;

fn main() {
    //check that we can take a list of numbers and compute divisors such that their lcm = a number
    let n = 8;
    let phis = vec![8, 2]; // Example phi values
    let divisors = divisors_with_given_lcm(&phis, n);
    println!("{:?}", divisors); // Output a set of divisors whose LCM is n

    //test the composite modulus case
    let modulus = 51; // Example modulus
    let n = 8;  // Must be a power of 2
    let omega = roots_of_unity::omega(modulus, n); // n-th root of unity
    println!("omega: {}", omega);
}
