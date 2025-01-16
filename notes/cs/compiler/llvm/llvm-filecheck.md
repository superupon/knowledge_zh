# LLVM FileCheck
详细的描述可以从这个链接中获取。

## 1. 语法
```bash
FileCheck match-filename [--check-prefix=XXX] [-strict=whitespace]
```

## 2. 简述
FileCheck会读入两个文件（一个是标准输入，另一个是在命令行中指定的文件），并且会使用其一来验证另外一个。这个行为对于testsuite来说是特别有用的，它想要验证某个工具的输出（llc），包含预期的信息（举个例子，一个从esp或其它寄存器来的movsd是值得关注的）这和使用grep是类似, 但是对于在一个文件中以某个特定的顺序，匹配多个不同的输入进行了优化。

match-filename文件指定了一个文件，该文件包含要match的pattern. 要验证的文件会从标准输入中来，除非显示的--input-file被指定了。

退出状态
如果FileCheck认为文件匹配了预期的内容，它会以0退出，反之，则会是一个非零值。
## 3. 常用的选项
更详细的命令行参数可以通过上面的链接中获取。本文中不再赘述。

## 4. Tutorial
FileCheck通常在LLVM regression test中被使用，它会在测试的RUN行中被调用。一个简单的使用FileCheck的例子可能是这样的：

```Makefile
; RUN: llvm-as < %s | llc -march=x86-64 | FileCheck %s
```
这样的语法说了，将当前的文件pipe到llvm-as中，pipe输出到llc中，然后pipe llc的输出到FileCheck中。这意味着FileCheck将利用指定的文件名参数（即原始的.ll文件，由%s指定的）来验证它的标准输入（llc的输出）。

为了看它是如何工作的，我们看一下.ll文件的剩余的内容（在RUN行之后的）
```llvm
define void @sub1(i32* %p, i32 %v) {
entry:
; CHECK: sub1:
; CHECK: subl
    %0 = tail call i32 @llvm.atomic.load.sub.i32.p0i32(i32* %p, i32 %v)
    ret void
}

define void @inc4(i64* %p) {
entry:
; CHECK: inc4:
; CHECK: incq
    %0 = tail call i64 @llvm.atomic.load.add.i64.p0i64(i64* %p, i64 1)
    ret void
}
```
此处，你可以看到一些"CHECK:" 行，以注释的形式指定。现在你可以知道文件是如何pipe到llvm-as中，然后llc中，以及machine code输出是我们需要验证的。FileCheck检查machine code输出，来验证它和"CHECK:"行指定的是匹配的。

"CHECK:" 行的语法是非常简单的：它们是必须按序生成的字符串。FileCheck默认会忽略whitespace差异（比如中，对于它来说空格和Tab是一样的），但是，"CHECK:"行的内容是需要严格匹配的。

一个关于FileCheck比较好的地方是（相较于grep），它允许将多个test case merge到一个逻辑group中。举个例子，因为上面的测试是检查"sub1:"和"inc4" label, 它不会匹配，除非在这两个label中出现了一个"subl". 如果它出现在其它地方，那么，这种情况是不算的。而grep subl会进行匹配，如果"subl"在文件中的任意一处被匹配到。

### 3.1 FileCheck -check-prefix选项
FileCheck的-check-prefix选项允许多个测试配置由一个.ll文件生成。这在很多场景下非常有用，举个例子，利用llc测试不同架构变体, 这是简单的一个例子：
```llvm
; RUN: llvm-as < %s | llc -mtriple=i686-apple-darwin9 -mattr=sse41 \
; RUN:              | FileCheck %s -check-prefix=X32
; RUN: llvm-as < %s | llc -mtriple=x86_64-apple-darwin9 -mattr=sse41 \
; RUN:              | FileCheck %s -check-prefix=X64

define <4 x i32> @pinsrd_1(i32 %s, <4 x i32> %tmp) nounwind {        
    %tmp1 = insertelement <4 x i32>; %tmp, i32 %s, i32 1        
    ret <4 x i32> %tmp1
; X32: pinsrd_1:
; X32:    pinsrd $1, 4(%esp), %xmm0

; X64: pinsrd_1:
; X64:    pinsrd $1, %edi, %xmm0
}
```
在这种场景下，我们可以同时测试32bit和64bit的code generation是否符合预期。

