# Reaching-Definition Analysis

## What is Reaching-Definition Analysis?
Reaching-definition analysis is a concept in compiler design, used in the optimization and analysis phase. It's a type of data-flow analysis that determines which definitions of variables might reach a particular point in the code. Let me explain it in more detail:

1. Definition of a Variable: In the context of reaching-definitions, a "definition" **refers to an assignment or any operation that changes the value of a variable**. For example, in the line x = 5, the variable x is being defined.

2. Reaching: A definition is said to "reach" a point in the program if there's a possibility that the path of execution can go from the definition to that point without any intervening redefinitions of the variable.

3. Why It's Important: This analysis helps in understanding the flow of data through variables across different parts of the program. It's crucial for further optimizations, like dead code elimination, constant propagation, and more. For instance, if a definition does not reach a particular point in the code, then any use of the variable at that point cannot be affected by that definition.

4. How It Works: The analysis typically involves creating data-flow equations that capture the 'gen' (generate) and 'kill' (override) effects of definitions on program paths. It usually works in a forward manner, starting at the beginning of a program/function and moving towards the end, accumulating sets of definitions that could reach each point in the program.

Application: Reaching-definition analysis is often represented using graphs or matrices and is a fundamental part of various compiler optimizations and code analysis tools.

Please refer to this doc for more details.

[Reaching Definition - Wiki](../../../webdoc/Reaching_definition-Wikipedia.pdf)

## Why we still need it, if we are SSA format?
accu 
