> Uber:
Given an array of integers, return a new array such that each element at index i of the new array is the product of all the numbers in the original array except the one at i.
For example, if our input was [1, 2, 3, 4, 5], the expected output would be [120, 60, 40, 30, 24], If our input was [3, 2, 1], the expected output would be [2, 3, 6]
Follow-up: what if you can't use division?

这个题难就难在，不能使用除法。

分析：对于这个输入，希望得到如下的结果。

如果直接做不可以，那么可以尝试将计算的结果拆分。比如说，对于第k个数，它的结果应该是这样的那样一来，就可以把数据拆分成两部分即，以及, 那么对于上面的结果，就可以分解成：

通过遍历数组中的元素，我们很容易可以得到以下两个

代码如下：
```cpp
#include <iostream>
#include <vector>
#include <algorithm>
 
std::vector<int> ProductOfAllNumbersExceptCurrent(const std::vector<int> &data)
{
    std::vector<int> productFromBegin;
    std::vector<int> productFromEnd;
    int product = 1;
    for (auto element : data)
    {
        productFromBegin.emplace_back(product);
        product *= element;
    }
    product = 1;
    for (auto iter = data.end() - 1; iter >= data.begin(); iter--)
    {
        productFromEnd.emplace_back(product);
        product *= *iter;
    }
 
    std::reverse(productFromEnd.begin(), productFromEnd.end());
 
    std::vector<int> returnVal;
    int index = 0;
    for (auto element : productFromBegin)
    {
        returnVal.push_back(element * productFromEnd[index++]);
    }
 
    return returnVal;
}
 
int main()
{
    std::vector<std::vector<int>> testDataArrays;
    testDataArrays.push_back({1, 2, 3, 4, 5});
    testDataArrays.push_back({3, 2, 1});
 
    std::for_each(testDataArrays.begin(), testDataArrays.end(), [](const std::vector<int> &testData) {
        auto ret = ProductOfAllNumbersExceptCurrent(testData);
        std::for_each(ret.begin(), ret.end(), [](int val) {
            std::cout << val << "  ";
        });
        std::cout << std::endl;
    });
    return 0;
}
```cpp
复杂度为线性。
