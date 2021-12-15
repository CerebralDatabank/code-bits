use std::fmt;

#[derive(Copy, Clone, fmt::Debug)] // let a = b; will make a copy (this is possible because all data members are also marked Copy)
struct Point {
    x: i32,
    y: i32,
}

impl Point {
    fn new(x: i32, y: i32) -> Point {
        Point { x, y } // Shorthand for Point { x: x, y: y }
    }

    fn dist_to(&self, other: &Point) -> f64 {
        (((self.x.pow(2) + other.x.pow(2)) + (self.y.pow(2) - other.y.pow(2))) as f64).sqrt()
    }

    fn y_over_x(&self) -> f64 {
        self.y as f64 / self.x as f64
    }
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "({x}, {y})", x = self.x, y = self.y)
    }
}

fn main() {
    let origin = Point { x: 0, y: 0 }; // Declare struct directly
    let p = Point::new(3, 2); // Use new (returns a struct); both methods do the same thing
    // Methods defined in impl Point { ... } are accessible in both
    println!("The point P: {}", p);
    println!("The origin point: {}", origin);
    println!("Distance from P to origin: {}", p.dist_to(&origin));
    println!("Y over X for P: {}", p.y_over_x());
    println!("Y over X for origin: {}", origin.y_over_x());
}
