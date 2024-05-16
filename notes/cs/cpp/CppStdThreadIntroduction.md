# std::thread的相关知识

## std::thread如何获取thread id ?

在 C++ 中，你可以使用 `std::thread` 的 `get_id()` 成员函数来获取一个线程的 ID。这将返回一个 `std::thread::id` 对象，你可以将它打印出来或者在其他地方使用。

以下是一个简单的例子：

```cpp
#include <iostream>
#include <thread>

void my_thread_function() {
    std::cout << "Hello from thread " << std::this_thread::get_id() << "\n";
}

int main() {
    std::thread t(my_thread_function);
    std::cout << "Hello from main " << t.get_id() << "\n";
    t.join();
    return 0;
}
```

在这个例子中，我们创建了一个新的线程 `t` 并启动了 `my_thread_function`。在主线程和子线程中，我们都打印出了当前线程的 ID。在子线程中，我们使用了 `std::this_thread::get_id()` 来获取当前线程的 ID。在主线程中，我们使用了 `t.get_id()` 来获取 `t` 线程的 ID。

## `std::thread_id`作为unordered_map的key会降低查找效率吗？

The `std::thread::id` 类型被设计成轻量级的，适合做为关联容器（比如`std::unordered_map`）的key值的形式。 不同的C++实现可能有所不同，但它通常被实现为整形数字或指针的一个wrapper。

When used as a key in a hash-based container like `std::unordered_map`, the primary factor affecting lookup efficiency is the quality of the hash function. C++ Standard Library provides a specialization of `std::hash` for `std::thread::id`, so you can use `std::thread::id` as a key in `std::unordered_map` without providing your own hash function.

Here is an example of using `std::thread::id` as a key in an `std::unordered_map`:

```cpp
#include <iostream>
#include <unordered_map>
#include <thread>

int main() {
    std::unordered_map<std::thread::id, int> map;
    map[std::this_thread::get_id()] = 42;
    
    std::cout << "Current thread's value: " << map[std::this_thread::get_id()] << std::endl;
    
    return 0;
}
```

In this code, we are creating a map from `std::thread::id` to `int`, and then adding a key-value pair to the map with the current thread's ID as the key and `42` as the value. Then we print the value associated with the current thread's ID.

So, to answer your question, using `std::thread::id` as the key in an `std::unordered_map` is unlikely to significantly degrade lookup performance, as long as the number of different thread IDs is not so large as to cause excessive hash collisions.
