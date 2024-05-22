# Find命令的一些技巧

## 基本用法

```bash
find [dir] -name "xxxx"
```

## 如何列举目录下文件数量

Try `find . -type f | wc -l`, it will count of all the files in the current directory as well as all the files in subdirectories. Note that all directories will not be counted as files, only ordinary files do.

### 更加友好的版本

```bash
find . -maxdepth 1 -type d | while read -r dir;
do printf "10%s: " "$dir"; find "$dir" -type f | wc -l; done
```

The first part: `find . -maxdepth 1 -type d` will return a list of all directories in the current working directory.  (Warning: -maxdepth is a GNU extension and might not be present in non-GNU versions of find.)  This is piped to...

The second part: while read -r dir; do (shown above as while read -r dir(newline)do) begins a while loop – as long as the pipe coming into the while is open (which is until the entire list of directories is sent), the read command will place the next line into the variable dir. Then it continues...

The third part: printf "%s:\t" "$dir" will print the string in $dir (which is holding one of the directory names) followed by a colon and a tab (but not a newline).

The fourth part: find "$dir" -type f makes a list of all the files inside the directory whose name is held in $dir. This list is sent to...

The fifth part: wc -l counts the number of lines that are sent into its standard input.

The final part: done simply ends the while loop.

So we get a list of all the directories in the current directory. For each of those directories, we generate a list of all the files in it so that we can count them all using wc -l. The result will look like:

./dir1: 234
./dir2: 11
./dir3: 2199
...

### 查看笔记文件的数量

```bash
find . -maxdepth 1 -type d | while read -r dir;
 do printf "%10s: " "$dir"; find "$dir" -type f -name "*.md" | wc -l; done
```

📖
