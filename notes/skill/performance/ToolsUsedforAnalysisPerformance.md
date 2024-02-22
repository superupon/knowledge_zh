# 用于性能分析的工具

> [!NOTE]
> 这篇文章是针对我们正在研发的工具，所提供的分析方式，其中的部分工具并不具备普遍性。

## 对于runtime

1. **collect & analyzer** (oracle的工具，但是需要-jemalloc=0)
   - 可能需要`-Xutil=1` 来把命名混淆关闭
2. **-xcprofile** (需要设置`XSIM_DIAGNOSE`)
3. **-xprofile**
   - It's a tool for analysis time consumption for the whole design in runtime.
      - You make make use of **Detailed Time Construct View** and **Time Module View** to get performance bottle neck.
      - For **Detailed Time Construct View**, it can show you what kind of construct takes most of the time and to improve its performance.
      - For **Time Module View**, it can give you basic context of the performance issue. Performance issue sometimes is complicated. It need more related data and different dimension of data to get better understanding.
      - When you find xprofile shows a lot of time consumed in kernel, you should use collect to see if there are any heavy function is runtime lib call
4. **perf**
   - 这个工具在大多数的Linux系统中都可以获得

> [!NOTE]
> **collect** and **xprofile** 不可以同时起作用

## 对于编译时分析

1. **collect** (我们仍然可以在命令行中加上`-collect` 来使用它)
2. **perf**
   1. [Perf 使用](HowToProfileProgramWithPerf.md)
  
## Backlink

- [Performance Analysis Record](../../Record/PerformanceAnalysis.md)
- [Performance Entry](PerformanceEntry.md)