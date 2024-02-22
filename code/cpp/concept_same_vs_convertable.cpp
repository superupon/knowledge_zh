#include <type_traits>
#include <concepts>

int main() {
    static_assert(!std::same_as<int, double>); 
    //static_assert(std::same_as<int, double>); // This line will not compile
    static_assert(std::convertible_to<int, double>);
    return 0;
}