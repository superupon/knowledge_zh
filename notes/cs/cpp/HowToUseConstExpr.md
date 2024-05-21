# constexpr的使用

C++ 的 `constexpr` 和 `if constexpr` 是编译时计算的强大工具。它们可以用于在编译时执行计算，并将结果嵌入到生成的代码中，从而提高运行时性能。以下是可以在编译时进行的一些类型的计算：

1. **常量表达式**：`constexpr` 可以用于声明常量表达式，这些表达式的值可以在编译时计算出来。这包括简单的算术操作，如加减乘除，以及对 `constexpr` 函数的调用。例如：

```cpp
constexpr int square(int x) {
    return x * x;
}

constexpr int val = square(10); // val 的值在编译时就已经确定为 100
```

2. **条件编译**：`if constexpr` 可以用于条件编译。这意味着编译器在编译时会根据条件选择执行哪个分支，并且只会编译选中的分支。这对于模板元编程特别有用。例如：

```cpp
template <typename T>
auto getValue(T t) {
    if constexpr (std::is_pointer_v<T>) {
        return *t; // 如果 T 是指针，返回指针所指向的值
    } else {
        return t; // 否则直接返回 t
    }
}
```

3. **类型元编程**：模板和 `constexpr` 可以用于在编译时进行类型计算。这是一种强大的技术，可以用于生成针对特定类型优化的代码，或者实现在运行时无法实现的类型安全检查。例如，我们可以编写一个 `constexpr` 函数，用于在编译时计算出一个类型的大小：

```cpp
template <typename T>
constexpr size_t sizeOf() {
    return sizeof(T);
}

constexpr auto size = sizeOf<int>(); // size 的值在编译时就已经确定为 sizeof(int)
```

这只是 `constexpr` 和 `if constexpr` 用法的一部分。C++ 的编译时计算能力非常强大，可以用于实现各种复杂的编译时算法和优化。
