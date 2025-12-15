# Reaching-Definition Analysis

## 什么是Reaching-Definition Analysis?

Reaching-definition分析是在编译器设计中的一个概念，它通常被用于优化和分析阶段。它是一种数据流分析，它确定了变量的定义可能在代码中抵达特定的程序点。

1. Definition of a Variable: In the context of reaching-definitions, a "definition" **refers to an assignment or any operation that changes the value of a variable**. For example, in the line `x = 5`, the variable `x` is being defined.

2. Reaching: A definition is said to "reach" a point in the program if there's a possibility that the path of execution can go from the definition to that point without any intervening redefinitions of the variable.

3. Why It's Important: This analysis helps in understanding the flow of data through variables across different parts of the program. It's crucial for further optimizations, like dead code elimination, constant propagation, and more. For instance, if a definition does not reach a particular point in the code, then any use of the variable at that point cannot be affected by that definition.

4. How It Works: The analysis typically involves creating data-flow equations that capture the 'gen' (generate) and 'kill' (override) effects of definitions on program paths. It usually works in a forward manner, starting at the beginning of a program/function and moving towards the end, accumulating sets of definitions that could reach each point in the program.

Application: Reaching-definition analysis is often represented using graphs or matrices and is a fundamental part of various compiler optimizations and code analysis tools.

Please refer to this doc for more details.

[Reaching Definition - Wiki](../../../webdoc/Reaching_definition-Wikipedia.pdf)

### 补充：Wiki 摘要（核心语义）

- 判定：给定一条指令，其“reaching definition”是所有可能无重定义阻断地到达此指令的赋值。例如 `y := 3` 可 reach `x := y`，但若中间有 `y := 4`，前者就被 kill。
- 数据流框架：前向、并集为汇合运算。对基本块 `B`：
  - `IN[B] = ⋃ OUT[p]`，`p` 为 `B` 的所有前驱。
  - `OUT[B] = GEN[B] ∪ (IN[B] - KILL[B])`，`GEN` 为本块产生的新定义集合，`KILL` 为本块覆盖掉的其他定义集合（按变量名匹配）。
  - 定义的域是“指令标签”，同一变量的旧标签被 kill。
- 迭代求解：经典 worklist 算法，若某块的 `OUT` 更新，则把其后继重新入队，直到全图收敛。
- 结果用途：计算 use-def 链，支撑死代码消除、循环不变代码外提等。

## Why we still need it, if we are SSA format?
