# std::unique_ptr 介绍

## std::unique_ptr线程安全性？

`std::unique_ptr`对并发访问并不是线程安全的。这意味着任何保证安全的源自多个线程的同时访问的内置同步机制都是不提供的。这和C++的标准库是一致的，它并不提供线程安全性。

以下是一些具体的原因:

1. **同时访问:** 如果一个线程在修改一个`std::unique_ptr`的同时（比如，reset或改变它管理的对象时），另外一个线程试图访问它（dereference，或检查是否为空），那么就会产生数据竞争，这会导致未定义行为。

2. **Ownership 语义:** The `std::unique_ptr` is designed to enforce unique ownership semantics, meaning that it assumes a single owner. As such, it isn't designed to handle the case where multiple threads might try to take ownership simultaneously or where ownership might need to be transferred between threads.

3. **No Synchronization Mechanism:** As mentioned earlier, `std::unique_ptr` doesn't contain any built-in synchronization mechanism like mutexes or atomic operations to ensure thread safety. This is by design, as adding such mechanisms would add overhead that isn't necessary in single-threaded contexts.

If you need to share a dynamically allocated object between multiple threads, consider using `std::shared_ptr` along with `std::mutex` or other synchronization primitives to ensure thread-safety. Alternatively, if the ownership of the `std::unique_ptr` needs to be transferred between threads, ensure that such transfers are done in a thread-safe manner (i.e., no two threads are accessing the `std::unique_ptr` simultaneously). 

Remember that even when using `std::shared_ptr`, only the control block (reference counts) is thread-safe, not the underlying object. You still need to synchronize access to the underlying object if it's being accessed from multiple threads.

## nullptr赋值给unique_ptr会发生什么？

在C++中，将`nullptr`赋值给一个 `std::unique_ptr` 会导致 `unique_ptr` 放弃对其当前管理的对象的所有权（如果有的话），并将其内部的原始指针设置为`nullptr`。如果 `unique_ptr` 在赋值之前已经管理了一个对象，那么该对象的析构函数会被调用，并且该对象会被正确地删除。

下面是一个示例：

```cpp
#include <iostream>
#include <memory>

class MyClass {
public:
    ~MyClass() {
        std::cout << "MyClass destructor called" << std::endl;
    }
};

int main() {
    std::unique_ptr<MyClass> ptr(new MyClass);
    
    // At this point, ptr is managing a new MyClass object.
    
    ptr = nullptr; // Assign nullptr to ptr.
    
    // MyClass destructor is called, the object is deleted,
    // and ptr no longer manages any object.
    
    return 0;
}
```

在上面的示例中，当我们将`nullptr`赋值给 `ptr` 时，`MyClass` 的析构函数会被调用，对象被删除，并且 `ptr` 不再管理任何对象。

这种行为是很有用的，因为它允许你在运行时显式地释放 `unique_ptr` 管理的资源，并且确保资源被正确地清理。

## 如果unique_ptr没有指向任何对象呢？比如说make_unique的时候，**入参是一个nullptr**

如果一个 `std::unique_ptr` 从未指向任何对象，或者已经被设置为 `nullptr`，再次将 `nullptr` 赋值给它不会有任何特别的效果。它会继续保持为 `nullptr` 状态，并且不会管理任何对象。

如果你通过 `std::make_unique` 创建一个 `std::unique_ptr` 并传递一个 `nullptr`，要注意，`std::make_unique` 用于动态分配一个对象并用给定的参数构造它。你不能直接将 `nullptr` 传递给 `std::make_unique` 作为要构造的对象。不过，你可以创建一个空的 `std::unique_ptr`。

这里有一个例子：

```cpp
#include <iostream>
#include <memory>

class MyClass {
public:
    MyClass() {
        std::cout << "MyClass constructor called" << std::endl;
    }
    ~MyClass() {
        std::cout << "MyClass destructor called" << std::endl;
    }
};

int main() {
    // Creating an empty unique_ptr
    std::unique_ptr<MyClass> ptr = nullptr;
    
    // It doesn't manage any object, so assigning nullptr again doesn't change anything
    ptr = nullptr;

    // Here is how you can use make_unique (it allocates and constructs an object)
    std::unique_ptr<MyClass> ptr2 = std::make_unique<MyClass>();

    return 0;
}
```

请注意，`std::unique_ptr` 在初始化时可以被设置为 `nullptr`，表示它不管理任何对象。当使用 `std::make_unique` 时，它将分配并构造一个新对象，并由 `std::unique_ptr` 管理。

## 为什么不可以make_unique一个抽象类的指针？

在 C++ 中，`std::make_unique` 用于动态创建一个对象并返回该对象的 `std::unique_ptr`。然而，抽象类是不能被实例化的。因为抽象类通常包含至少一个纯虚函数，它没有实现，所以不能创建抽象类的对象。这是抽象类的本质特性，用于作为基类为派生类提供一个公共接口。

下面是一个例子来说明这个概念：

```cpp
#include <memory>

class AbstractClass {
public:
    virtual void doSomething() = 0; // 纯虚函数，没有实现
};

class ConcreteClass : public AbstractClass {
public:
    void doSomething() override {
        // 具体的实现
    }
};

int main() {
    // 下面的代码是错误的，因为不能创建抽象类的实例
    // auto abstractPtr = std::make_unique<AbstractClass>();

    // 这是正确的，创建的是 ConcreteClass 的实例，它是 AbstractClass 的派生类
    auto concretePtr = std::make_unique<ConcreteClass>();
}
```

在这个例子中，你不能使用 `std::make_unique` 来创建 `AbstractClass` 的实例，因为它是一个抽象类。但是你可以创建它的派生类 `ConcreteClass` 的实例，因为 `ConcreteClass` 提供了纯虚函数的实现。
