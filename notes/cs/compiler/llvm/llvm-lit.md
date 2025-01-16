# LLVM Lit （LLVM Integrated Tester）
## 1. 描述
它是一个可移植的用于执行LLVM和Clang风格测试用例，总结运行结果和提供错误指示的工具。它被设计成一个轻量级的测试工具，提供尽可能简单的用户接口。

lit可以运行一个或多个tests. 测试可以是单独的测试文件或者用于搜索的目录。

每个指定的测试都将被执行（可能是并发执行），一旦所有测试运行完毕，lit 将打印关于通过或失败的测试数量的摘要信息（参见测试状态结果）。如果有任何测试失败，lit 程序将以非零退出代码执行。

默认情况下，lit 将使用简洁的进度显示，并且只打印测试失败的摘要信息。参见输出选项以获取控制 lit 进度显示和输出的选项。

lit 还包括许多控制测试如何执行的选项（具体功能可能取决于特定的测试格式）。参见执行选项以获取更多信息。
最后，lit 还支持其他选项，只运行命令行中指定选项的一个子集，参见选择选项以获取更多信息。

lit 在解析命令行选项后，会从环境变量 LIT_OPTS 中解析选项。LIT_OPTS 主要用于补充或覆盖由项目构建系统定义的检查目标提供给 lit 的命令行选项。

lit 还可以从响应文件中读取选项，这些文件使用 @path/to/file.rsp 语法指定。从文件中读取的参数必须每行一个，并且被视为与命令行中原始文件引用参数在同一位置。响应文件可以引用其他响应文件。
对 lit 架构或设计 lit 测试实现感兴趣的用户应该参见 lit 基础设施。

## 2. 常用选项
注意，这里只是列举其中一部分选项，完整的选项请参考源文档，或者直接利用help进行查询。
 
### 2.1 通用选项
*	-h, --help
显示帮助信息。
*	-j N, --workers=N
并行运行 N 个测试。默认情况下，这个值会自动选择为检测到的可用 CPU 数量。
*	--config-prefix=NAME
在搜索测试套件时，使用 NAME.cfg 和 NAME.site.cfg 代替 lit.cfg 和 lit.site.cfg。
*	-D NAME[=VALUE], --param NAME[=VALUE]
添加一个用户定义的参数 NAME，并赋予给定的 VALUE（如果未指定值，则为空字符串）。这些参数的含义和用途取决于具体的测试套件。

### 2.2 输出选项
*	-q, --quiet
仅显示测试失败的输出，抑制其他所有输出。
 ![quiet输出](pictures/quiet-output-llvm-lit.png)
-q 选项的一个示例输出

*	-s, --succinct
减少输出，例如不显示通过测试的信息。同时，显示进度条，除非指定了 --no-progress-bar。
*	-v, --verbose
显示更多关于测试失败的信息，例如显示完整的测试输出，而不仅仅是测试结果。
每个命令在执行前都会打印出来。这对于调试测试失败非常有用，因为最后打印的命令就是失败的那个。此外，lit 会在输出中每个命令管道前插入 'RUN: at line N'，帮助你定位失败命令的源代码行。
*	-a, --show-all
启用 -v，但不仅仅针对失败的测试，而是针对所有测试。
*	--no-progress-bar
不使用基于 curses 的进度条。
*	--show-unsupported
显示不支持的测试名称。注意，这个选项会在跑所有case的情况下，在最后输出unsupported cases的名字
*	--show-xfail
显示预期失败的测试名称。注意，这个选项会在跑所有case的情况下，在最后输出expectedly failed cases的名字

### 2.3 执行选项
*	--path=PATH
指定在测试中搜索可执行文件时使用的额外路径。
*	--vg
在 valgrind（使用 memcheck 工具）下运行单个测试。valgrind 的 --error-exitcode 参数被使用，因此 valgrind 失败将导致程序以非零状态退出。
启用此选项时，lit 还会自动提供一个“valgrind”特性，可用于有条件地禁用某些测试（或预期其失败）。

 ![没有安装valgrind时的输出](pictures/no-valgrind-llvm-lit-output.png)
没有valgrind安装时的输出

*	--vg-arg=ARG
当使用 --vg 时，指定传递给 valgrind 本身的额外参数。
*	--vg-leak
当使用 --vg 时，启用内存泄漏检查。启用此选项时，lit 还会自动提供一个“vg_leak”特性，可用于有条件地禁用某些测试（或预期其失败）。
*	--skip-test-time-recording
禁用对每个测试执行所花费时间的记录。
*	--time-tests
记录每个测试执行所花费的时间，并在总结输出中包含结果。这对于确定测试套件中哪些测试执行时间最长非常有用。
*	--ignore-fail
即使某些测试失败，也会以状态码零退出。

