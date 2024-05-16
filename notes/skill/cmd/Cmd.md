# Linux 命令

## 1. date

### 如何按照你的需求输出日期信息

Usage: `date [option] [+format]`

* format controls output
* %% -> %
* %a -> weekday name (eg, Sun)
* %m -> month (eg, 01..12)
* %d -> day of month (eg, 01)

#### 例子 1

```bash
date "+%m%d"
0908
```

请使用 `--help` 来查看更多的信息。

## 2. diff

`diff`可以用来diff两个不同的目录

### 例子 2

```bash
diff -bur folder1/ folder2/
```

* b -> 忽略whitespace
* u -> unified context
* r -> 递归

## 3. xterm


我们可以传递一些参数给xterm, 让它可以更好的显示窗口，举个例子：

```bash
xterm -sl 20000 -fg lightgreen -bg block -cr red -fn 9x15 -maxmized
```

这对你的眼睛非常友好！😄

## 4. repeat

具体的格式如下：

```bash
repeat cnt command
```

## 5. realpath

print the full path name of a file in Linux by using the realpath command

## 6. How to append to a file

```bash
echo "data_to_append" >> file.txt
```

如果没有该文件，则会创建这个文件
