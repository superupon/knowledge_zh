#include <concepts>
#include <iostream>

template<std::same_as<int> T>
void print(T value) {
    std::cout << "Value: " << value << std::endl;
}

int main() {
    print(5);     // This will compile
    // print(5.0); // This will not compile
    return 0;
}
