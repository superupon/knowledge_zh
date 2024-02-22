#include <iostream>
template <unsigned long N>
struct binary
{
    static unsigned const value = binary<N / 10>::value << 1 // prepend higher bits
                                  | N % 10;                  // to lowest bit
};
template <>      // specialization
struct binary<0> // terminates recursion
{
    static unsigned const value = 0;
};
unsigned const one = binary<1>::value;
unsigned const three = binary<11>::value;
unsigned const five = binary<101>::value;
unsigned const seven = binary<111>::value;
unsigned const nine = binary<1001>::value;

int main()
{
    std::cout << binary<100001>::value << std::endl;
    return 0;
}