### 3.2 "COM:" directive
有时候你想关闭一个FileCheck directive, 但又不想完全移除掉它，或者你想要写一些注释，但它通过名字提到了某个directive。 "COM:" directive很容易能做到这些事。举个例子， 你可能有：

```llvm
; X32: pinsrd_1:
; X32:    pinsrd $1, 4(%esp), %xmm0

; COM: FIXME: X64 isn't working correctly yet for this part of codegen, but
; COM: X64 will have something similar to X32:
; COM:
; COM:   X64: pinsrd_1:
; COM:   X64:    pinsrd $1, %edi, %xmm0
```

如果没有使用COM:，就需要通过某种重新措辞和指令语法变形的组合来防止 FileCheck 将上面注释中的X32:和X64:识别为指令。此外，已经Proposal的 FileCheck 诊断可能会对没有尾随:的X64发出警告，因为它们看起来像是指令拼写错误。避开这些问题对测试作者来说可能很麻烦，而指令语法变形可能会使测试代码的意图不清楚。COM:可以避免所有这些问题。

一些重要的使用注意事项：

*	“COM:”在另一个指令的模式中时，并不会注释掉模式的剩余部分。例如：
```llvm
; X32: pinsrd $1, 4(%esp), %xmm0 COM: 这是 X32 模式的一部分！
```
*	如果你需要临时注释掉指令模式的一部分，将其移到另一行中。原因是 FileCheck 解析“COM:”的方式与任何其他指令相同：一行中只有第一个指令会被识别为指令。
*	为了兼容 LIT，FileCheck 将RUN:视为与COM:相同的注释指令。如果这不适合你的测试环境，请参阅 --comment-prefixes 选项。
*	如果COM、RUN或任何用户定义的注释前缀与通常的检查指令后缀（如-NEXT:或-NOT:）结合在一起时，FileCheck 不会将其识别为注释指令，而是将其视为普通文本。如果在你的测试环境中需要将其作为注释指令来使用，请使用 --comment-prefixes 选项将其定义为注释指令。

### 3.3 "CHECK-NEXT:" directive
有时候，你想匹配一些行，并希望确认这些匹配发生在完全连续的行上，中间没有其他行。在这种情况下，你可以使用“CHECK:”和“CHECK-NEXT:”指令来指定。如果你指定了自定义的检查前缀，只需使用“<PREFIX>-NEXT:”。例如，下面的代码会按预期工作：

```llvm
define void @t2(<2 x double>* %r, <2 x double>* %A, double %B) {
     %tmp3 = load <2 x double>* %A, align 16
     %tmp7 = insertelement <2 x double> undef, double %B, i32 0
     %tmp9 = shufflevector <2 x double> %tmp3,
                            <2 x double> %tmp7,
                            <2 x i32> < i32 0, i32 2 >
     store <2 x double> %tmp9, <2 x double>* %r, align 16
     ret void

; CHECK:          t2:
; CHECK:             movl    8(%esp), %eax
; CHECK-NEXT:        movapd  (%eax), %xmm0
; CHECK-NEXT:        movhpd  12(%esp), %xmm0
; CHECK-NEXT:        movl    4(%esp), %eax
; CHECK-NEXT:        movapd  %xmm0, (%eax)
; CHECK-NEXT:        ret
}
```

“CHECK-NEXT:”指令会拒绝输入，除非它和前一个指令之间正好只有一个换行符。“CHECK-NEXT:”不能是文件中的第一个指令。

### 3.4 "CHECK-SAME" directive
有时候，你希望匹配一些行，并希望确认这些匹配与前一个匹配发生在同一行上。在这种情况下，你可以使用“CHECK:”和“CHECK-SAME:”指令来指定。如果你指定了自定义的检查前缀，只需使用“<PREFIX>-SAME:”。

“CHECK-SAME:”在与“CHECK-NOT:”（将在下文描述）结合使用时特别强大。
例如，以下代码会按预期工作：

Plain Text
!0 = !DILocation(line: 5, scope: !1, inlinedAt: !2)

