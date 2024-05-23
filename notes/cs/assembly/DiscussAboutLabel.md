# 关于Label的一些讨论

## Will label name increate binary size? For assembly language ?

No, label names in assembly language do not contribute to the binary size of a program. Label names are part of the symbolic information used by an assembler to correctly create connections between different parts of the code. They serve as placeholders for actual memory addresses. 

When you write an assembly program and use an assembler to translate it to machine code, the assembler replaces these label names with actual memory addresses. The resulting machine code doesn't include the label names; it only contains the binary instructions and addresses that the processor can execute and access. 

Therefore, you can use as descriptive and as long label names as you want without worrying about increasing the binary size of your program. However, readability and manageability of the code should be taken into consideration when choosing label names.

## label name will be stored into binary, right?

Label names are typically not stored in the final binary executable, which contains only machine code (binary instructions and data for the target processor). However, label names can be included in an object file or executable as part of debugging information or symbol table if the binary is compiled with such options.

A symbol table, which can include label names and function names, is typically used for debugging purposes. This allows a debugger to correlate addresses in the executable with the corresponding labels or function names in the source code. This table is usually stripped out in the final release version of the software to reduce size and prevent easy reverse engineering. The GNU strip utility can be used to remove this information.

In summary, while label names may appear in an intermediate object file or a debugging version of the binary, they do not normally appear in the final executable binary and do not contribute to its size in a production release.

## If this label name is a global variable?

If the label name is a global variable, the situation is a bit different. The variable name itself will not be included in the binary code, but space will be allocated in the binary for the variable's data.

When the program is loaded into memory, the operating system allocates space for the global variable in the data section of the process's memory space. The actual variable name is still not stored in the binary or in memory during program execution. Like other labels, the variable name is used by the compiler or assembler to generate correct machine code, but it's not included in the binary.

However, if the binary is compiled with debugging symbols, the variable name can be included in the symbol table, allowing a debugger to map the variable name to its location in memory. Similarly, in dynamically linked libraries, global variable names may be stored in the symbol table to allow correct linking at runtime.

In summary, global variable names, like other label names, do not typically contribute to the size of the final binary (unless debugging symbols are included or for dynamic linking purposes), but space is allocated for their data.

## 符号表也会存储在最终生成的二进制文件中吗？

是的，符号表（Symbol Table）通常会被存储在生成的二进制文件中，但是这个表通常只在特定的条件下会包含在最终的二进制文件中。

调试版本: 如果程序是以调试模式编译的，那么符号表通常会包含在二进制文件中。这使得开发人员可以在调试程序时看到函数名、变量名等信息，以帮助他们理解程序的行为。

动态链接库: 如果二进制文件是一个动态链接库（如 Linux 下的 .so 文件或 Windows 下的 .dll 文件），那么它可能会包含一个符号表，以便在运行时能够找到需要的函数和变量。

但在大多数生产环境下，为了减小二进制文件的大小，提高运行效率，以及防止逆向工程等原因，符号表通常会从最终的二进制文件中移除。在 Unix-like 系统下，可以使用 strip 命令来移除这些符号信息。

总的来说，符号表是可以存储在二进制文件中的，但是是否包含在内，以及包含哪些信息，取决于编译选项和目标环境。

## 如何确定符号表在二进制文件中呢？对于Linux系统

在Linux系统中，你可以使用`nm`命令来查看一个二进制文件（如可执行文件或对象文件）的符号表。以下是一些例子：

使用`nm`命令查看符号表：

```bash
nm your_binary_file
```

这将会显示出二进制文件中的符号表，包括每个符号的地址、类型和名称。如果没有符号表，nm命令会显示"No symbols"。

如果你只是想要查看二进制文件是否包含符号表，而不需要看到具体的符号，你可以使用nm命令的-s或者--print-armap选项：

```bash
nm -s your_binary_file
```

或者：

```bash
nm --print-armap your_binary_file
```

如果二进制文件中包含符号表，这些命令会显示符号表的摘要信息。如果没有符号表，它们将不会显示任何内容。

还需要注意的是，`nm`命令只能显示未被剥离（stripped）的符号表信息。如果你的二进制文件已经被剥离了符号表，即使原先的文件在编译时包含了符号表，nm命令也无法显示出符号表。

## 我尝试对比，label name较长的binary, 和label name较短的binary, 它们的size还是相差很多，即使使用了strip命令去掉了符号表之后

ChatGPT
如果两个二进制文件的大小有显著的差异，即使在剥离了符号表之后，那么这个差异可能源自编译过程中的其他因素。标签名（即使是全局变量的标签名）在最终的二进制文件中并不包含，所以标签名的长度不应该对文件大小有任何影响。

这里有一些可能的原因导致这种差异：

优化级别：不同的编译优化级别会影响最终的二进制文件大小。例如，如果一个版本的文件是在优化级别O0（无优化）下编译的，而另一个版本的文件是在优化级别O3（最大优化）下编译的，那么即使它们的源代码完全相同，生成的二进制文件的大小也可能会有很大的差异。

静态链接和动态链接：静态链接的二进制文件会比动态链接的二进制文件大，因为静态链接的文件包含了所有需要的库函数，而动态链接的文件只包含了对库函数的引用。

Debug信息：如果你的文件是在debug模式下编译的，那么它可能会包含额外的debug信息，这些信息会增大二进制文件的大小。使用strip命令可以删除这些信息，但如果strip命令没有正确地运行，那么这些信息可能仍然存在。

如果你想了解这些大小差异的具体原因，你可以尝试使用objdump或readelf等工具分析你的二进制文件，看看这些大小差异主要是由哪些部分导致的。
