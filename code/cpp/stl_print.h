#include <iostream>
#include <string>

template <typename T>
inline void print_elements(const T& coll, const std::string& optstr="") {
    std::cout << optstr;
    for (const auto& elem : coll) {
        std::cout << elem << ' ';
    }
    std::cout << std::endl;
}