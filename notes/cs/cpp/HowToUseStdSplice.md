# std::splice使用

C++中的`splice`函数是一个成员函数，通常用于处理`std::list`或`std::forward_list`这样的双向链表或单向链表。`splice`函数可以将链表的元素移动到另一个链表中，而不需要复制或重新分配内存。这使得`splice`操作非常高效。

`std::list`中的`splice`有三个重载版本：

1. `void splice (const_iterator position, list& x);`
   这个版本将链表`x`中的所有元素移动到当前链表的`position`位置。

2. `void splice (const_iterator position, list& x, const_iterator i);`
   这个版本将链表`x`中位置`i`的元素移动到当前链表的`position`位置。

3. `void splice (const_iterator position, list& x, const_iterator first, const_iterator last);`
   这个版本将链表`x`中`first`到`last`范围内的元素移动到当前链表的`position`位置。

在所有这些版本中，`position`是指向当前链表中元素的迭代器，`x`是另一个链表，`i`，`first`和`last`是指向`x`中元素的迭代器。所有版本都会修改两个链表，将元素从`x`移动到当前链表。移动后，`x`中的元素会被删除。

需要注意的是，`splice`函数只能用于同一种类型的链表，并且这些链表必须使用相同的分配器。否则，编译器将报错。