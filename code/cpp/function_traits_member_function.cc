#include <iostream>
#include <tuple>
#include <type_traits>
#include <typeinfo>

template <typename T> struct FunctionTraits;

// Specialization for member functions
template <typename ClassType, typename ReturnType, typename... Args>
struct FunctionTraits<ReturnType (ClassType::*)(Args...) const> {
  enum { arity = sizeof...(Args) };
  using result_type = ReturnType;

  template <std::size_t i> struct arg {
    using type = typename std::tuple_element<i, std::tuple<Args...>>::type;
  };
};

class ParentClass {
public:
  virtual int parentFunction(int) const { return 1; }
};

class MyClass : public ParentClass {
public:
  int myFunction(int, double) const { return 0; }
  //int parentFunction(int) const override { return 3;}
};

ClassName functionName

#ClassName::#functionName


int main() {
  using Traits = FunctionTraits<decltype(&MyClass::myFunction)>;
  using ParentTraits = FunctionTraits<decltype(&MyClass::parentFunction)>;
  std::cout << Traits::arity << std::endl; // Output: 2
  if (std::is_same<Traits::arg<0>::type, int>::value) {
    std::cout << "first arg int" << std::endl;
  }
  return 0;
}
