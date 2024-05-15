# C++在已经分配内存上构造对象

可以使用placement new的语法。

> Placement new is a variant of the new operator that allows you to allocate memory and call a constructor on that memory location explicitly.

```cpp
#include <iostream>

class MyClass {
public:
    MyClass() {
        std::cout << "MyClass constructor called" << std::endl;
    }
};

int main() {
    char* memory = new char[sizeof(MyClass)]; // allocate memory

    MyClass* myClassObject = new (memory) MyClass(); // call constructor on memory location

    // use myClassObject as you would any other object

    myClassObject->~MyClass(); // call destructor explicitly

    delete[] memory; // deallocate memory
    return 0;
}
```

在这个例子中，内存的分配是由new char来提供的。MyClass在memory这个指针之上进行对象的构造。
