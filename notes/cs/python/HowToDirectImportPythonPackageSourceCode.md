# 如何直接引入python依赖的库

可以直接引入 `prettytable` 的源代码而不通过 `pip install` 安装。这种方式通常是在你需要修改源代码或者不能安装包时使用。以下是实现这一目标的步骤：

1. **下载源代码**：
   - 你可以从 `prettytable` 的 [GitHub仓库](https://github.com/jazzband/prettytable) 下载源代码。
   - 点击“Code”按钮，选择“Download ZIP”，或者使用 Git 克隆仓库：
     ```bash
     git clone https://github.com/jazzband/prettytable.git
     ```

2. **项目结构**：
   - 将下载的 `prettytable` 文件夹放到你的项目目录中。
   - 确保 `prettytable` 文件夹中有 `__init__.py` 文件，这使得 Python 能识别它为一个模块。

3. **引入并使用**：
   - 假设你的项目文件结构如下：

     ```c
     your_project/
     ├── your_script.py
     └── prettytable/
         ├── __init__.py
         ├── prettytable.py
         └── ...
     ```

   - 在 `your_script.py` 中，你可以直接引入 `prettytable`：

     ```python
     from prettytable import PrettyTable
     
     # 使用 PrettyTable
     x = PrettyTable()
     x.field_names = ["City name", "Area", "Population", "Annual Rainfall"]
     x.add_row(["Adelaide",1295, 1158259, 600.5])
     x.add_row(["Brisbane",5905, 1857594, 1146.4])
     print(x)
     ```

这种方法适用于大多数 Python 库，只要它们不依赖于复杂的编译扩展。对于只包含纯 Python 代码的库（如 `prettytable`），这通常是一个简单有效的方法。

## 若遇到importlib.metadata.PackageNofFoundError: prettytable

这种情况下，把`__init__.py`里关于`metadata`的逻辑移除掉就可以了。
