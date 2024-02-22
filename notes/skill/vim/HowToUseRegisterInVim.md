# How to use register in VIM
Registers in Vim let you run actions or commands on text stored within them. To access a register, you type "a before a command, where a is the name of a register. If you want to copy the current line into register k, you can type
```
"kyy
```
Or you can append to a register by using a capital letter
```
"Kyy
```
You can then move through the document and paste it elsewhere using
```
"kp
```
To paste from system clipboard on Linux
```
"+p
```
To paste from system clipboard on Windows (or from "mouse highlight" clipboard on Linux)
```
"*p
```
To access all currently defined registers type
```
:reg
```

# Original Link
[StackOverFlow link](https://stackoverflow.com/questions/1497958/how-do-i-use-vim-registers)
