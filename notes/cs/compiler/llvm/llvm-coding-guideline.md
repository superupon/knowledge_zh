# LLVM Coding Guideline
## 1. 介绍
本文档描述了LLVM项目中使用的编码标准。虽然不应将任何编码标准视为所有情况下必须遵守的绝对要求，但对于像LLVM这样采用库设计的大型代码库，编码标准尤为重要。

虽然本文档可能为某些机械格式问题、空白或其他“微观细节”提供指导，但这些不是固定的标准。始终遵循以下金科玉律：

如果您正在扩展、增强或修复已实现的代码，请使用已经使用的风格，以便源代码保持一致且易于理解。

请注意，某些代码库（例如libc++）有特殊原因偏离编码标准。例如，在libc++的情况下，这是因为命名和其他约定由C++标准决定。

某些约定在代码库中并不统一（例如命名约定）。这是因为它们相对较新，并且在它们实施之前编写了大量代码。我们的长期目标是让整个代码库遵循这些约定，但我们明确不希望有大规模重构现有代码的补丁。另一方面，如果您即将以其他方式更改类的方法，可以合理地重新命名这些方法。请单独提交此类更改以便代码审查更容易。

这些指南的最终目的是提高我们共享源代码库的可读性和可维护性。

## 2. 语言、库和标准
LLVM及其他使用这些编码标准的LLVM项目中的大多数源代码是C++代码。在某些情况下，由于环境限制、历史限制或导入的第三方源代码中使用了C代码。一般来说，我们倾向于选择符合标准、现代和可移植的C++代码作为首选的实现语言。

对于自动化、构建系统和实用脚本，Python是首选并且在LLVM代码库中广泛使用。

### 2.1 C++标准版本
除非另有说明，LLVM子项目使用标准的C++17代码并避免不必要的供应商特定扩展。
尽管如此，我们限制自己使用主要工具链支持的主机编译器中可用的功能（请参阅LLVM系统入门页面，软件部分）。

每个工具链提供的可接受功能参考：
Clang: Clang C++状态
libc++: libc++ C++17状态
GCC: GCC C++状态
libstdc++: libstdc++手册
MSVC: MSVC语言一致性

此外，cppreference.com上有支持的C++功能的编译器比较表。

### 2.2 C++标准库
我们鼓励使用C++标准库设施或LLVM支持库，而不是实现自定义数据结构，只要它们适用于特定任务。LLVM及相关项目尽可能强调和依赖标准库设施和LLVM支持库。

LLVM支持库（例如，ADT）实现了标准库中缺少的专业数据结构或功能。此类库通常在llvm命名空间中实现，并遵循预期的标准接口（如果有）。

当C++和LLVM支持库提供类似功能且没有特别原因偏向C++实现时，通常更倾向于使用LLVM库。例如，llvm::DenseMap几乎总是应该使用，而不是std::map或std::unordered_map，llvm::SmallVector通常应使用，而不是std::vector。

我们明确避免使用一些标准设施，如I/O流，而是使用LLVM的流库（raw_ostream）。有关这些主题的更多详细信息，请参阅LLVM程序员手册。

有关LLVM数据结构及其权衡的更多信息，请查阅程序员手册的相关部分。

### 2.3 Python版本和源代码格式化
当前需要的Python最低版本记录在LLVM系统入门部分。LLVM代码库中的Python代码应仅使用此版本Python中可用的语言功能。

LLVM代码库中的Python代码应遵循PEP 8中概述的格式化指南。

为了一致性并减少变更，代码应使用符合PEP 8的black实用程序自动格式化。使用其默认规则。例如，避免指定--line-length，即使默认不是80。默认规则可能在black的主要版本之间发生变化。为了避免格式规则的不必要变更，我们目前在LLVM中使用black版本23.x。

在贡献与格式无关的补丁时，您应该仅格式化补丁修改的Python代码。为此，请使用darker实用程序，它会在仅修改的Python代码上运行默认black规则。这应该确保补丁在LLVM的预提交CI中通过Python格式检查，该CI也使用darker。在贡献专门用于重新格式化Python文件的补丁时，使用black，它目前仅支持格式化整个文件。

以下是一些快速示例，但请参阅black和darker文档了解详细信息：

```Bash
$ pip install black=='23.*' darker # 安装black 23.x和darker
$ darker test.py                   # 格式化未提交的更改
$ darker -r HEAD^ test.py          # 还格式化上次提交的更改
$ black test.py                    # 格式化整个文件
```

您可以指定目录而不是单个文件名给darker，它会找到更改的文件。然而，如果一个目录很大，如LLVM代码库的克隆，darker可能会非常慢。在这种情况下，您可能希望使用git列出更改的文件。例如：

```Bash
$ darker -r HEAD^ $(git diff --name-only --diff-filter=d HEAD^)
```

## 3. 机械性源代码问题
### 3.1 源代码格式
3.1.1 注释
注释对于可读性和可维护性非常重要。编写注释时，请将其写成英文散文，使用正确的大小写、标点符号等。目标是描述代码试图做什么和为什么，而不是微观层面上的如何。这里有一些重要的事情需要记录：

文件头
每个源文件都应该有一个头，描述文件的基本目的。标准头看起来像这样：

C++
//===-- llvm/Instruction.h - Instruction class definition -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file contains the declaration of the Instruction class, which is the
/// base class for all of the VM instructions.
///
//===----------------------------------------------------------------------===//

关于此特定格式的一些注意事项：“-*- C++ -*-”字符串在第一行，用于告诉Emacs源文件是C++文件，而不是C文件（Emacs默认假定.h文件是C文件）。

注意: 此标签在.cpp文件中不是必需的。文件名也在第一行，并有一个非常简短的描述文件目的。

文件的下一部分是简洁的注释，定义了文件发布的许可证。这使得源代码可以在什么条款下分发变得非常清晰，不应以任何方式修改。

主体是Doxygen注释（通过///注释标记而不是通常的//来识别），描述文件的目的。第一句话（或以\brief开头的段落）用作摘要。任何附加信息应通过空行分隔。如果算法基于某篇论文或在其他来源中有描述，请提供参考。