### 2.4 选择选项
该部分的选项主要用于缩小测试集范围。

默认情况下，lit 会优先运行失败的测试，然后按执行时间递减的顺序运行测试，以优化并发性。可以使用 --order 选项更改执行顺序。
时间数据存储在 test_exec_root 目录下的 .lit_test_times.txt 文件中。如果该文件不存在，lit 将检查 test_source_root 目录中的文件，以便在干净构建时加速测试。
*	--per-test-coverage  
生成按测试用例划分的必要测试覆盖率数据（这涉及为每个 RUN 设置唯一的 LLVM_PROFILE_FILE 值）。覆盖率数据文件将输出到 config.test_exec_root 指定的目录中。

*	--max-failures N  
在达到指定的 N 次失败后停止执行。在执行前需要在命令行中传递一个整数参数。

*	--max-tests=N  
最多运行 N 个测试，然后终止。

*	--max-time=N  
最多花费 N 秒（大约）来运行测试，然后终止。注意，这不是 --timeout 的别名；两者是不同类型的时间限制。

*	--num-shards=M  
将选定的测试集分成 M 个大小相等的子集或“分片”，然后只运行其中之一。必须与 --run-shard=N 选项一起使用，该选项选择要运行的分片。环境变量 LIT_NUM_SHARDS 也可以代替此选项。这两个选项为在单独机器上并行执行大型测试套件（例如在大型测试农场中）提供了一种粗略的分区机制。

*	--order={lexical,random,smart}  
定义测试运行的顺序。支持的值有：
	* lexical：根据测试文件路径的字母顺序运行测试。此选项在需要可预测的测试顺序时非常有用。
	* random：随机顺序运行测试。
	* smart：优先运行之前失败的测试，然后按执行时间递减的顺序运行剩余测试。这是默认选项，因为它优化了并发性。

*	--run-shard=N  
选择要运行的分片，假设已提供 --num-shards=M 选项。两个选项必须一起使用，且 N 的值必须在 1 到 M 的范围内。环境变量 LIT_RUN_SHARD 也可以代替此选项。

*	--timeout=N  
每个单独测试最多运行 N 秒（大约）。0 表示没有时间限制，0 是默认值。注意，这不是 --max-time 的别名；两者是不同类型的时间限制。

*	--filter=REGEXP  
只运行名称与指定正则表达式 REGEXP 匹配的测试。环境变量 LIT_FILTER 也可以代替此选项，这在通过间接方式调用 lit 的环境中特别有用。

*	--filter-out=REGEXP  
过滤掉名称与指定正则表达式 REGEXP 匹配的测试。环境变量 LIT_FILTER_OUT 也可以代替此选项，这在通过间接方式调用 lit 的环境中特别有用。

*	--xfail=LIST  
将名称在分号分隔列表 LIST 中的那些测试视为 XFAIL。这在不想修改测试套件时非常有用。环境变量 LIT_XFAIL 也可以代替此选项，这在通过间接方式调用 lit 的环境中特别有用。

测试名称可以指定为相对于测试套件目录的文件名。例如：

```Bash
LIT_XFAIL="affinity/kmp-hw-subset.c;offloading/memory_manager.cpp"
```

在这种情况下，以下所有测试都会被视为 XFAIL：

*	libomp :: affinity/kmp-hw-subset.c
*	libomptarget :: nvptx64-nvidia-cuda :: offloading/memory_manager.cpp
*	libomptarget :: x86_64-pc-linux-gnu :: offloading/memory_manager.cpp

或者，测试名称可以指定为 LIT 输出中报告的完整测试名称。例如，我们可以调整前面的示例，以不将 nvptx64-nvidia-cuda 版本的 offloading/memory_manager.cpp 视为 XFAIL：

```Bash
LIT_XFAIL="affinity/kmp-hw-subset.c;libomptarget :: x86_64-pc-linux-gnu :: offloading/memory_manager.cpp"
```

*	--xfail-not=LIST  
不将指定的测试视为 XFAIL。环境变量 LIT_XFAIL_NOT 也可以代替此选项。语法与 --xfail 和 LIT_XFAIL 相同。--xfail-not 和 LIT_XFAIL_NOT 始终会覆盖所有其他 XFAIL 规范，包括命令行中后出现的 --xfail。主要目的是在不修改使用 XFAIL 指令的测试用例的情况下抑制 XPASS 结果。

### 2.5 其它选项
*	--debug  
在调试模式下运行 lit，用于调试配置问题和 lit 本身。

*	--show-suites  
列出已发现的测试套件并退出。不会真正运行。

