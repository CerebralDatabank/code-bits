use std::fmt;
use std::io;

fn main() {
    println!("Hello, world!");

    print!("Enter your name: ");
    let mut name = String::new();
    io::stdin()
        .read_line(&mut name)
        .expect("Failed to read from stdin");
    println!("\nHello, {}!", name.trim());

    const LEET: i32 = 1337;
    println!("LEET is {}", LEET);

    let mut a = 101;
    let b = 22;
    println!("a is {a}", a = a);
    a = 5000;
    println!("a is now {n}", n = a);
    println!("b is {}", b);

    let pt = Point { x: 3.0, y: 2.0 };
    println!("My point: {}", pt);

    println!("Goodbye!");
}

#[derive(fmt::Debug)]
struct Point {
    x: f64,
    y: f64,
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "Point: ({}, {})", self.x, self.y)
    }
}