头文件保护
头文件的保护应为使用此头文件的用户将要#include的全大写路径，使用‘_’代替路径分隔符和扩展名。例如，头文件llvm/include/llvm/Analysis/Utils/Local.h将作为#include "llvm/Analysis/Utils/Local.h"被包含，所以它的保护是LLVM_ANALYSIS_UTILS_LOCAL_H。

类概述
类是面向对象设计的基本部分。因此，类定义应有一个注释块，解释类的用途和工作原理。每个非平凡类都应有一个doxygen注释块。

方法信息
方法和全局函数也应有文档注释。简要说明其功能和描述边界情况即可。读者应该能够在不阅读代码的情况下理解如何使用接口。
这里需要谈到的是，当发生意外情况时会发生什么，例如，方法是否返回null？

3.1.2 注释格式
一般来说，偏向使用C++风格的注释（//用于普通注释，///用于doxygen文档注释）。但是，有几种情况下使用C风格（/* */）注释是有用的：

编写兼容C89的C代码时。
编写可能被C源文件#include的头文件时。
编写被只接受C风格注释的工具使用的源文件时。

文档化作为实际参数传递的常量的意义时。这对于bool参数，或传递0或nullptr的情况尤为有用。注释应包含参数名称，该名称应有意义。例如，以下调用中的参数含义不清楚：

C++
Object.emitName(nullptr);

使用内联C风格注释可以使意图明显：

C++
Object.emitName(/*Prefix=*/nullptr);

不鼓励注释掉大

块代码，但如果确实需要这样做（出于文档目的或调试打印的建议），使用#if 0和#endif。这些嵌套正确，比C风格注释总体上表现更好。

3.1.3 Doxygen在文档注释中的使用
使用\file命令将标准文件头转换为文件级注释。

为所有公共接口（公共类，成员和非成员函数）包括描述性段落。避免重复API名称中可以推断的信息。第一句话（或以\brief开头的段落）用作摘要。尝试使用单句作为\brief以减少视觉杂乱。将详细讨论放入单独的段落中。

要在段落中引用参数名称，请使用\p name命令。不要使用\arg name命令，因为它会启动一个包含参数文档的新段落。

将非内联代码示例包裹在\code ... \endcode中。

要记录函数参数，请用\param name命令开始一个新段落。如果参数用作输出或输入/输出参数，请分别使用\param [out] name或\param [in,out] name命令。

要描述函数返回值，请用\returns命令开始一个新段落。

一个最小的文档注释：

C++
/// 将xyzzy属性设置为\p Baz。
void setXyzzy(bool Baz);

一个使用所有Doxygen功能的文档注释：

C++
/// 执行foo和bar。
///
/// 如果\p Baz为真，则不会以通常方式执行foo。
///
/// 典型用法：
/// \code
///   fooBar(false, "quux", Res);
/// \endcode
///
/// \param Quux foo的类型。
/// \param [out] Result 在foo成功时填充bar序列。
///
/// \returns 成功时返回true。
bool fooBar(bool Baz, StringRef Quux, std::vector<int> &Result);

不要在头文件和实现文件中重复文档注释。将公共API的文档注释放在头文件中。私有API的文档注释可以放在实现文件中。无论如何，实现文件可以根据需要添加其他注释（不一定是Doxygen标记）来解释实现细节。

不要在注释的开头重复函数或类名。对人类来说，显而易见正在记录哪个函数或类；自动文档处理工具足够智能，可以将注释绑定到正确的声明。

避免：

C++
// Example.h:

// example - 执行重要操作。
void example();

// Example.cpp:

// example - 执行重要操作。
void example() { ... }

首选：

C++
// Example.h:

/// 执行重要操作。
void example();

// Example.cpp:

/// 构建一个B树以执行foo。参见某篇论文...
void example() { ... }

3.1.4 错误和警告消息
清晰的诊断消息对于帮助用户识别和修复其输入中的问题非常重要。使用简洁但正确的英文散文，向用户提供理解问题所需的上下文。另一个匹配其他工具通常生成的错误消息样式，在首句首字母小写，并在最后一句句号结束前不加句号。如果句子以其他标点符号结尾，例如“忘记了‘;’？”仍应如此。

例如，这是一个好的错误消息：

C++
error: file.o: section header 3 is corrupt. Size is 10 when it should be 20

这是一个不好的消息，因为它没有提供有用的信息并且使用了错误的样式：

C++
error: file.o: Corrupt section header.

与其他编码标准一样，单个项目，例如Clang静态分析器，可能有不符合此标准的预先存在的样式。如果整个项目一致使用不同的格式方案，请使用该样式。否则，本标准适用于所有LLVM工具，包括clang，clang-tidy等。

如果工具或项目没有现有的函数来发出警告或错误，请使用Support/WithColor.h中提供的错误和警告处理程序，以确保它们以适当的样式打印，而不是直接打印到stderr。

在使用report_fatal_error时，请遵循与常规错误消息相同的消息标准。断言消息和llvm_unreachable调用不必遵循相同的样式，因为它们是自动格式化的，因此这些指南可能不适用。

3.1.5 #include风格
在头文件注释（和include保护，如果是头文件）之后，列出文件所需的最少#includes列表。我们希望这些#includes按以下顺序列出：

主模块头文件

本地/私有头文件

LLVM项目/子项目头文件（clang/..., lldb/..., llvm/..., 等）

系统#includes

每个类别应按完整路径字典顺序排序。

主模块头文件适用于实现接口的.cpp文件。这个#include应始终首先包含，无论它在文件系统中的位置。通过在实现接口的.cpp文件中首先包含头文件，我们确保头文件没有任何隐藏的依赖项，而这些依赖项应该是明确#include的。这也是.cpp文件中接口定义位置的文档。

LLVM项目和子项目头文件应从最具体到最不具体分组，原因如上所述。例如，LLDB依赖clang和LLVM，而clang依赖LLVM。因此，LLDB源文件应首先包含lldb头文件，然后是clang头文件，最后是llvm头文件，以减少LLDB头文件因在主源文件或某些较早头文件中之前包含而意外拾取缺少的include的可能性。clang也应首先包含其自己的头文件，然后包含llvm头文件。此规则适用于所有LLVM子项目。

3.1.6 源代码宽度
编写的代码应适合80列以内。

