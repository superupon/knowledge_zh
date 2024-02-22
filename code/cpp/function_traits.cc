#include <functional>
#include <iostream>

using namespace std;

int main() {
    const function<int(int, int)> f = [](int x, int y) {return x + y;};
    cout << function_traits<decltype(f)>::const_qualified << endl;
}
