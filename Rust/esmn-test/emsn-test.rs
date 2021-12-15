fn main() {
    println!("Hello, World!");
    println!("Square roots from 1 to 100:");
    for n in 1..100 {
        println!("{}", (n as f64).sqrt());
    }
    println!("Done!");
}
