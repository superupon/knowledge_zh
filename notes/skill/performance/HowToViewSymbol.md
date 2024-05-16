# Symbol相关的操作

## 查看符号的工具和命令

1. `readelf`: `readelf` 是一个可以显示详细的关于ELF文件信息的命令行工具，包括符号的可见性。你可以使用`-s` 或者 `--symbols` 选项来查看符号表和它们关联的可见性。 举个例子:

   ```bash
   readelf -s <file>
   ```

2. `nm`: `nm` is another command-line tool that displays symbol table information. It can show the visibility of symbols by using the `-D` or `--dynamic` option to display dynamic symbols or the `-C` option for demangling. For example:
   
   ```shell
   nm -D <file>
   ```

3. `objdump`: `objdump` is a versatile command-line tool that can display various information about object files and binaries. You can use the `-t` or `--syms` option to view the symbol table and their visibility. For example:
   
   ```shell
   objdump -t <file>
   ```

4. Debuggers: Debuggers such as `gdb` or `lldb` can provide extensive symbol information and allow you to inspect the visibility of symbols during debugging sessions. You can set breakpoints, examine symbols, and view their visibility at runtime.

These tools provide different levels of information and formatting options. Choose the one that suits your needs and the specific requirements of your project. Remember to refer to the documentation or man pages of the respective tools for more details on their usage and available options.
