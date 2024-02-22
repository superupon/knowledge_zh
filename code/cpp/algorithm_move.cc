#include <iostream>
#include <vector>
#include <utility>

int main() {
    std::vector<int> source = {1, 2, 3, 4, 5};
    std::vector<int> destination;

    destination = std::move(source);

    std::cout << "destination: ";
    for (const auto& num : destination) {
        std::cout << num << " ";
    }
    std::cout << std::endl;

    std::cout << "source: ";
    for (const auto& num : source) {
        std::cout << num << " ";
    }
    std::cout << std::endl;

    return 0;
}