代码宽度必须有限制，以允许开发人员在一个适度显示屏上并排显示多个文件。如果要选择宽度限制，虽然有些武断，但最好选择一些标准。选择90列（例如）而不是80列不会增加任何显著价值，并且对打印代码有害。而且，许多其他项目已经标准化为80列，所以有些人已经配置了他们的编辑器（而不是其他，如90列）。

3.1.7 空白
在所有情况下，源文件中应优先使用空格而不是制表符。人们对缩进级别和缩进样式的偏好不同；这没问题。问题在于，不同的编辑器/查看器会将制表符扩展到不同的制表符停止位置。这可能导致代码完全不可读，处理起来不值得。

一如既往，遵循上述金科玉律：如果您正在修改和扩展现有代码，请遵循现有代码的风格。

不要添加尾随空白。一些常见的编辑器在保存文件时会自动删除尾随空白，这会导致差异和提交中出现无关的更改。

将Lambda格式化为代码块
格式化多行lambda时，将其格式化为代码块。如果语句中只有一个多行lambda，并且语句中没有表达式在其之后语法上，则将缩进降低到标准的两格缩进，就像if语句块一样：

C++
std::sort(foo.begin(), foo.end(), [&](Foo a, Foo b) -> bool {
  if (a.blah < b.blah)
    return true;
  if (a.baz < b.baz)
    return true;
  return a.bam < b.bam;
});

为了充分利用这种格式，如果设计一个接受延续或单个可调用参数的API（无论是函数对象还是std::function），应尽可能将其作为最后一个参数。

如果语句中有多个多行lambda，或lambda之后有其他参数，将块从[]的缩进开始再缩进两格：

C++
dyn_switch(V->stripPointerCasts(),
           [] (PHINode *PN) {
             // 处理PHI...
           },
           [] (SelectInst *SI) {
             // 处理选择...
           },
           [] (LoadInst *LI) {
             // 处理加载...
           },
           [] (AllocaInst *AI) {
             // 处理alloca...
           });

括号初始化列表
从C++11开始，有显著更多的使用括号列表来执行初始化。例如，它们可以用于在表达式中构造聚合临时对象。它们现在有了一种自然的方式，可以在彼此之间以及函数调用中嵌套，以构建聚合（如选项结构）中的局部变量。

历史上常见的聚合变量括号初始化格式在深层嵌套、一般表达式上下文、函数参数和lambda中并不适用。我们建议新代码使用一个简单的规则来格式化括号初始化列表：将括号视为函数调用中的括号。格式化规则完全匹配已经熟知的嵌套函数调用的格式化规则。例如：

C++
foo({a, b, c}, {1, 2, 3});

llvm::Constant *Mask[] = {
    llvm::ConstantInt::get(llvm::Type::getInt32Ty(getLLVMContext()), 0),
    llvm::ConstantInt::get(llvm::Type::getInt32Ty(getLLVMContext()), 1),
    llvm::ConstantInt::get(llvm

::Type::getInt32Ty(getLLVMContext()), 2)};

这种格式方案还使得使用诸如Clang Format之类的工具进行可预测、一致和自动格式化变得特别容易。

### 3.2 语言和编译器问题
3.2.1 将编译器警告视为错误
编译器警告通常是有用的，有助于改进代码。那些没有用的警告，通常可以通过小的代码更改来抑制。例如，在if条件中赋值通常是个拼写错误：

C++
if (V = getValue()) {
  ...
}

几个编译器将对此代码打印警告。可以通过添加括号来抑制：

C++
if ((V = getValue())) {
  ...
}

3.2.2 编写可移植代码
在几乎所有情况下，都可以编写完全可移植的代码。当您需要依赖于非可移植代码时，将其放在一个定义良好且文档化的接口之后。

3.2.3 不要使用RTTI或异常
为了减少代码和可执行文件的大小，LLVM不使用异常或RTTI（运行时类型信息，例如，dynamic_cast<>）。

话虽如此，LLVM确实大量使用了一种手工滚动的RTTI形式，使用模板如isa<>、cast<>和dyn_cast<>。这种RTTI是选择性加入的，可以添加到任何类中。

3.2.4 偏好C++风格的转换
进行转换时，使用static_cast、reinterpret_cast和const_cast，而不是C风格的转换。有两个例外：

转换为void以抑制关于未使用变量的警告（作为[[maybe_unused]]的替代）。在这种情况下，偏好使用C风格的转换。

在整数类型（包括非强类型枚举）之间转换时，可以使用函数风格的转换作为static_cast的替代。

3.2.5 不要使用静态构造函数
代码库中不应添加静态构造函数和析构函数（例如，其类型有构造函数或析构函数的全局变量），并应尽可能删除。

不同源文件中的全局变量按任意顺序初始化，使代码更难以推理。

静态构造函数对使用LLVM作为库的程序的启动时间有负面影响。我们非常希望将额外的LLVM目标或其他库链接到应用程序中没有任何成本，但静态构造函数破坏了这个目标。

3.2.6 类和结构体关键字的使用
在C++中，类和结构体关键字几乎可以互换使用。唯一的区别是在声明类时：类默认将所有成员设为私有，而结构体默认将所有成员设为公共。

所有给定类或结构体的声明和定义必须使用相同的关键字。例如：

C++
// 避免如果`Example`定义为结构体。
class Example;

// 可以。
struct Example;

struct Example { ... };

当所有成员都声明为公共时，应使用结构体。

C++
// 避免在此使用`struct`，应使用`class`。
struct Foo {
private:
  int Data;
public:
  Foo() : Data(0) { }
  int getData() const { return Data; }
  void setData(int D) { Data = D; }
};

// 可以使用`struct`：所有成员都为公共。
struct Bar {
  int Data;
  Bar() : Data(0) { }
};

3.2.7 不要使用大括号初始化列表调用构造函数
从C++11开始，有一种“广义初始化语法”允许使用大括号初始化列表调用构造函数。不要使用这些调用具有非平凡逻辑的构造函数，或如果您关心调用特定构造函数。这些应该像函数调用使用括号一样，而不是像聚合初始化。类似地，如果需要显式命名类型并调用其构造函数以创建临时对象，不要使用大括号初始化列表。而是，当进行聚合初始化或概念上等同的操作时，使用大括号初始化列表（不带任何临时类型）。例如：