*	--show-tests  
列出所有已发现的测试并退出。不会真正运行。
## 3. 退出状态
如果有任何FAIL或者XPASS结果，lit会返回1. 否则，它会以0退出。其它的退出代码会用于非测试相关的错误（比如，内部程序错误，或user error）
## 4. 测试发现
传递给 lit 的输入可以是单个测试，也可以是要运行的整个目录或测试层次结构。当 lit 启动时，它首先将输入转换为要运行的完整测试列表，作为测试发现的一部分。

在 lit 模型中，每个测试都必须存在于某个test suite中。lit 通过从输入路径向上搜索，直到找到 lit.cfg 或 lit.site.cfg 文件来解析命令行上指定的输入到test suite。这些文件既是test suite的标记，又是 lit 加载的配置文件，用于了解如何查找和运行测试套件中的测试。

一旦 lit 将输入映射到test suite中，它会遍历输入列表，添加单个文件的测试，并递归搜索目录中的测试。

这种行为使得指定要运行的测试子集变得容易，同时仍然允许测试套件配置精确控制如何解释测试。此外，lit 始终通过测试所在的test suite及其在test suite中的相对路径来识别测试。对于适当配置的项目，这使得 lit 能够为树外构建提供方便和灵活的支持。
## 5. 测试状态结果
每个测试最终会产生以下八种结果之一：
*	PASS
测试成功。
*	FLAKYPASS
测试在重新运行多次后成功。这仅适用于包含 ALLOW_RETRIES: 注释的测试。
*	XFAIL
测试失败，但这是预期的。这用于允许指定测试当前不起作用的测试格式，但希望将其保留在测试套件中。
*	XPASS
测试成功，但预期它会失败。这用于指定预期会失败但现在成功的测试（通常是因为它们测试的功能已修复）。
*	FAIL
测试失败。
*	UNRESOLVED
测试结果无法确定。例如，这发生在测试无法运行、测试本身无效或测试被中断时。
*	UNSUPPORTED
测试在当前环境中不受支持。这由能够报告不支持测试的测试格式使用。
*	TIMEOUT
测试运行了，但在完成前超时。这被视为失败。
根据测试格式，测试可能会产生有关其状态的其他信息（通常仅针对失败）。有关更多信息，请参阅 "OUTPUT OPTIONS" 部分。
## 6. LIT基础架构
此部分描述了 lit 测试架构，供有兴趣创建新的 lit 测试实现或扩展现有实现的用户参考。
lit 本身主要是一个用于发现和运行任意测试的基础设施，并为这些测试提供一个方便的接口。lit 本身并不知道如何运行测试，而是由test suite定义这些逻辑。

### 6.1 TEST SUITES
如 "测试发现" 中所述，测试总是位于某个test suite中。test suite用于定义它们包含的测试格式、查找这些测试的逻辑以及任何额外的运行测试的信息。
lit 将包含 lit.cfg 或 lit.site.cfg 文件的目录识别为test suite（另请参阅 --config-prefix）。测试套件通过递归搜索传递给命令行的所有输入文来初步发现。您可以使用 --show-suites 在启动时显示已发现的测试套件。
一旦发现测试套件，其配置文件将被加载。配置文件本身是 Python 模块，将被执行。当配置文件被执行时，两个重要的全局变量被预定义：
*	lit_config
全局 lit 配置对象（一个 LitConfig 实例），定义了内置测试格式、全局配置参数和实现测试配置的其他辅助例程。
*	config
这是test suite的配置对象（一个 TestingConfig 实例），配置文件应填充此对象。config 对象上还提供以下变量，有些必须由配置文件设置，其他变量是可选或预定义的：
	*	name [必需] 测试套件的名称，用于报告和诊断。
	*	test_format [必需] 将用于发现和运行测试套件中的测试的测试格式对象。通常，这将是来自 lit.formats 模块的内置测试格式。
	*	test_source_root 测试套件根目录的文件系统路径。对于目录外构建，这是将扫描测试的目录。
	*	test_exec_root 对于目录外构建，位于对象目录中的测试套件根路径。这是测试运行和放置临时输出文件的地方。
	*	environment 执行测试时使用的环境字典。
	*	standalone_tests 当为真时，标记预期独立运行测试的目录。对于该目录禁用测试发现。当此变量为真时，lit.suffixes 和 lit.excludes 必须为空。
	*	suffixes 对于扫描目录中的测试的 lit 测试格式，此变量是标识测试文件的后缀列表。由 ShTest 使用。
	*	substitutions 对于将变量替换到测试脚本中的 lit 测试格式，替换列表。由 ShTest 使用。
	*	unsupported 标记不支持的目录，该目录中的所有测试都将报告为不支持。由 ShTest 使用。
	*	parent 父配置对象，这是包含测试套件的目录的配置对象，或为 None。
	*	root 根配置对象。这是项目中最高级的 lit 配置。
	*	pipefail 通常，如果管道中的任何命令失败，使用 shell 管道的测试将失败。如果不需要这样，设置此变量为 false 使测试仅在管道中的最后一个命令失败时失败。
	*	available_features 一组可以在 XFAIL、REQUIRES 和 UNSUPPORTED 指令中使用的功能。

