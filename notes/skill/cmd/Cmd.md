# Linux 命令

## date

### 如何按照你的需求输出日期信息

Usage: date [option] [+format]
format controls output
%% -> %
%a -> weekday name (eg, Sun)
%m -> month (eg, 01..12)
%d -> day of month (eg, 01)

#### 例子 1

```bash
date "+%m%d"
0908
```

请使用 --help 来查看更多的信息。

## diff

diff command can diff two different directories.

### 例子 2

```bash
diff -bur folder1/ folder2/
```

* b -> 忽略whitespace
* u -> unified context
* r -> 递归

## xterm

We can pass in a lot of parameters to it to get better default window.
For instance,

```bash
xterm -sl 20000 -fg lightgreen -bg block -cr red -fn 9x15 -maxmized
```

这对你的眼睛非常友好！😄

## repeat

具体的格式如下：

```bash
repeat cnt command
```