C++
class Foo {
public:
  // 通过读取磁盘上的whizbang格式数据构建Foo...
  Foo(std::string filename);

  // 通过查找全局数据的第N个元素构建Foo...
  Foo(int N);

  // ...
};

// Foo构造函数调用读取文件，不要使用大括号调用它。
std::fill(foo.begin(), foo.end(), Foo("name"));

// 使用大括号构造pair，就像聚合一样。
bar_map.insert({my_key, my_value});

如果在初始化变量时使用大括号初始化列表，在左大括号之前使用等号：

C++
int data[] = {0, 1, 2, 3};

3.2.8 使用auto类型推导使代码更易读
有些人提倡在C++11中“几乎总是使用auto”，然而LLVM采用了更适度的立场。如果且仅当它使代码更易读或更易维护时，使用auto。不要“几乎总是”使用auto，但在诸如cast<Foo>(...)或其他类型已经从上下文中显而易见的地方使用auto。另一个auto在这些目的上效果好的时候是当类型将抽象掉时，通常在容器的typedef后面，例如std::vector<T>::iterator。

类似地，C++14添加了通用lambda表达式，其中参数类型可以是auto。在您将使用模板的地方使用这些。

3.2.9 注意使用auto时不必要的复制
auto的便利使得容易忘记其默认行为是复制。特别是在基于范围的for循环中，不小心的复制是昂贵的。

使用auto &表示值，使用auto *表示指针，除非需要复制。

C++
// 通常没有理由复制。
for (const auto &Val : Container) observe(Val);
for (auto &Val : Container) Val.change();

// 如果确实需要新副本，请删除引用。
for (auto Val : Container) { Val.change(); saveSomewhere(Val); }

// 复制指针，但要明确它们是指针。
for (const auto *Ptr : Container) observe(*Ptr);
for (auto *Ptr : Container) Ptr->change();

3.2.10 注意指针排序的不确定性
一般来说，指针之间没有相对顺序。因此，当使用指针键的无序容器（如集合和映射）时，迭代顺序是不确定的。因此，迭代此类容器可能会导致非确定性代码生成。虽然生成的代码可能正确，但不确定性会使重现错误和调试编译器变得更加困难。

如果需要有序结果，请记住在迭代之前对无序容器进行排序。或者，如果希望对指针键进行迭代，可以使用有序容器，如vector/MapVector/SetVector。

3.2.11 注意相等元素排序顺序的不确定性
std::sort使用不稳定的排序算法，不能保证保持相等元素的顺序。因此，使用std::sort对包含相等元素的容器进行排序可能会导致非确定性行为。为了揭示这种非确定性实例，LLVM引入了新的llvm::sort包装函数。对于EXPENSIVE_CHECKS构建，这将在排序前随机打乱容器。默认使用llvm::sort而不是std::sort。

## 4. 风格问题
### 4.1 高级问题
4.1.1 自包含头文件
头文件应自包含（自行编译）并以.h结尾。不应包含的非头文件应以.inc结尾，并且应尽量少用。

所有头文件都应自包含。用户和重构工具不应必须遵守特殊条件才能包含头文件。具体来说，头文件应有头文件保护并包含所有其他需要的头文件。

有时设计为包含的文件并不自包含。这些文件通常打算包含在特殊位置，例如另一个文件的中间。它们可能不会使用头文件保护，也可能不包含其前提条件。此类文件应命名为.inc扩展名。尽量少用，优先选择自包含头文件。

一般来说，头文件应由一个或多个.cpp文件实现。每个.cpp文件应首先包含定义其接口的头文件。这确保头文件的所有依赖项都已正确添加到头文件中，而不是隐式的。系统头文件应在用户头文件之后包含。

4.1.2 库分层
头文件目录（例如include/llvm/Foo）定义一个库（Foo）。一个库（包括其头文件和实现）只能使用其依赖项中列出的内容。

经典的Unix链接器（Mac和Windows链接器以及lld）可以强制执行此限制的一部分。Unix链接器按命令行上指定的从左到右顺序搜索库，从不重新访问库。这样，库之间不存在循环依赖。

这并不能完全强制所有库间依赖关系，重要的是不能强制内联函数创建的头文件循环依赖关系。回答“此分层是否正确”的一个好方法是考虑如果所有内联函数都在行外定义，Unix链接器是否会成功链接程序（以及所有有效的依赖关系顺序 - 由于链接解析是线性的，可能会有一些隐含的依赖关系：A依赖于B和C，因此有效顺序是“C B A”或“B C A”，在这两种情况下，显式依赖关系在其使用之前。但在第一种

情况下，如果B隐含依赖于C，或在第二种情况下，反之亦然，B仍然可以成功链接）。

4.1.3 #include尽可能少
#include会影响编译时间性能。除非必须，否则不要这样做，特别是在头文件中。

但等一下！有时您需要有类的定义才能使用它，或者继承它。在这些情况下，请继续#include头文件。然而，您不需要类的完整定义的情况有很多。如果您使用的是指向类的指针或引用，则不需要头文件。如果您只是从原型函数或方法返回类实例，也不需要。事实上，大多数情况下，您根本不需要类的定义。而且，不#include加快了编译速度。

然而，很容易在这个建议上过度。您必须包含所有使用的头文件 - 可以直接包含或通过另一个头文件间接包含。为了确保不会意外遗漏在模块头文件中包含头文件，请确保在实现文件中首先包含模块头文件（如上所述）。这样不会有任何隐藏的依赖项，以后发现也不会感到意外。

4.1.4 保持“内部”头文件私有
许多模块有复杂的实现，导致它们使用多个实现（.cpp）文件。通常会诱惑将内部通信接口（辅助类、额外函数等）放在公共模块头文件中。不要这样做！

如果确实需要这样做，请将私有头文件放在与源文件相同的目录中，并在本地包含它。这确保您的私有接口保持私有且不被外部干扰。

注意

可以在公共类本身中放置额外的实现方法。只需将它们设为私有（或受保护），一切都好。

4.1.5 使用命名空间限定符实现之前声明的函数
在源文件中提供函数的行外实现时，不要在源文件中打开命名空间块。相反，使用命名空间限定符以帮助确保定义匹配头文件中的声明。这样做：

