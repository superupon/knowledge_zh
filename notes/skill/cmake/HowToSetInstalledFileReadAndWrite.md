# CMake如何设置install的文件可读可写

在CMake中，当你使用`install()`命令来安装文件时，你可以使用`PERMISSIONS`参数来设置文件的权限。你可以指定多种权限，包括`OWNER_READ`, `OWNER_WRITE`, `GROUP_READ`, `GROUP_WRITE`, `WORLD_READ`, 等等。

下面是一个简单的示例，它展示了如何使用`install()`命令来设置文件的可读可写权限：

```cmake
cmake_minimum_required(VERSION 3.10)

project(ExampleProject)

# 添加一个可执行文件
add_executable(example example.cpp)

# 安装可执行文件，并设置权限为可读可写
install(TARGETS example
    DESTINATION /usr/local/bin
    PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ GROUP_WRITE)
```

这个示例中的`install()`命令会把可执行文件`example`安装到`/usr/local/bin`目录，并设置文件的权限，使得文件所有者和组成员都可以读取和写入文件。

请注意，设置文件权限应该谨慎进行，特别是当涉及到安全性的时候。通常，执行文件不需要为普通用户设置写权限。
