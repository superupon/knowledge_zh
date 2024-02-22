
#include <string>
#include <vector>
#include <iostream>
#include <algorithm>

int main() {
    std::vector<std::string> test = {"hahaha", "test"};
    std::string substring = "ha";

    auto result = std::find_if(test.begin(), test.end(), [&substring](const std::string& str) {
        return str.find(substring) != std::string::npos;
    });

    if (result == test.end()) {
        std::cout << "Substring not found" << std::endl;
    } else {
        std::cout << "Substring found: " << *result << std::endl;
    }

    return 0;
}
