# C++11新增的主要feature

C++11引入了许多重要的新特性，这些特性在很大程度上改变了C++编程的方式。以下是一些主要的新特性：

1. **自动类型推断**：`auto`关键字可以根据变量的初始化表达式自动推断其类型。

   ```cpp
   auto x = 5;  // x 是 int 类型
   auto y = 3.14;  // y 是 double 类型
   ```

2. **范围for循环**：允许在容器或数组上进行范围遍历。

   ```cpp
   std::vector<int> v = {1, 2, 3, 4, 5};
   for(auto i : v) {
       std::cout << i << '\n';
   }
   ```

3. **nullptr**：引入新的关键字 `nullptr`，用于表示空指针，以取代 `NULL`。

   ```cpp
   int* p = nullptr;
   ```

4. **初始化列表**：允许使用花括号 `{}` 对对象进行初始化。

   ```cpp
   std::vector<int> v = {1, 2, 3, 4, 5};  // 使用初始化列表
   ```

5. **lambda表达式**：匿名函数，可以在代码中定义并使用。

   ```cpp
   auto f = [](int x, int y) { return x + y; };
   int sum = f(5, 3);  // sum 现在是 8
   ```

6. **智能指针**：引入了新的智能指针类型，如 `std::unique_ptr` 和 `std::shared_ptr`，用于自动管理动态分配的内存。

7. **并发和多线程**：在语言级别支持并发和多线程编程，包括新的线程库和原子操作。

8. **新的字符串字面量**：例如原始字符串字面量，允许字符串中包含转义字符。

   ```cpp
   std::string path = R"(C:\Program Files\)";
   ```

9. **委托构造**：一个构造函数可以调用同类中的其他构造函数。

10. **用户定义的字面量**：允许自定义字面量的解析方式。

11. **强类型枚举**：C++11引入了新的枚举类型，称为强类型枚举或枚举类，这些枚举类型更加安全，更容易使用。

   ```cpp
   enum class Color { red, green, blue };
   ```

12. **静态断言**：`static_assert` 关键字可以在编译时进行断言。

   ```cpp
   static_assert(sizeof(int) == 4, "Integers are not 4 bytes on this platform");
   ```

13. **新的容器**：引入了新的容器类型，如 `std::array`、`std::forward_list` 和 `std::unordered_map`。

14. **新的算法**：标准库中添加了许多新的算法，包括一些新的排序算法和并行算法。

15. **尾返回类型**：函数可以使用新的语法指定尾返回类型，这在使用模板和自动类型推导时特别有用。

   ```cpp
   auto add(int x, int y) -> int {
       return x + y;
   }
   ```

16. **右值引用和移动语义**：引入了右值引用，它可以支持移动语义和完美转发，这可以提高代码的效率。

17. **默认和删除的函数**：可以使用 `default` 和 `delete` 关键字来默认生成或删除编译器自动生成的函数。

   ```cpp
   class NonCopyable {
   public:
       NonCopyable(const NonCopyable&) = delete;  // 删除复制构造函数
       NonCopyable& operator=(const NonCopyable&) = delete;  // 删除复制赋值运算符
   };
   ```

18. **属性**：引入了新的语法来指定属性，比如 `[[noreturn]]` 和 `[[deprecated]]`。

19. **线程局部存储**：`thread_local` 关键字可以用于声明线程局部变量。

20. **正则表达式库**：引入了新的正则表达式库，用于处理正则表达式。

这些都是C++11引入的一些新特性，还有更多的改进和增强，包括许多小的语言改变和标准库的增强。

