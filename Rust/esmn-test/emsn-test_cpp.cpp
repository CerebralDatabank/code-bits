#include <iostream>
#include <cmath>

int main() {
    std::cout << "Hello, World!" << std::endl;
    std::cout << "Square roots from 1 to 100:" << std::endl;
    for (int n = 1; n <= 100; n++) {
        std::cout << sqrt(n) << std::endl;
    }
    std::cout << "Done!" << std::endl;
}
