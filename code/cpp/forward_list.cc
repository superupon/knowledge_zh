#include <forward_list>
#include <iostream>

int main() {
    std::forward_list<int> fl = {1, 2, 3, 4, 5};

    // Insert at the front
    fl.push_front(0);

    // Insert after the first element
    fl.insert_after(fl.begin(), -1);

    // Erase the second element
    fl.erase_after(fl.begin());

    // Print the forward list
    for (int i : fl) {
        std::cout << i << " ";
    }

    return 0;
}

