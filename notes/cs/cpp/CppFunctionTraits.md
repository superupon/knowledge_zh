# C++的FunctionTrait技巧

FunctionTraits是一种在编译时提取函数类型信息的技术。它允许你可以操纵函数类型，比如返回返回值，参数或者其它函数的特性.

这里是一个非常基本的例子。

```cpp
#include <iostream>
#include <type_traits>

template <typename T>
struct FunctionTraits;

template <typename R, typename... Args>
struct FunctionTraits<R(Args...)>
{
    using ReturnType = R;

    static constexpr std::size_t Arity = sizeof...(Args);

    template <std::size_t N>
    struct Argument
    {
        static_assert(N < Arity, "Invalid argument index.");
        using Type = typename std::tuple_element<N, std::tuple<Args...>>::type;
    };
};

// Example function
int add(int a, int b)
{
    return a + b;
}

int main()
{
    using Traits = FunctionTraits<decltype(add)>;

    std::cout << "Return type: " << typeid(Traits::ReturnType).name() << std::endl;
    std::cout << "Number of arguments: " << Traits::Arity << std::endl;
    std::cout << "First argument type: " << typeid(Traits::Argument<0>::Type).name() << std::endl;

    return 0;
}
```

In this example, the `FunctionTraits` struct is specialized for function types. It provides nested types such as `ReturnType` (return type of the function), `Arity` (number of arguments), and `Argument<N>` (type of the N-th argument). The example then demonstrates how to use `FunctionTraits` to extract and print information about the `add` function.

FunctionTraits can be a powerful technique when you need to work with function types in a generic or metaprogramming context, allowing you to manipulate and extract information about functions at compile-time.