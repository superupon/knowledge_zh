#include <type_traits>

template<typename T>
concept Integral = std::is_integral_v<T>;

template<Integral T>
T add(T a, T b) {
    return a + b;
}

int main() {
    int x = 5;
    int y = 10;
    int sum = add(x, y); // This will compile and run fine.
    /*
    double z = 5.0;
    double w = 10.0;
    double sum2 = add(z, w); // This would cause a compile error.
    */
    return 0;
}
