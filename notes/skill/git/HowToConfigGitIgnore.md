# git ignore设置

如果您想在Git中设置.gitignore文件，以忽略某些文件或文件类型，可以按照以下步骤进行操作：

1. 创建.gitignore文件：在您的Git项目根目录下创建一个名为.gitignore的文本文件。

2. 编辑.gitignore文件：使用任何文本编辑器打开.gitignore文件，并添加要忽略的文件、目录或文件类型的规则。每行一个规则。您可以使用以下规则格式：

   - 忽略特定文件：在新的一行中输入文件的路径或名称。例如：`example.txt`。
   - 忽略特定目录：在新的一行中输入目录的路径或名称，后跟斜杠（/）。例如：`example_directory/`。
   - 忽略特定文件类型：在新的一行中输入文件类型的规则，使用通配符。例如：`*.log`（忽略所有.log文件）。

   可以根据您的项目需要添加任意数量的规则。

3. 保存和提交.gitignore文件：保存并关闭.gitignore文件。将.gitignore文件添加到Git版本控制中，然后提交更改：

   ```bash
   git add .gitignore
   git commit -m "Add .gitignore file"
   ```

   确保.gitignore文件被正确添加到版本控制中。

.gitignore文件中的规则会告诉Git要忽略哪些文件，因此这些文件不会被包括在版本控制中。这对于排除构建输出、临时文件、日志文件、敏感数据等非必要的或机密的文件非常有用。

请注意，.gitignore文件仅在对应的Git仓库中生效，并且仅影响未被Git跟踪的文件。如果文件已经被Git跟踪，那么在添加规则到.gitignore之前，您需要使用`git rm --cached`命令将其从Git仓库中移除。

## git ignore的全局配置
对于多个项目都需要对某些特定的目录进行过滤，可以采用global ignore的方法：
* git config --global core.excludesfile ~/.gitignore_global
* 添加比如.cache/的规则到~/.gitignore_global这个文件当中。

这样的好处在于可以不用在git当中提交文件信息，但本地可以忽略掉这些本不需要处理的文件。

