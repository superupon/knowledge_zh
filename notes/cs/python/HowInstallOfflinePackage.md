在 Python 中，如果你处于一个没有互联网连接的环境，或者出于安全和稳定性的考虑需要在离线环境下安装包，可以通过以下步骤进行离线安装。

### 离线安装 Python 包的一般步骤

#### 1. 在有网络的环境下载所需的包及其依赖

首先，你需要在一个有网络的环境中下载你需要安装的包以及这些包的所有依赖。使用 `pip` 可以很方便地下载包和它们的依赖。

- **下载单个包及其依赖：**

  ```bash
  pip download somepackage
  ```

  这个命令会下载 `somepackage` 和它的所有依赖，但不进行安装。

- **指定 Python 版本：**

  如果你的目标环境和当前使用的 Python 版本不同，你应该指定正确的 Python 版本，确保下载与目标环境兼容的包。

  ```bash
  pip download somepackage -d /path/to/directory --platform manylinux1_x86_64 --python-version 36 --only-binary=:all:
  ```

  这里：

  - `-d /path/to/directory` 指定了下载文件存放的目录。
  - `--platform` 用于指定目标平台。
  - `--python-version` 指定目标 Python 版本，如 36 表示 Python 3.6。
  - `--only-binary=:all:` 指定只下载二进制包，不下载源码包。

- **下载特定版本的包：**

  ```bash
  pip download somepackage==1.2.3
  ```

  这将下载 `somepackage` 的 `1.2.3` 版本及其依赖。

- **同时下载多个包：**

  ```bash
  pip download somepackage anotherpackage
  ```

#### 2. 将下载的包传输到离线环境

将下载的包和依赖（通常是 `.whl` 文件和 `.tar.gz` 文件）复制到离线环境中。你可以使用 USB 驱动器、CD-ROM 或任何其他媒介将这些文件传输到离线环境。

#### 3. 在离线环境中安装这些包

在离线环境中，使用 `pip` 从本地目录安装这些包：

```bash
pip install --no-index --find-links=/path/to/downloaded/packages somepackage
```

这里：

- `--no-index` 告诉 `pip` 不要使用包索引源（也就是不在线查找）。
- `--find-links=/path/to/downloaded/packages` 指向包和依赖下载后存放的本地目录。

### 示例

假设你需要在离线的服务器上安装 `requests` 包。

1. **在线环境操作：**

   在有网络的机器上执行：

   ```bash
   mkdir /path/to/downloaded/packages
   pip download requests -d /path/to/downloaded/packages
   ```

   这会下载 `requests` 包及其依赖到指定的文件夹。

2. **将包复制到离线环境：**

   将 `/path/to/downloaded/packages` 目录中的所有文件复制到离线环境的相同目录中。

3. **离线环境操作：**

   在离线的服务器上执行：

   ```bash
   pip install --no-index --find-links=/path/to/downloaded/packages requests
   ```

   这条命令会从 `/path/to/downloaded/packages` 中查找 `requests` 和它的所有依赖，并进行安装。

### 注意事项

- 如果目标环境与源环境的操作系统或 Python 版本不同，需要在下载时指定正确的平台和 Python 版本。
- 对于纯 Python 包，通常不需要指定平台，但对于包含二进制扩展的包，这一步非常重要。
- 如果你有一个清单文件 (`requirements.txt`)，你可以用 `pip download -r requirements.txt` 下载清单中的所有包。
- 确保目标环境的 `pip` 版本与用于下载包的 `pip` 版本兼容。

这些步骤和方法应该可以帮助你在没有网络连接的情况下安装 Python 包。