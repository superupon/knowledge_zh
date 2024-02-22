Google:

Given a list of numbers and a number k, return whether any two numbers from the list add up to k
For example, given [10, 15, 3, 7] and k of 17, return true since 10 + 7 is 17.
Bonus: Can you do this in one pass?

Classical Problem from google, Find two number, and their sum is `K`


## Solution 1 Brute Force
```cpp
#include <iostream>
#include <vector>
#include <algorithm>
 
bool TwoSum(std::vector<int> data, int k)
{
    int index = 1;
    auto iterFind = std::find_if(data.begin(), data.end(), [=, &index](int val){
        int leftSum = k - val;
        auto iter = std::find(data.begin() + index, data.end(), leftSum);
        index ++;
        if(iter != data.end())
        {
            return true;
        }
    });
    return iterFind != data.end();   
}
```


Analysis: This method compares each element with the difference of k and the element's value across all subsequent elements in the list. It's a slightly optimized brute force method but still has a high time complexity.

## Solution 2: Sort + Binary Search

By sorting the data first, we can use binary search to find the complementary value for each element.

```cpp
bool TwoSumSortAndBinarySearch(std::vector<int> data, int k) {
    std::sort(data.begin(), data.end());
    int index = 1;
    auto iterFind = std::find_if(data.begin(), data.end(), [=, &index](int val) {
        int leftSum = k - val;
        bool isFound = std::binary_search(data.begin() + index, data.end(), leftSum);
        index++;
        return isFound;
    });
    return iterFind != data.end();
}
```
The complexity of this solution depends on the sorting algorithm (typically  $O(N*log_2(n)))$ and the binary search for each element $(log_2 N⁡$), so totally $O(N*log_2(N)))$.

## Solution 3: Sort + Two Pointers

After sorting, use two pointers – one at the start and one at the end of the array. Move the pointers based on whether their sum is less than, greater than, or equal to k.

```cpp
bool TwoSumSortAndTwoPointers(std::vector<int> data, int k) {
    std::sort(data.begin(), data.end());
    auto front = data.begin();
    auto end = data.end() - 1;
    while (front != end) {
        if (*front + *end == k) {
            return true;
        } else if (*front + *end < k) {
            front++;
        } else {
            end--;
        }
    }
    return false;
}
```
The main computational cost here is sorting, making the overall complexity 
$O(n*log_2(n))$.

## Solution 4: Hash Table

This approach uses a hash table to store the differences (k - value) for each element.

```cpp
Copy code
bool TwoSumOnePassBySet(std::vector<int> data, int k) {
    std::unordered_set<int> leftSums;
    auto iter = std::find_if(data.begin(), data.end(), [&leftSums, k](int val) {
        int leftSum = k - val;
        if (leftSums.find(val) != leftSums.end()) {
            return true;
        }
        leftSums.insert(leftSum);
        return false;
    });
    return iter != data.end();
}

```
This method achieves $O(n)$ complexity, making it the most efficient of the four solutions.

Finally, a test case is provided to compare the performance of these solutions with various sums.

```cpp
int main() {
    std::vector<int> data1 = {1, 3, 5, 8, 9};
    std::vector<int> sums = {4, 1, 2, 8, 17, 0, -1, 3};
    
    for (auto sum : sums) {
        std::cout << "Sum: " << sum << "\t";
        std::cout << TwoSumBruteForce(data1, sum) << "\t" 
                  << TwoSumSortAndBinarySearch(data1, sum) << "\t"
                  << TwoSumSortAndTwoPointers(data1, sum) << "\t"
                  << TwoSumOnePassBySet(data1, sum) << std::endl;
    }

    return 0;
}
```
These solutions demonstrate a progression from brute force to more sophisticated and efficient algorithms.





