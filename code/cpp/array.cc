#include <array>
#include <iostream>

int main() {
    std::array<int, 10> arr = {1, 2, 2, 10, 6, 7, 8}; // will it be checked?
    std::cout<< "Size of array" << arr.size() << std::endl;
    std::cout<< "Third Element" << arr[2] << std::endl;
    std::sort(arr.begin(), arr.end());

    for (int i : arr) 
        std::cout << i << " ";
    std::cout << std::endl;
    // output is just like this:
    // Size of array10
    // Third Element2
    // 0 0 0 1 2 2 6 7 8 10
}

