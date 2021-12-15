use wasm_bindgen::prelude::*;

#[wasm_bindgen]
extern "C" {
    pub fn alert(msg: &str);
}

#[wasm_bindgen]
pub fn sqrt(n: f64) -> f64 {
    n.sqrt()
}

#[wasm_bindgen]
pub fn square(n: f64) -> f64 {
    n * n
}

#[wasm_bindgen]
pub fn power(a: i32, n: i32) -> i32 {
    let mut result: i32 = 1;
    for _i in 0..n {
        result *= a;
    }
    result
}
