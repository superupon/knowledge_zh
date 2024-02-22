# 简要的介绍Intel的开发者手册

这个pdf文件拥有4卷内容

* Volume 1: Basic Architecture
* Volume 2: Instruction Set Reference
* Volume 3: System Programming Guide
* Volume 4: Model-Specific Registers

## Tipss for instructions search

There is an item in Instruction description, called `CPUID Feature Flag`. It can be found with `cat /proc/cpuinfo`.

For example: 
MFENCE -- Memory Fence, this instruction should run on CPU supporting SSE2

![alt text](../../../picture/Snipaste_2024-02-02_16-50-12.png)