; CHECK:       !DILocation(line: 5,
; CHECK-NOT:               column:
; CHECK-SAME:              scope: ![[SCOPE:[0-9]+]]

“CHECK-SAME:”指令会拒绝输入，如果它和前一个指令之间有任何换行符。

“CHECK-SAME:”还非常适用于避免为不相关的字段编写匹配规则。例如，假设你在编写一个测试，解析一个生成如下输出的工具：

Plain Text
Name: foo
Field1: ...
Field2: ...
Field3: ...
Value: 1

Name: bar
Field1: ...
Field2: ...
Field3: ...
Value: 2

Name: baz
Field1: ...
Field2: ...
Field3: ...
Value: 1

为了编写一个验证 foo 的值为 1 的测试，你可能首先会这样写：

Plain Text
CHECK: Name: foo
CHECK: Value: 1{{$}}

然而，这将是一个不好的测试：如果 foo 的值发生变化，测试仍然会通过，因为“CHECK: Value: 1”这行会匹配到 baz 的值。为了解决这个问题，你可以为每个 FieldN: 行添加 CHECK-NEXT 匹配规则，但这会很冗长，而且在添加 Field4 时需要更新。一种更简洁的编写测试的方法是使用“CHECK-SAME:”匹配器，如下所示：

Plain Text
CHECK:      Name: foo
CHECK:      Value:
CHECK-SAME:        {{ 1$}}

这验证了下一次 Value: 出现在输出中时，其值为 1。

注意：“CHECK-SAME:”不能是文件中的第一个指令。

### 3.5 "CHECK-EMPTY" directive
如果你想检查下一行什么都没有，甚至连whitespace都没有，你可以使用"CHECK-EMPTY:" directive.
```llvm
declare void @foo()

declare void @bar()
; CHECK: foo
; CHECK-EMPTY:
; CHECK-NEXT: bar
```

### 3.6 "CHECK-NOT" directive
“CHECK-NOT:” 指令用于验证某个字符串在两个匹配之间（或在第一个匹配之前，或在最后一个匹配之后）不会出现。例如，要验证一个加载操作是否被某个转换移除，可以使用如下测试：

Plain Text
define i8 @coerce_offset0(i32 %V, i32* %P) {
  store i32 %V, i32* %P

  %P2 = bitcast i32* %P to i8*
  %P3 = getelementptr i8* %P2, i32 2

  %A = load i8* %P3
  ret i8 %A
; CHECK: @coerce_offset0
; CHECK-NOT: load
; CHECK: ret i8
}

在这个例子中，CHECK-NOT: load 验证了在匹配到 @coerce_offset0 之后、匹配到 ret i8 之前，没有 load 操作出现。

### 3.7 "CHECK-COUNT:" directive
如果你需要多次匹配同一个模式，你可以根据需要重复使用普通的 CHECK:。如果这样做显得过于单调，你可以使用带计数的检查指令 CHECK-COUNT-<num>:，其中 <num> 是一个正整数。它将精确匹配该模式 <num> 次，不多也不少。如果你使用了自定义的检查前缀，只需使用 <PREFIX>-COUNT-<num>: 就可以达到相同的效果。以下是一个简单的例子：

Plain Text
Loop at depth 1
Loop at depth 1
Loop at depth 1
Loop at depth 1
  Loop at depth 2
    Loop at depth 3

Plain Text
; CHECK-COUNT-6: Loop at depth {{[0-9]+}}
; CHECK-NOT:     Loop at depth {{[0-9]+}}

在这个例子中：

•	CHECK-COUNT-6: Loop at depth {{[0-9]+}} 指令将匹配 Loop at depth 的模式，正好 6 次，匹配的数字可以是任何一位或多位数字。
•	CHECK-NOT: Loop at depth {{[0-9]+}} 指令确保在匹配到6次之后，不再有 Loop at depth 的出现。

### 3.8 "CHECK-DAG:" directive
如果需要匹配并非严格按顺序出现的字符串，可以使用“CHECK-DAG:”来验证它们位于两个匹配项之间（或者在第一个匹配项之前，或者在最后一个匹配项之后）。例如，clang 会以相反的顺序生成虚表（vtable）的全局变量。使用 CHECK-DAG:，我们可以按自然顺序编写检查语句：

Plain Text
// RUN: %clang_cc1 %s -emit-llvm -o - | FileCheck %s

struct Foo { virtual void method(); };
Foo f;  // 生成虚表
// CHECK-DAG: @_ZTV3Foo =

struct Bar { virtual void method(); };
Bar b;
// CHECK-DAG: @_ZTV3Bar =

与CHECK-NOT的联用
CHECK-NOT: 指令可以与 CHECK-DAG: 指令混合使用，以排除在 CHECK-DAG: 指令之间的字符串。因此，围绕 CHECK-DAG: 指令的顺序不能改变，也就是说，CHECK-NOT: 之前的 CHECK-DAG: 匹配项不能出现在 CHECK-NOT: 之后的 CHECK-DAG: 匹配项之后。例如：

Plain Text
; CHECK-DAG: BEFORE
; CHECK-NOT: NOT
; CHECK-DAG: AFTER

在这种情况下，如果 BEFORE 出现在 AFTER 之后，将会导致输入字符串被拒绝。

匹配DAG的拓扑排序
对于捕获的变量，CHECK-DAG: 可以匹配有效的有向无环图（DAG）的拓扑顺序，即从变量定义到其使用之间的边。这在测试用例需要匹配指令调度器输出的不同顺序时非常有用。例如：

Plain Text
; CHECK-DAG: add [[REG1:r[0-9]+]], r1, r2
; CHECK-DAG: add [[REG2:r[0-9]+]], r3, r4
; CHECK:     mul r5, [[REG1]], [[REG2]]

在这种情况下，两个 add 指令的顺序可以是任意的。

如果你在同一个 CHECK-DAG: 块中定义并使用变量，定义规则可能会在其使用之后匹配。

例如，下面的代码将通过检查：

Plain Text
; CHECK-DAG: vmov.32 [[REG2:d[0-9]+]][0]
; CHECK-DAG: vmov.32 [[REG2]][1]
vmov.32 d0[1]
vmov.32 d0[0]

而下面的代码则不会通过：

Plain Text
; CHECK-DAG: vmov.32 [[REG2:d[0-9]+]][0]
; CHECK-DAG: vmov.32 [[REG2]][1]
vmov.32 d1[1]
vmov.32 d0[0]

虽然这种方式非常有用，但也很危险，因为在寄存器序列的情况下，你必须有一个强制顺序（如读取在写入之前，复制在使用之前等）。如果测试中查找的定义未能匹配（因为编译器中的错误），可能会匹配到更远的地方，从而掩盖真正的错误。

在这种情况下，为了强制顺序，可以在 DAG 块之间使用非 DAG 指令。

CHECK-DAG: 指令会跳过与同一 CHECK-DAG: 块中任何之前的 CHECK-DAG: 指令匹配的重叠匹配项。这种非重叠行为不仅与其他指令一致，而且在处理非唯一字符串或模式集时也是必要的。例如，以下指令会查找并行程序（如 OpenMP 运行时）中两个任务的无序日志条目：

Plain Text
// CHECK-DAG: [[THREAD_ID:[0-9]+]]: task_begin
// CHECK-DAG: [[THREAD_ID]]: task_end
//
// CHECK-DAG: [[THREAD_ID:[0-9]+]]: task_begin
// CHECK-DAG: [[THREAD_ID]]: task_end

即使模式是相同的，甚至日志条目的文本也是相同的，由于线程 ID 会被重用，第二对指令也不会匹配与第一对指令相同的日志条目。

### 3.9 "CHECK-LABEL" directive
有时候，在包含多个测试的文件中，这些测试被划分成了不同的逻辑块。但是，一个或多个 CHECK: 指令可能会无意中匹配到后面块中的某一行。虽然通常最终会生成一个错误，但被标记为引发错误的检查项可能与实际问题的源头并无直接关系。

为了在这些情况下生成更好的错误信息，可以使用 CHECK-LABEL: 指令。CHECK-LABEL: 指令与普通的 CHECK: 指令的处理方式相同，但 FileCheck 会做一个额外的假设，即由该指令匹配的行不会被文件中的其他检查指令匹配到。这一指令通常用于包含标签或其他唯一标识符的行。概念上来说，CHECK-LABEL: 的存在将输入流划分为独立的块，每个块独立处理，从而防止一个块中的 CHECK: 指令匹配到另一个块中的行。如果启用了 --enable-var-scope 选项，则在每个块开始时，所有局部变量都会被清除。

例如：
Plain Text
define %struct.C* @C_ctor_base(%struct.C* %this, i32 %x) {
entry:
; CHECK-LABEL: C_ctor_base:
; CHECK: mov [[SAVETHIS:r[0-9]+]], r0
; CHECK: bl A_ctor_base
; CHECK: mov r0, [[SAVETHIS]]
  %0 = bitcast %struct.C* %this to %struct.A*
  %call = tail call %struct.A* @A_ctor_base(%struct.A* %0)
  %1 = bitcast %struct.C* %this to %struct.B*
  %call2 = tail call %struct.B* @B_ctor_base(%struct.B* %1, i32 %x)
  ret %struct.C* %this
}

define %struct.D* @D_ctor_base(%struct.D* %this, i32 %x) {
entry:
; CHECK-LABEL: D_ctor_base:

在这个例子中，使用 CHECK-LABEL: 指令确保了这三个 CHECK: 指令只能匹配与 @C_ctor_base 函数体相对应的行，即使这些模式匹配到文件后面块中的行也不行。此外，如果这三个 CHECK: 指令中的某一个失败，FileCheck 会继续检查下一个块，从而在一次运行中检测出多个测试失败。

CHECK-LABEL: 指令中的字符串不需要与源代码或输出语言中的实际语法标签相对应；它们只需要唯一地匹配文件中的某一行即可。

CHECK-LABEL: 指令不能包含变量定义或使用。

### 3.10 Directive modifiers
可以通过在指令后面加上 {<modifier>} 的形式将指令修饰符附加到指令上，其中 <modifier> 的唯一支持值是 LITERAL。

LITERAL 指令修饰符可以用于执行字面匹配。使用此修饰符后，指令将不会识别任何用于执行正则表达式匹配、变量捕获或替换的语法。这在需要大量转义字符的情况下非常有用。例如，以下示例将执行字面匹配，而不会将这些内容视为正则表达式：

Input [[[10, 20]], [[30, 40]]]
Output %r10：[[10, 20]]
Output %r10：[[30, 40]]

Plain Text
; CHECK{LITERAL}: [[[10, 20]], [[30, 40]]]
; CHECK-DAG{LITERAL}: [[30, 40]]
; CHECK-DAG{LITERAL}: [[10, 20]]

### 3.11 FileCheck正则匹配语法
所有 FileCheck 指令都需要一个匹配的模式。对于大多数 FileCheck 的使用场景，固定字符串匹配就足够了。但在某些情况下，需要更灵活的匹配形式。为了支持这种需求，FileCheck 允许在匹配字符串中指定正则表达式，这些正则表达式用双括号 {{yourregex}} 包围。FileCheck 实现了一个 POSIX 正则表达式匹配器，它支持扩展的 POSIX 正则表达式 (ERE)。由于我们大多数情况下都希望使用固定字符串匹配，因此 FileCheck 被设计为支持固定字符串匹配与正则表达式混合使用。这允许你编写如下内容：

Plain Text
; CHECK: movhpd      {{[0-9]+}}(%esp), {{%xmm[0-7]}}

在这个例子中，ESP 寄存器的任何偏移量都是允许的，任何 xmm 寄存器也是允许的。

因为正则表达式是用双括号包围的，所以它们在视觉上是区分开的，并且你不需要像在 C 语言中那样在双括号内使用转义字符。在少数情况下，如果你想从输入中显式匹配双括号，你可以使用类似 {{[}][}]}} 这样丑陋的模式。或者，如果你使用重复计数语法，例如 [[:xdigit:]]{8} 来精确匹配 8 个十六进制数字，你需要添加括号像这样 {{([[:xdigit:]]{8})}}，以避免与 FileCheck 的闭合双括号混淆。

