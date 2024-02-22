# 如何在Vim中使用它的寄存器

Registers in Vim let you run actions or commands on text stored within them. To access a register, you type "a before a command, where a is the name of a register. If you want to copy the current line into register k, you can type

```bash
"kyy
```

Or you can append to a register by using a capital letter

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
