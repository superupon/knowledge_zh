# 如何更好的利用Vim来进行编程呢?

## 在Visual Mode 选中的区域中进行替换

`\%V` 可以做这样的事情.
For example: `:%s/\%Vs/k/g`

## Sort line 并且去除重复

```bash
:sort
:sort u
```
