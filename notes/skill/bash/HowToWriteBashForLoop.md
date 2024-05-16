# 如何编写bash循环

以下是一个小例子：

```bash
#!/bin/bash

# Simple for loop example

# Iterate over a range of numbers
for ((i = 1; i <= 5; i++))
do
  echo "Number: $i"
done

# Iterate over elements in an array
fruits=("Apple" "Banana" "Orange" "Mango")
for fruit in "${fruits[@]}"
do
  echo "Fruit: $fruit"
done

# Iterate over files in a directory
for file in /path/to/directory/*
do
  echo "File: $file"
done
```

这个例子中，提供了三种不同形式的迭代：

* 在一个数字范围内进行迭代。
* 在数组元素中进行迭代
* 在一个目录的文件中进行迭代

## 对于for loop不同形式的写法

其中对于第一种形式，有数种不同的写法：

Example 1: 使用C-style `for` loop语法:

```shell
#!/bin/bash

# Equivalent example using C-style for loop

# Declare and initialize counter variable
counter=1

# Loop condition
for ((; counter <= 5; counter++))
do
  echo "Loop iteration: $counter"
done
```

Example 2: Using `seq` command to generate a sequence of numbers:

```shell
#!/bin/bash

# Equivalent example using seq command

# Loop over a sequence of numbers
for counter in $(seq 1 5)
do
  echo "Loop iteration: $counter"
done
```

Example 3: Using `while` loop with a conditional check:

```shell
#!/bin/bash

# Equivalent example using while loop

# Declare and initialize counter variable
counter=1

# Loop condition
while [[ $counter -le 5 ]]
do
  echo "Loop iteration: $counter"
  ((counter++))
done
```

All three examples achieve the same result of iterating from 1 to 5 using a counter variable. Choose the syntax that you find most comfortable and suitable for your script.

## 如何在一行内写一个循环

```bash
for ((i=1; i<=5; i++)); do echo "Line $i"; done > output.txt
```
