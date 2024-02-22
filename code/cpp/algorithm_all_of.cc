#include <algorithm>
#include <iostream>

int main() {
  // Create a vector of integers.
  std::vector<int> numbers = {1, 2, 3, 4, 5};

  // Check if all of the numbers are even.
  bool allEven = std::all_of(numbers.begin(), numbers.end(), [](int x) { return x % 2 == 0; });

  // Print the result.
  std::cout << "All of the numbers are even: " << allEven << std::endl;

  return 0;
}
