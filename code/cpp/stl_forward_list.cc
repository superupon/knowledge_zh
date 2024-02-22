#include <forward_list>
#include <iterator>
#include "stl_print.h"

int main() {
    std::forward_list<int> list = {1, 2, 3, 4, 5, 97, 98, 99};
    // one way to insert element into specific location
    auto posBefore = list.before_begin();
    for (auto pos = list.begin(); pos != list.end(); pos++, posBefore++) {
        if (*pos %2 == 0) {
            break;
        }
    }

    list.insert_after(posBefore, 42);
    print_elements(list);

    // another way
    posBefore = list.before_begin();
    for (; std::next(posBefore) != list.end(); posBefore++) {
        if (*std::next(posBefore) % 3 == 0) {
            break;
        }
    }
    list.insert_after(posBefore, 43);
    print_elements(list);
    return 0;
}