### 3.12 FileCheck字符替换块

通常情况下，匹配一个模式并验证它稍后在文件中再次出现是很有用的。对于代码生成测试，这可以用来允许任意寄存器，但要验证该寄存器在后续的使用中是保持一致的。为此，FileCheck 支持字符串替换块，允许定义字符串变量并将其替换到模式中。以下是一个简单的例子：
Plain Text
; CHECK: test5:
; CHECK:    notw     [[REGISTER:%[a-z]+]]
; CHECK:    andw     {{.*}}[[REGISTER]]

第一行检查匹配了一个正则表达式 %[a-z]+ 并将其捕获到字符串变量 REGISTER 中。第二行验证了在 andw 之后，REGISTER 中的内容在文件中稍后再次出现。FileCheck 的字符串替换块总是包含在 [[ ]] 对中，字符串变量名可以通过正则表达式 \$[a-zA-Z_][a-zA-Z0-9_]* 进行定义。如果变量名后跟一个冒号，则表示这是一个变量的定义；否则，它是一个替换。

FileCheck 变量可以多次定义，并且替换总是使用最新的值。变量还可以在定义的同一行中稍后被替换。例如：
Plain Text
; CHECK: op [[REG:r[0-9]+]], [[REG]]
这在你希望 op 的操作数是相同的寄存器，但不关心具体是哪一个寄存器时是很有用的。

