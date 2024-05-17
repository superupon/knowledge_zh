# 为什么强枚举类型更安全

在C++中，传统的枚举类型（enum）有一些限制和问题。其中最主要的问题之一是，枚举值实际上是整数，可以与其他整数值随意混合和比较，这可能会导致意外的行为和错误。

例如，考虑以下枚举：

```cpp
enum Color {
    RED,
    GREEN,
    BLUE
};

enum Fruit {
    APPLE,
    BANANA,
    CHERRY
};
```

在这种情况下，以下代码是完全有效的：

```cpp
Color color = RED;
Fruit fruit = APPLE;

if (color == fruit) {
    // 这个代码块会被执行，因为 RED 和 APPLE 都是 0
}
```

这可能不是你想要的行为，但是编译器不会报错，因为它只是在比较两个整数。

C++11引入的强类型枚举（enum class）解决了这个问题。强类型枚举的值不会隐式转换为整数，也不能与整数进行比较。所以，如果你试图将两个不同的强类型枚举值进行比较，编译器会报错。

例如，以下代码会导致编译错误：

```cpp
enum class Color {
    RED,
    GREEN,
    BLUE
};

enum class Fruit {
    APPLE,
    BANANA,
    CHERRY
};

Color color = Color::RED;
Fruit fruit = Fruit::APPLE;

if (color == fruit) {  // 编译错误：不能比较 Color 和 Fruit
    // ...
}
```

这使得强类型枚举更加安全，更容易使用，减少了编程错误的可能性。
