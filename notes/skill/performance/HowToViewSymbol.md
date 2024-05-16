# Symbol相关的操作

## 查看符号的工具和命令

1. `readelf`: `readelf` 是一个可以显示详细的关于ELF文件信息的命令行工具，包括符号的可见性。你可以使用`-s` 或者 `--symbols` 选项来查看符号表和它们关联的可见性。 举个例子:

   ```bash
   readelf -s <file>
   ```

   ```cpp
   readelf -s /usr/bin/ls
   Symbol table '.dynsym' contains 139 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND 
     1: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND __ctype_toupper_loc@GLIBC_2.3 (2)
     2: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND getenv@GLIBC_2.2.5 (3)
     3: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND sigprocmask@GLIBC_2.2.5 (3)
     4: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND __snprintf_chk@GLIBC_2.3.4 (4)
     5: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND raise@GLIBC_2.2.5 (3)
     6: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND abort@GLIBC_2.2.5 (3)
     7: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND __errno_location@GLIBC_2.2.5 (3)
     8: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND strncmp@GLIBC_2.2.5 (3)
     9: 0000000000000000     0 NOTYPE  WEAK   DEFAULT  UND _ITM_deregisterTMCloneTab
    10: 0000000000000000     0 FUNC    GLOBAL DEFAULT  UND localtime_r@GLIBC_2.2.5 (3)
    ```

2. `nm`: `nm` 是另外一个命令行工具，可以显示符号表信息。它可以通过`-D` 或 `--dynamic`显示符号的可见性. `-C`可以用于demangling. 举个例子:

   ```shell
   nm -D <file>
   ```

3. `objdump`: `objdump` is a versatile command-line tool that can display various information about object files and binaries. You can use the `-t` or `--syms` option to view the symbol table and their visibility. For example:

   ```shell
   objdump -t <file>
   ```

4. 调试器: Debuggers such as `gdb` or `lldb` can provide extensive symbol information and allow you to inspect the visibility of symbols during debugging sessions. You can set breakpoints, examine symbols, and view their visibility at runtime.

These tools provide different levels of information and formatting options. Choose the one that suits your needs and the specific requirements of your project. Remember to refer to the documentation or man pages of the respective tools for more details on their usage and available options.