如果启用了 --enable-var-scope，以 $ 开头的变量名将被视为全局变量。所有其他变量是局部变量。所有局部变量在每个 CHECK-LABEL 块的开始时都会被取消定义。全局变量不受 CHECK-LABEL 影响。这使得确保单个测试不受前面测试中设置的变量影响变得更加容易。

### 3.13 FileCheck数字替换块
FileCheck 还支持数字替换块，它允许定义数字变量，并通过数字替换检查满足基于这些变量的数字表达式约束的数字值。这使得 CHECK: 指令可以验证两个数字之间的关系，例如需要连续使用寄存器。

捕获数字值的语法为 [[#%<fmtspec>,<NUMVAR>:]]，其中：

•	%<fmtspec>, 是一个可选的格式说明符，用于指示要匹配的数字格式以及期望的最少位数。
•	<NUMVAR>: 是一个可选的变量 <NUMVAR> 定义，从捕获的值中获取。

<fmtspec> 的语法为：#.<precision><conversion specifier>，其中：

•	# 是一个用于十六进制值的可选标志（见下文的 <conversion specifier>），它要求匹配的值以 0x 为前缀。
•	.<precision> 是一个可选的 printf 风格的精度说明符，<precision> 表示匹配的值必须具有的最少位数，如有必要，使用前导零。
•	<conversion specifier> 是一个可选的 scanf 风格的转换说明符，用于指示要匹配的数字格式（例如十六进制数字）。当前接受的格式说明符有 %u, %d, %x 和 %X。如果省略，格式说明符默认为 %u。

例如：

Plain Text
; CHECK: mov r[[#REG:]], 0x[[#%.8X,ADDR:]]

将匹配 mov r5, 0x0000FEFE，并将 REG 设为值 5，ADDR 设为值 0xFEFE。注意，由于精度要求，它将无法匹配 mov r5, 0xFEFE。

由于数字变量的定义是可选的，因此可以只检查给定格式下的数字值是否存在。当该值本身没有用处时，这非常有用，例如：

Plain Text
; CHECK-NOT: mov r0, r[[#]]
用于检查一个值是被合成的，而不是被移动的。

数字替换的语法为 [[#%<fmtspec>, <constraint> <expr>]]，其中：

•	<fmtspec> 是与定义变量时相同的格式说明符，但在此上下文中，它表示应如何匹配数字表达式值。如果省略，则根据表达式约束中使用的数字变量的匹配格式推断格式说明符的两个部分，如果不使用任何数字变量，则默认为 %u，表示该值应为无符号数且没有前导零。如果多个数字变量的格式说明符存在冲突，则转换说明符变为强制性的，但精度说明符仍然是可选的。
•	<constraint> 是描述要匹配的值与数字表达式的值之间的关系的约束。目前唯一接受的约束是 ==，用于精确匹配，如果未提供 <constraint>，则默认为此约束。当 <expr> 为空时，不得指定匹配约束。
•	<expr> 是一个表达式。表达式递归地定义为：
￮	一个数字操作数，或
￮	一个表达式后跟运算符和一个数字操作数。

数字操作数可以是先前定义的数字变量、整数字面值或函数。在这些元素之前、之后或之间接受空格。数字操作数具有 64 位精度。溢出和下溢将被拒绝。不支持运算符优先级，但可以使用括号来改变评估顺序。

支持的运算符包括：
•	+ - 返回两个操作数的和。
•	- - 返回两个操作数的差。

函数调用的语法为 <name>(<arguments>)，其中：
•	name 是预定义的字符串字面值。接受的值包括：
￮	add - 返回两个操作数的和。
￮	div - 返回两个操作数的商。
￮	max - 返回两个操作数中的较大者。
￮	min - 返回两个操作数中的较小者。
￮	mul - 返回两个操作数的积。
￮	sub - 返回两个操作数的差。
•	<arguments> 是用逗号分隔的表达式列表。

例如：
Plain Text
; CHECK: load r[[#REG:]], [r0]
; CHECK: load r[[#REG+1]], [r1]
; CHECK: Loading from 0x[[#%x,ADDR:]]
; CHECK-SAME: to 0x[[#ADDR + 7]]
上述示例将匹配以下文本：
Plain Text
load r5, [r0]
load r6, [r1]
Loading from 0xa0463440 to 0xa0463447
但不会匹配以下文本：
Plain Text
load r5, [r0]
load r7, [r1]
Loading from 0xa0463440 to 0xa0463443
因为 7 不等于 5 + 1，且 a0463443 不等于 a0463440 + 7。

数字变量也可以被定义为数字表达式的结果，在这种情况下，检查数字表达式约束是否满足，如果满足，则将变量赋值为结果值。因此，用于同时检查数字表达式并将其值捕获到数字变量中的统一语法为 [[#%<fmtspec>,<NUMVAR>: <constraint> <expr>]]，其中每个元素的描述如前所述。可以使用此语法使测试用例更具自描述性，使用变量代替具体值：
Plain Text
; CHECK: mov r[[#REG_OFFSET:]], 0x[[#%X,FIELD_OFFSET:12]]
; CHECK-NEXT: load r[[#]], [r[[#REG_BASE:]], r[[#REG_OFFSET]]]
这将匹配：
Plain Text
mov r4, 0xC
load r6, [r5, r4]
--enable-var-scope 选项对数字变量的作用与对字符串变量相同。

重要提示：在当前实现中，表达式不能使用同一 CHECK 指令中先前定义的数字变量。

### 3.14 FileCheck伪数值变量
有时需要验证输出中包含匹配文件行号的内容，例如在测试编译器诊断时。这会引入匹配文件结构的某种脆弱性，因为 CHECK: 行中包含相同文件的绝对行号，每当由于文本的添加或删除导致行号发生变化时，这些行号必须更新。

为支持这种情况，FileCheck 表达式理解 @LINE 伪数字变量，它会评估为找到它的 CHECK 模式所在行的行号。

通过这种方式，匹配模式可以放置在相关测试行附近，并包括相对行号引用，例如：

C++
// CHECK: test.cpp:[[# @LINE + 4]]:6: error: expected ';' after top level declarator
// CHECK-NEXT: {{^int a}}
// CHECK-NEXT: {{^     \^}}
// CHECK-NEXT: {{^     ;}}
int a

为了支持 @LINE 作为特殊字符串变量的传统用法，FileCheck 还接受以下使用 @LINE 的字符串替换块语法：[[@LINE]]，[[@LINE+<offset>]] 和 [[@LINE-<offset>]]，其中括号内没有任何空格且 offset 是一个整数。

### 3.15 匹配换行符
匹配换行符可以使用[[:space:]], 举个例子，以下的pattern
```bash
// CHECK: DW_AT_location [DW_FORM_sec_offset] ([[DLOC:0x[0-9a-f]+]]){{[[:space:]].*}}"intd"
```
会匹配如下的格式：
```bash
DW_AT_location [DW_FORM_sec_offset]   (0x00000233)
DW_AT_name [DW_FORM_strp]  ( .debug_str[0x000000c9] = "intd")
```

