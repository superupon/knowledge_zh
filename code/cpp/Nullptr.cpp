#include <iostream>
using namespace std;

class Foo
{
  public:
    Foo(int testVal)
    {
        this->foo = testVal;
    }
    int foo;
};

//void testFoo(Foo& f)
//{
//    std::cout<<"test output is: "<< f.foo << std::endl;
//}

void testFoo(Foo* f)
{
    std::cout<<"test output is: "<< f->foo << std::endl;
}

// use g++ -std=gnu++0x Nullptr.cpp to compile this code
int main()
{

    Foo *f = new Foo(10);
    // With void testFoo(Foo& f)
    // This calling will cause invalid conversion from type std::nullptr_t to Foo&
    //testFoo(nullptr);

    // This also fails, because invalid conversion from int to Foo&
    //testFoo(0);

    testFoo(f);
    // With void testFoo(Foo* f)
    // This calling will cause runtime error, segmentation fault
    //testFoo(nullptr);
    // This calling will cause runtime error, segmentation fault
    testFoo(0);
    // Conclusion, pointer is a dangerous thing, compiler will no check it. use reference is better.
    return 0;
}
