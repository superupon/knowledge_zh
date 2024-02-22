#include <algorithm>
#include <iostream>
template <class ForwardIterator>
void mySwap(ForwardIterator i1, ForwardIterator i2) {
    typename std::iterator_traits<ForwardIterator>::value_type tmp = *i1;
    *i1 = *i2;
    *i2 = tmp;
}

int main() {
    std::vector<int> test = {10, 20, 30, 40};
    ::mySwap<std::vector<int>::iterator>(test.begin(), test.begin() + 1);

    for (int data : test) {
        std::cout << data << " ";
    }
    std::cout << std::endl;
    static_assert(std::is_same<std::iterator_traits<int*>::value_type, double>::value);
    return 0;
}