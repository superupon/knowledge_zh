# pushd命令

在Linux中，`pushd`命令用于操作目录栈。它允许你可以改变目录的同时，保存当前的目录，因此你可以很方便的navigate back到之前的目录当中。

Here's how `pushd` works:

1. When you execute `pushd` followed by a directory path, it changes the current directory to the specified directory and saves the current directory onto the directory stack.

2. The directory stack keeps track of the directories you have visited. The top of the stack represents the current directory, and the previous directories are stored below it.

3. Each time you use `pushd` to change directories, it pushes the current directory onto the stack and sets the new directory as the current directory.

4. You can use the `dirs` command to view the directory stack and see the list of directories you have visited.

5. To navigate back to a previous directory, you can use the `popd` command. It pops the top directory from the stack and changes the current directory to the directory that was below it.

Here's an example to illustrate the usage:

```shell
$ pushd /home/user/Documents  # Change to /home/user/Documents and save the current directory
/home/user/Documents ~

$ pushd /var/log  # Change to /var/log and save the previous directory
/var/log /home/user/Documents ~

$ pushd /tmp  # Change to /tmp and save the previous directory
/tmp /var/log /home/user/Documents ~

$ dirs  # View the directory stack
/tmp /var/log /home/user/Documents ~

$ popd  # Go back to /var/log and remove /tmp from the stack
/var/log /home/user/Documents ~

$ dirs  # View the updated directory stack
/var/log /home/user/Documents ~
```

In this example, the `pushd` command is used to navigate between different directories, and the `dirs` command is used to view the directory stack. The `popd` command is then used to navigate back to a previous directory by popping it from the stack.