C++
// Foo.h
namespace llvm {
int foo(const char *s);
}

// Foo.cpp
#include "Foo.h"
using namespace llvm;
int llvm::foo(const char *s) {
  // ...
}

这样有助于避免定义与头文件中的声明不匹配的错误。例如，以下C++代码定义了llvm::foo的新重载，而不是为头文件中声明的现有函数提供定义：

C++
// Foo.cpp
#include "Foo.h"
namespace llvm {
int foo(char *s) { // 在“const char *”和“char *”之间不匹配
}
} // namespace llvm

此错误在构建几乎完成时才会被捕获，当链接器未能找到原始函数的任何用途定义时。如果函数改为使用命名空间限定符定义，错误会在编译时立即被捕获。

类方法实现必须已经命名类，并且新重载不能行外引入，因此此建议不适用于它们。

4.1.6 使用早期退出和continue简化代码
阅读代码时，请记住读者需要记住多少状态和之前的决策才能理解代码块。尽可能减少缩进，只要不会使代码难以理解。一个很好的方法是使用早期退出和continue关键字在长循环中。考虑这段不使用早期退出的代码：

C++
Value *doSomething(Instruction *I) {
  if (!I->isTerminator() &&
      I->hasOneUse() && doOtherThing(I)) {
    ... 很长的代码 ....
  }

  return 0;
}

如果'if'的主体很大，这段代码有几个问题。当您查看函数的顶部时，不能立即看出它仅对非终结指令做有趣的事情，并且仅适用于其他谓词。其次，由于if语句使得描述这些谓词的重要性变得困难，比较难描述（在注释中）。第三，当您深入代码主体时，它又多了一层缩进。最后，当阅读函数顶部时，不清楚谓词不成立时的结果；必须阅读到函数结尾才能知道它返回null。

更偏向于将代码格式化如下：

C++
Value *doSomething(Instruction *I) {
  // 终结者不需要'某物'因为...
  if (I->isTerminator())
    return 0;

  // 我们保守地避免转换有多个用途的指令，因为山羊喜欢奶酪。
  if (!I->hasOneUse())
    return 0;

  // 这只是为了示例。
  if (!doOtherThing(I))
    return 0;

  ... 很长的代码 ....
}

这样可以解决这些问题。类似的问题经常发生在for循环中。一个愚蠢的例子是这样的：

C++
for (Instruction &I : BB) {
  if (auto *BO = dyn_cast<BinaryOperator>(&I)) {
    Value *LHS = BO->getOperand(0);
    Value *RHS = BO->getOperand(1);
    if (LHS != RHS) {
      ...
    }
  }
}

当您有非常非常小的循环时，这种结构是可以的。但如果超过10-15行，就变得难以阅读和理解。这种代码的问题是它会非常快地嵌套。意味着代码读者必须记住很多上下文来记住循环中正在发生的事情，因为他们不知道if条件是否会有else等。强烈建议将循环结构化如下：

C++
for (Instruction &I : BB) {
  auto *BO = dyn_cast<BinaryOperator>(&I);
  if (!BO) continue;

  Value *LHS = BO->getOperand(0);
  Value *RHS = BO->getOperand(1);
  if (LHS == RHS) continue;

  ...
}

这具有使用函数早期退出的所有优点：减少循环的嵌套，便于描述条件为什么成立，并且使读者清楚地看到没有即将到来的else，他们必须为之记住上下文。如果循环很大，这可以是一个很大的可理解性优势。

4.1.7 在return之后不要使用else
出于与上述类似的原因（减少缩进和更易读），请不要在中断控制流的东西之后使用'else'或'else if' — 如return、break、continue、goto等。例如：

C++
case 'J': {
  if (Signed) {
    Type = Context.getsigjmp_bufType();
    if (Type.isNull()) {
      Error = ASTContext::GE_Missing_sigjmp_buf;
      return QualType();
    } else {
      break; // 不必要。
    }
  } else {
    Type = Context.getjmp_bufType();
    if (Type.isNull()) {
      Error = ASTContext::GE_Missing_jmp_buf;
      return QualType();
    } else {
      break; // 不必要。
    }
  }
}

更好地写成这样：

```C++
case 'J':
  if (Signed) {
    Type = Context.getsigjmp_bufType();
    if (Type.isNull()) {
      Error = ASTContext::GE_Missing_sigjmp_buf;
      return QualType();
    }
  } else {
    Type = Context.getjmp_bufType();
    if (Type.isNull()) {
      Error = ASTContext::GE_Missing_jmp_buf;
      return QualType();
    }
  }
  break;
```

或者更好（在这种情况下）：

C++
case 'J':
  if (Signed)
    Type = Context.getsigjmp_bufType();
  else
    Type = Context.getjmp_bufType();

  if (Type.isNull()) {
    Error = Signed ? ASTContext::GE_Missing_sigjmp_buf :
                     ASTContext::GE_Missing_jmp_buf;
    return QualType();
  }
  break;

这个想法是减少缩进和在阅读代码时需要记住的内容。

注意：此建议不适用于constexpr if语句。else子语句可能是一个丢弃的语句，因此删除else可能会导致意外的模板实例化。因此，以下示例是正确的：

C++
template<typename T>
static constexpr bool VarTempl = true;

template<typename T>
int func() {
  if constexpr (VarTempl<T>)
    return 1;
  else
    static_assert(!VarTempl<T>);
}

4.1.8 将谓词循环转换为谓词函数
编写只计算布尔值的小循环非常常见。有许多种常见的写法，但此类事物的一个示例是：

C++
bool FoundFoo = false;
for (unsigned I = 0, E = BarList.size(); I != E; ++I)
  if (BarList[I]->isFoo()) {
    FoundFoo = true;
    break;
  }

if (FoundFoo) {
  ...
}

我们更偏好使用谓词函数（可能是静态的）并使用早期退出：

C++
/// \returns 如果指定列表有一个元素是foo，则返回true。
static bool containsFoo(const std::vector<Bar*> &List) {
  for (unsigned I = 0, E = List.size(); I != E; ++I)
    if (List[I]->isFoo())
      return true;
  return false;
}
...

if (containsFoo(BarList)) {
  ...
}

