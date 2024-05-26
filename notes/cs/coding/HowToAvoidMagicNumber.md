# 如何避免魔数

在 C++ 中，为了提高代码的可读性和维护性，我们应该尽量避免使用“魔数”（magic numbers），即直接在代码中硬编码的数值。除了使用宏以外，有几种方法可以更好地表示这些数值：

1. **常量**：你可以使用常量来表示魔数。这是一种常见的做法，因为它允许你给这个数字一个描述性的名称，这样其他人（或未来的你）阅读代码时，就能更容易理解它的含义。

   ```cpp
   const int MaxNumberOfPlayers = 4;
   ```

2. **枚举**：对于一组相关的魔数，可以使用枚举。这对于表示一组互斥的值特别有用。

   ```cpp
   enum class Color {
       Red = 0xFF0000,
       Green = 0x00FF00,
       Blue = 0x0000FF
   };
   ```

3. **静态常量成员**：如果常量是类的一部分，并且与类的实例无关，则可以使用静态常量成员。

   ```cpp
   class Circle {
   public:
       static const double Pi = 3.14159;
       // ...
   };
   ```

4. **constexpr**：使用 `constexpr` 关键字可以定义编译时常量。这对于定义在编译时需要计算的常量特别有用。

   ```cpp
   constexpr double SquareRootOfTwo = 1.41421356237;
   ```

5. **std::array 或 std::vector 初始化**：如果你有一系列的魔数，你可能想要使用 `std::array` 或 `std::vector` 来初始化它们。

   ```cpp
   const std::array<int, 3> SomeImportantValues = {3, 4, 5};
   ```

通过使用这些技巧，你的代码将变得更加清晰和易于维护。

## constexpr可以使用在类成员中

是的，`constexpr` 可以用于类成员。在类中，你可以使用 `constexpr` 来定义静态成员常量，或者用于成员函数，表示该函数是一个常量表达式函数。

1. **用于静态成员常量**：

   你可以在类内部使用 `constexpr` 来定义一个静态成员常量。这个常量可以在编译时求值，并且只有一个副本。

   ```cpp
   class Circle {
   public:
       static constexpr double Pi = 3.14159;
       // ...
   };
   ```

   注意，静态数据成员必须是字面类型，才能用 `constexpr` 修饰。

2. **用于成员函数**：

   `constexpr` 还可以用于成员函数，表示该函数可以在编译时执行（如果给定的参数是编译时常量）。当用于成员函数时，该函数必须满足一定的要求，例如不能有虚函数、不能是析构函数等。

   ```cpp
   class MyInteger {
   public:
       constexpr MyInteger(int value) : value(value) {}
       
       constexpr int getValue() const {
           return value;
       }

   private:
       int value;
   };
   
   // 用法示例：
   constexpr MyInteger obj(10);
   static_assert(obj.getValue() == 10, "Compile-time check");
   ```

在使用 `constexpr` 时，请注意，它只能用于能够在编译时求值的表达式和函数。如果一个表达式的值在运行时计算，那么它不能被标记为 `constexpr`。

## constexpr可以用在函数内部

`constexpr` 可以用在函数内部来定义局部常量。当你在函数内部使用 `constexpr` 时，它表示该变量的值是在编译时已知的，并且在程序的执行期间不会发生变化。这对于优化和提高代码的可读性是有帮助的。

下面是一个例子：

```cpp
#include <iostream>

int main() {
    constexpr double gravity = 9.81; // 重力加速度 (m/s^2)

    double mass = 10.0; // 质量 (kg)
    double weight = mass * gravity; // 重力 (N)

    std::cout << "Weight is " << weight << " Newtons" << std::endl;
    return 0;
}
```

在这个例子中，`gravity` 是一个在编译时已知的常量，并且在函数的执行过程中不会改变。通过使用 `constexpr`，我们清楚地表明这个值是一个编译时常量，并且允许编译器对其进行优化。
