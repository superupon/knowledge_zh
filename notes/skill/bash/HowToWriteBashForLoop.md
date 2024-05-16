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