这样做有许多原因：它减少了缩进，并且将代码提取出来，可以由其他检查相同谓词的代码共享。更重要的是，它迫使您为函数选择一个名称，并强迫您为其编写注释。在这个愚蠢的示例中，这没有增加多少价值。然而，如果条件复杂，这可以使读者更容易理解查询此谓词的代码。与面对内联的如何检查BarList是否包含foo的细节相比，我们可以信任函数名并继续阅读，具有更好的局部性。

### 4.2 低级问题
4.2.1 正确命名类型、函数、变量和枚举
选择不好的名称可能会误导读者并导致错误。我们不能强调使用描述性名称的重要性。选择与底层实体的语义和角色相匹配的名称，在合理范围内。避免除非众所周知的缩写。选择好名称后，确保名称的大小写一致，因为不一致要求客户端记住API或查找以找到确切的拼写。

一般来说，名称应为驼峰式（例如，TextFileReader和isLValue()）。不同种类的声明有不同的规则：

类型名称（包括类、结构、枚举、typedef等）应为名词并以大写字母开头（例如，TextFileReader）。

变量名称应为名词（表示状态）。名称应为驼峰式，并以大写字母开头（例如，Leader或Boats）。

函数名称应为动词短语（表示动作），命令式函数应为命令式。名称应为驼峰式，并以小写字母开头（例如，openFile()或isFoo()）。

枚举声明（例如，enum Foo {...}）是类型，因此应遵循类型的命名约定。枚举的常见用途是作为联合的判别器或子类的指示符。当枚举用作类似用途时，应具有Kind后缀（例如，ValueKind）。

枚举成员（例如，enum { Foo, Bar }）和公共成员变量应以大写字母开头，就像类型一样。除非枚举成员在自己的小命名空间或类内定义，否则应有前缀与枚举声明名称相对应。例如，enum ValueKind { ... };可能包含枚举成员如VK_Argument，VK_BasicBlock等。作为方便常量的枚举成员无需前缀。例如：

C++
enum {
  MaxSize = 42,
  Density = 12
};

作为例外，模拟STL类的类可以有STL风格的小写单词下划线分隔的成员名称（例如，begin()、push_back()和empty()）。提供多个迭代器的类应在begin()和end()前加单数前缀（例如，global_begin()和use_begin()）。

以下是一些示例：

C++
class VehicleMaker {
  ...
  Factory<Tire> F;            // 避免：一个无描述的缩写。
  Factory<Tire> Factory;      // 更好：更具描述性。
  Factory<Tire> TireFactory;  // 更好：如果VehicleMaker有多种工厂类型。
};

Vehicle makeVehicle(VehicleType Type) {
  VehicleMaker M;                         // 如果范围小可能可以。
  Tire Tmp1 = M.makeTire();               // 避免：“Tmp1”没有提供信息。
  Light Headlight = M.makeLight("head");  // 好：描述性。
  ...
}

4.2.2 积极使用断言
尽量使用“assert”宏。检查所有前提条件和假设，您永远不知道何时可能会早期捕获断言的错误（不一定是您的），这会大大减少调试时间。“<cassert>”头文件可能已经包含在您使用的头文件中，因此使用它不花任何代价。

为了进一步帮助调试，请确保在断言语句中加入一些错误消息，如果断言被触发，则会打印出来。这有助于调试者理解为什么要进行断言和强制执行，并希望知道该怎么办。以下是一个完整的示例：

C++
inline Value *getOperand(unsigned I) {
  assert(I < Operands.size() && "getOperand() out of range!");
  return Operands[I];
}

以下是更多示例：

C++
assert(Ty->isPointerType() && "Can't allocate a non-pointer type!");

assert((Opcode == Shl || Opcode == Shr) && "ShiftInst Opcode invalid!");

assert(idx < getNumSuccessors() && "Successor # out of range!");

assert(V1.getType() == V2.getType() && "Constant types must be identical!");

assert(isa<PHINode>(Succ->front()) && "Only works on PHId BBs!");

您明白了。

过去，断言用于指示代码中不应到达的部分。通常形式如下：

C++
assert(0 && "Invalid radix for integer literal");

这有几个问题，主要是一些编译器可能不理解断言，或者在断言被编译出的构建中警告缺少返回。

今天，我们有更好的选择：llvm_unreachable：

C++
llvm_unreachable("Invalid radix for integer literal");

当启用断言时，如果到达这里，将打印消息并退出程序。当禁用断言（即在发布构建中）时，llvm_unreachable成为编译器的提示，跳过此分支的代码生成。如果编译器不支持此功能，它将回退到“abort”实现。

使用llvm_unreachable标记代码中不应到达的特定点。这在处理关于不可到达分支的警告时特别理想，但也可以在到达特定代码路径无条件是某种错误时使用（不源于用户输入；见下文）。使用断言应始终包括可测试的谓词（而不是assert(false)）。

如果错误条件可能由用户输入触发，则应使用LLVM程序员手册中描述的可恢复错误机制。在无法实际操作的情况下，可以使用report_fatal_error。

另一个问题是，仅供断言使用的值将在禁用断言时产生“未使用的值”警告。例如，此代码将警告：

C++
unsigned Size = V.size();
assert(Size > 42 && "Vector smaller than it should be");

bool NewToSet = Myset.insert(Value);
assert(NewToSet && "The value shouldn't be in the set yet");

这是两个有趣的不同情况。在第一种情况下，调用V.size()仅对断言有用，我们不希望在禁用断言时执行它。这样的代码应将调用移到断言本身。在第二种情况下，无论是否启用断言，调用的副作用都必须发生。在这种情况下，值应转换为void以禁用警告。具体来说，代码应首选如下：

C++
assert(V.size() > 42 && "Vector smaller than it should be");

bool NewToSet = Myset.insert(Value); (void)NewToSet;
assert(NewToSet && "The value shouldn't be in the set yet");

4.2.3 不要使用using namespace std
在LLVM中，我们更倾向于显式前缀标准命名空间的所有标识符，而不是依赖“using namespace std;”。

在头文件中，添加'using namespace XXX'指令会污染任何#include头文件的源文件的命名空间，造成维护问题。

