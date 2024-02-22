# 如何在Vim中使用它的寄存器

在Vim中的寄存器让你可以在它们存储的字符串之上运行命令。要访问一个寄存器，你可以输入`"a` 在一个命令之前，`a`是寄存器的名字。

如果你想复制当前行到寄存器`k`, 你可以输入：

```bash
"kyy
```

或者你也可以添加到某个寄存器上，使用大写的`K`

```bash
"Kyy
```

You can then move through the document and paste it elsewhere using

```bash
"kp
```

To paste from system clipboard on Linux

```bash
"+p
```

To paste from system clipboard on Windows (or from "mouse highlight" clipboard on Linux)

```bash
"*p
```

To access all currently defined registers type

```bash
:reg
```

## 原始链接

[StackOverFlow link](https://stackoverflow.com/questions/1497958/how-do-i-use-vim-registers)