### 6.2 TEST发现
一旦定位了test suite，lit 会递归遍历源目录（遵循 test_source_root）查找测试。当 lit 进入子目录时，它首先检查是否在该目录中定义了嵌套test suite。如果是，它会递归加载该test suite，否则它会为目录实例化一个本地测试配置（请参阅本地配置文件）。
测试通过它们所在的test suite及其在套件中的相对路径来识别。请注意，相对路径可能不会指向磁盘上的实际文件；某些测试格式（如 GoogleTest）定义了“虚拟测试”，其路径包含实际测试文件的路径和用于识别虚拟测试的子路径。
 
--debug的一些log输出

### 6.3 本地配置文件
当 lit 加载test suite中的子目录时，它通过克隆父目录的配置来实例化本地测试配置——此配置链的根始终是一个test suite。克隆测试配置后，lit 会检查子目录中是否有 lit.local.cfg 文件。如果存在，该文件将被加载，并可用于专门化每个单独目录的配置。此功能可用于定义可选测试的子目录，或更改其他配置参数——例如，更改测试格式或标识测试文件的后缀。

### 6.4 替换
lit 允许在 RUN 命令中替换模式。它还提供了以下基本替换集，这些替换在 TestRunner.py 中定义：
*	%s
源路径（当前运行的文件路径）。
*	%S
源目录（当前运行的文件目录）。
*	%p
同 %S。
*	%{pathsep}
路径分隔符。
*	%{fs-src-root}
指向 LLVM 检出的文件系统路径的根组件。
*	%{fs-tmp-root}
指向测试临时目录的文件系统路径的根组件。
*	%{fs-sep}
文件系统路径分隔符。
*	%t
测试唯一的临时文件名。
*	%basename_t
%t 的最后路径组件，但没有 .tmp 扩展名。
*	%T
%t 的父目录（不是唯一的，已弃用，不要使用）。
*	%%
%。
*	%/s
%s，但 \ 替换为 /。
*	%/S
%S，但 \ 替换为 /。
*	%/p
%p，但 \ 替换为 /。
*	%/t
%t，但 \ 替换为 /。
*	%/T
%T，但 \ 替换为 /。
更多替换请参见源文档。

其他替换是基于此基本替换集的变体，并且可以由每个测试模块定义更多替换模式。有关替换的更详细信息，请参阅 LLVM 测试基础设施指南。

### 6.5 测试输出格式
lit 的测试运行输出符合以下模式，无论是在简短模式还是详细模式（尽管在简短模式下不会显示 PASS 行）。该模式被选择为相对容易被机器可靠解析（例如在 buildbot 日志抓取中）以及其他工具生成。
每个测试结果应出现在与以下模式匹配的行上：
```
<result code>: <test name> (<progress info>)
```
其中 <result-code> 是标准测试结果，如 PASS、FAIL、XFAIL、XPASS、UNRESOLVED 或 UNSUPPORTED。性能结果代码 IMPROVED 和 REGRESSED 也是允许的。
<test name> 字段可以包含不带换行符的任意字符串。
`<progress info>` 字段可以用于报告进度信息，如 (1/300)，也可以为空，但即使为空也需要括号。
每个测试结果可以包括以下格式的额外（多行）日志信息：
```
<log delineator> TEST '(<test name>)' <trailing delineator>
... log message ...
<log delineator>
```
其中 <test name> 应为之前报告的测试名称，<log delineator> 是至少四个 “*” 字符的字符串（推荐长度为 20 个字符），<trailing delineator> 是任意（未解析）的字符串。
以下是包含四个测试 A、B、C 和 D 的测试运行输出示例，以及失败测试 C 的日志消息：

```bash
PASS: A (1 of 4)
PASS: B (2 of 4)
FAIL: C (3 of 4)
******************** TEST 'C' FAILED ********************
Test 'C' failed as a result of exit code 1.
********************
PASS: D (4 of 4)
```

### 6.6 默认特性
为了方便起见，lit 会自动为某些常见用例添加 available_features。
lit 根据正在构建的操作系统自动添加功能，例如：system-darwin、system-linux 等。lit 还会根据当前架构自动添加功能，例如 target-x86_64、target-aarch64 等。
在启用 sanitizers 时构建时，lit 会自动添加 sanitizer 的简短名称，例如：asan、tsan 等。
要查看可以添加的功能的完整列表，请参阅 llvm/utils/lit/lit/llvm/config.py。