在实现文件中（例如，.cpp文件），这条规则更像是风格规则，但仍然重要。基本上，使用显式命名空间前缀使代码更清晰，因为可以立即看出使用了什么设施以及它们来自哪里。而且更便于移植，因为命名空间冲突不会发生在LLVM代码和其他命名空间之间。便于移植规则很重要，因为不同的标准库实现会暴露不同的符号（可能是不应暴露的符号），未来的C++标准修订将向std命名空间添加更多符号。因此，我们从不在LLVM中使用'using namespace std;'

这个一般规则的例外（即，它不是std命名空间的例外）是实现文件。例如，LLVM项目中的所有代码都实现了在‘llvm’命名空间中的代码。因此，在.cpp文件顶部，在#include之后，使用'using namespace llvm;'指令是可以的，实际上更清晰。这减少了基于大括号的源代码编辑器的缩进，并保持概念上下文更清晰。这条规则的一般形式是，任何实现任何命名空间中代码的.cpp文件可以使用该命名空间（及其父级），但不应使用任何其他命名空间。

4.2.4 为头文件中的类提供虚拟方法锚
如果在头文件中定义一个类并且它有一个vtable（即，它有虚拟方法或派生自有虚拟方法的类），则该类必须始终在类中至少有一个行外虚拟方法。否则，编译器将把vtable和RTTI复制到每个#include头文件的.o文件中，导致.o文件大小膨胀并增加链接时间。

4.2.5 不要在完全覆盖的枚举switch中使用默认标签
-Wswitch警告如果没有默认标签的枚举switch没有覆盖每个枚举值。如果在完全覆盖的枚举switch中写了一个默认标签，那么当向该枚举添加新元素时-Wswitch警告将不会触发。为了帮助避免添加此类默认标签，Clang有警告-Wcovered-switch-default，它默认关闭，但在使用支持此警告的Clang版本构建LLVM时打开。

这种风格要求的一个连锁效应是，当使用GCC构建LLVM时，您可能会得到关于“控制可能到达非void函数末尾”的警告，因为GCC假定枚举表达式可能取任何可表示的值，而不仅仅是各个枚举值。要抑制此警告，请在switch之后使用llvm_unreachable。

4.2.6 尽可能使用基于范围的for循环
C++11中引入的基于范围的for循环意味着显式操作迭代器很少是必要的。我们在所有新添加的代码中尽可能使用基于范围的for循环。例如：

C++
BasicBlock *BB = ...
for (Instruction &I : *BB)
  ... 使用I ...

不鼓励使用std::for_each()/llvm::for_each()函数，除非可调用对象已经存在。

4.2.7 不要每次循环都计算end()
在无法使用基于范围的for循环的情况下，必须编写显式迭代器循环时，请注意end()是否在每次循环迭代中重新计算。一个常见错误是写一个这样的循环：

C++
BasicBlock *BB = ...
for (auto I = BB->begin(); I != BB->end(); ++I)
  ... 使用I ...

这种构造的问题在于，每次循环时都会计算“BB->end()”。我们强烈偏好在循环开始前计算一次的方法。一个方便的方法如下：

C++
BasicBlock *BB = ...
for (auto I = BB->begin(), E = BB->end(); I != E; ++I)
  ... 使用I ...

细心的人可能很快指出，这两个循环可能有不同的语义：如果容器（此例中的基本块）正在变异，那么“BB->end()”可能每次循环时都会改变其值，第二个循环可能实际上不正确。如果确实依赖于这种行为，请按第一种形式编写循环，并添加注释说明您是有意这样做的。

为什么我们偏好第二种形式（在正确的情况下）？按第一种形式编写循环有两个问题。首先，它可能比在循环开始时计算效率低。在这种情况下，成本可能很小——每次循环额外加载几次。然而，如果基本表达式更复杂，成本会迅速增加。我见过一些循环，其中end表达式实际上是这样的：“SomeMap[X]->end()”，映射查找并不便宜。通过一致地按第二种形式编写，您完全消除了这个问题，不必考虑它。

第二个（更大）的问题是，按第一种形式编写循环暗示读者正在变异容器（注释可以方便地确认这一事实！）。如果按第二种形式编写循环，立即显而易见，不必查看循环体，容器没有被修改，这使阅读代码和理解其作用更容易。

虽然第二种形式的循环有几个额外的键击，我们确实强烈偏好它。

4.2.8 #include <iostream>是禁止的
在库文件中使用#include <iostream>被禁止，因为许多常见实现会透明地将一个静态构造函数注入到每个包含它的翻译单元中。

请注意，使用其他流头文件（例如<sstream>）没有此问题——仅限于<iostream>。然而，raw_ostream提供了几乎每种用途性能更好的各种API。

注意: 新代码应始终使用raw_ostream进行写入，或使用llvm::MemoryBuffer API读取文件。

4.2.9 使用raw_ostream
LLVM包含一个轻量级、简单且高效的流实现，在llvm/Support/raw_ostream.h中提供，提供了std::ostream的所有常见功能。所有新代码应使用raw_ostream而不是ostream。

与std::ostream不同，raw_ostream不是模板，可以作为类raw_ostream进行前向声明。公共头文件通常不应包含raw_ostream头文件，而是使用前向声明和raw_ostream实例的常量引用。

4.2.10 避免使用std::endl
当与iostreams一起使用时，std::endl修改器将换行输出到指定的输出流。此外，它还会刷新输出流。换句话说，这两者是等价的：

C++
std::cout << std::endl;
std::cout << '\n' << std::flush;

大多数时候，您可能没有理由刷新输出流，因此最好使用字面'\n'。

4.2.11 在类定义中定义函数时不要使用inline
在类定义中定义的成员函数隐式为内联函数，因此不要在这种情况下使用inline关键字。

不要这样做：

C++
class Foo {
public:
  inline void bar() {
    // ...
  }
};

要这样做：

C++
class Foo {
public:
  void bar() {
    // ...
  }
};

### 4.3 微观细节
本节描述了首选的低级格式化指南以及我们偏好的原因。

4.3.1 括号前的空格
仅在控制流语句中在开括号前放一个空格，但在普通函数调用表达式和类似函数的宏中不这样做。例如：

C++
if (X) ...
for (I = 0; I != 100; ++I) ...
while (LLVMRocks) ...

