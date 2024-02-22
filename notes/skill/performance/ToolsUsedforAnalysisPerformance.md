# Tools used for Analysis Performance
😄

## For runtime
1. **collect & analyzer** (oracle, but need -jemalloc=0)
   - It may need -Xutil=1 to disable mangle to get not mangled generated code 
2. **-xcprofile** (need `XSIM_DIAGNOSE` set)
3. **-xprofile**
   - It's a tool for analysis time consumption for the whole design in runtime.
      - You make make use of **Detailed Time Construct View** and **Time Module View** to get performance bottle neck.
      - For **Detailed Time Construct View**, it can show you what kind of construct takes most of the time and to improve its performance.
      - For **Time Module View**, it can give you basic context of the performance issue. Performance issue sometimes is complicated. It need more related data and different dimension of data to get better understanding.
      - When you find xprofile shows a lot of time consumed in kernel, you should use collect to see if there are any heavy function is runtime lib call
4. **perf**
It will be deployed on most of linux system

> [!NOTE]
> **collect** and **xprofile** can not be used at the same time. Please pay attention

## For compile time
1. **collect** (we can still use it with '-collect' in compile command line)
2. **perf** 
   1. [Perf Usage](HowToProfileProgramWithPerf.md)
   
# Backlink
[Performance Analysis Record](../../Record/PerformanceAnalysis.md)

[Performance Entry](PerformanceEntry.md)