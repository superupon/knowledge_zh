# 如何使用不同版本的compiler

在 CMake 中，你可以通过设置 `CMAKE_CXX_COMPILER` 变量来指定使用哪个版本的 g++ 编译器。这可以在命令行中设置，也可以在 `CMakeLists.txt` 文件中设置。

下面是一些方法：

1. **在命令行中设置**：
   在运行 `cmake` 命令时，可以通过 `-D` 选项设置 `CMAKE_CXX_COMPILER` 变量，以指定要使用的 g++ 路径。例如：

   ```sh
   cmake -DCMAKE_CXX_COMPILER=/path/to/your/g++ your-source-directory
   ```

   替换 `/path/to/your/g++` 为你想要使用的 g++ 版本的路径。

2. **在 `CMakeLists.txt` 文件中设置**：
   你可以在项目的 `CMakeLists.txt` 文件的顶部设置 `CMAKE_CXX_COMPILER` 变量。注意，这必须在 `project()` 声明之前设置。

   ```cmake
   set(CMAKE_CXX_COMPILER "/path/to/your/g++")
   project(YourProjectName)
   ```

   同样，替换 `/path/to/your/g++` 为你想要使用的 g++ 版本的路径。

注意，在设置不同版本的 g++ 时，务必确保它是与你的代码和依赖项兼容的。在修改编译器设置后，通常建议从一个干净的构建目录开始，以避免任何潜在的构建问题。