somefunc(42);
assert(3 != 4 && "laws of math are failing me");

A = foo(42, 92) + bar(X);

这样做的原因并非完全随意。这种风格使控制流操作符更突出，并使表达式更流畅。

4.3.2 偏好前置增量
硬性规则：前置增量（++X）可能不会比后置增量（X++）慢，并且可能更快。尽可能使用前置增量。

后置增量的语义包括复制被增量的值，返回它，然后前置增量“工作值”。对于原始类型，这没什么大不了的。但对于迭代器，这可能是个大问题（例如，一些迭代器在其中包含堆栈和集合对象……复制迭代器可能会调用这些的复制构造函数）。总之，养成总是使用前置增量的习惯，您不会有问题。

4.3.3 命名空间缩进
一般来说，我们努力减少缩进。这是有用的，因为我们希望代码适合80列而不过度换行，但也因为它使理解代码更容易。为此并避免偶尔出现的极深嵌套，不要缩进命名空间。如果有助于可读性，随意添加注释指示关闭的命名空间。例如：

C++
namespace llvm {
namespace knowledge {

/// 此类表示Smith可以深入了解的事物，并包含与之相关的数据。
class Grokable {
...
public:
  explicit Grokable() { ... }
  virtual ~Grokable() = 0;

  ...

};

} // namespace knowledge
} // namespace llvm

如果关闭的命名空间显而易见，随时跳过关闭注释。例如，头文件中的最外层命名空间很少成为混淆的来源。但在源文件中关闭的匿名和命名空间可能会在文件中途被关闭，可能需要澄清。

4.3.4 匿名命名空间
谈论一般的命名空间之后，您可能会想知道匿名命名空间的具体情况。匿名命名空间是一个很棒的语言特性，它告诉C++编译器命名空间的内容仅在当前翻译单元内可见，允许更积极的优化并消除符号名称冲突的可能性。匿名命名空间对C++相当于对C函数和全局变量的“static”。虽然“static”在C++中可用，匿名命名空间更通用：它们可以使整个类私有化。

匿名命名空间的问题在于，它们自然希望其主体缩进，并且它们减少了引用的局部性：如果您在C++文件中看到一个随机函数定义，很容易看到它是否标记为static，但要查看它是否在匿名命名空间中，需要扫描文件的大块。

因此，我们有一个简单的指南：使匿名命名空间尽可能小，并仅用于类声明。例如：

```C++
namespace {
class StringSort {
...
public:
  StringSort(...)
  bool operator<(const char *RHS) const;
};
} // namespace

static void runHelper() {
  ...
}

bool StringSort::operator<(const char *RHS) const {
  ...
}
```

避免在匿名命名空间中放置除类以外的声明：

```C++
namespace {

// ... 许多声明 ...

void runHelper() {
  ...
}

// ... 许多声明 ...

} // namespace
```

当您在大型C++文件中查看“runHelper”时，无法立即判断此函数是否本地到文件。相比之下，当函数标记为static时，不需要交叉引用文件中的远处位置以判断函数是否本地。

在if/else/循环语句的简单单语句主体上不使用大括号
编写if、else或for/while循环语句的主体时，我们偏好省略大括号以避免不必要的行噪音。然而，在省略大括号损害可读性和

4.3.5 可维护性的情况下，应使用大括号。

当在有评论的单个语句的情况下，省略大括号会损害可读性（假设评论不能提升到if或循环语句之上，见下文）。

同样，当单语句主体复杂到难以看到包含以下语句的块从哪里开始时，应使用大括号。对于此规则，if/else链或循环视为单个语句，并递归地应用此规则。

这个列表并不详尽。例如，如果if/else链没有对其所有成员使用大括号主体，或有复杂条件、深度嵌套等，省略大括号会损害可读性。以下示例旨在提供一些指南。

如果if的主体以（直接或间接）嵌套if语句结束且没有else，则维护性会受到损害。外部if的大括号有助于避免运行到“悬挂else”情况。

C++
// 省略大括号，因为主体简单且显然与`if`关联。
if (isa<FunctionDecl>(D))
  handleFunctionDecl(D);
else if (isa<VarDecl>(D))
  handleVarDecl(D);

// 在这里记录条件本身而不是主体。
if (isa<VarDecl>(D)) {
  // 需要用这个意外的长评论解释情况，因此如果没有大括号就不清楚以下语句是否在`if`范围内。
  // 因为记录了条件，不能提升适用于主体的注释到`if`之上。
  handleOtherDecl(D);
}

// 在外部`if`上使用大括号以避免潜在的悬挂`else`情况。
if (isa<VarDecl>(D)) {
  if (shouldProcessAttr(A))
    handleAttr(A);
}

// 在外部`if`块上使用大括号以保持其与`else`块一致。
if (isa<FunctionDecl>(D)) {
  handleFunctionDecl(D);
} else {
  // 在这个`else`情况下，必须用这个意外的长评论解释情况，因此如果没有大括号就不清楚以下语句是否在`if`范围内。
  handleOtherDecl(D);
}

// 这也应该省略大括号。`for`循环只包含一个语句，所以不应有大括号。`if`也只包含一个简单语句（`for`循环），所以也应省略大括号。
if (isa<FunctionDecl>(D))
  for (auto *A : D.attrs())
    handleAttr(A);

// 在外部`if`上使用大括号，因为嵌套的`for`有大括号。
if (isa<FunctionDecl>(D)) {
  for (auto *A : D.attrs()) {
    // 在这个`for`循环主体中，必须用这个意外的长评论解释情况，迫使`for`块使用大括号。
    handleAttr(A);
  }
}

// 在外部块上使用大括号，因为有超过两层嵌套。
if (isa<FunctionDecl>(D)) {
  for (auto *A : D.attrs())
    for (ssize_t i : llvm::seq<ssize_t>(count))
      handleAttrOnDecl(D, A, i);
}

// 在外部块上使用大括号，因为有嵌套的`if`；否则编译器会警告：`add explicit braces to avoid dangling else`
if (auto *D = dyn_cast<FunctionDecl>(D)) {
  if (shouldProcess(D))
    handleVarDecl(D);
  else
    markAsIgnored(D);
}

原文链接：LLVM Coding Standards
