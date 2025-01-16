# Compiler CI & CD Setup Plan
## 1. 测试范围
### 1.1 Build
*	Warning as error *
*	需要定义哪个系统是标准的deploy的系统. (举个例子，Debian xx.xx, kernel version xx.xx.xx) 20.04, >5.x, CentOS 7.9
### 1.2 Static code check
*	Lint *
*	Clang-tidy
*	CodeChecker
*	Address-sanitizer
*	Valgrind
### 1.3 Function Test
*	Unit Test *
*	Regression Test **
*	CModel Test (Kernel Level) --> 
*	Code Coverage Test

### 1.4 Performance Test
*	Compile
*	Dump Passes runtime, (make sure no abnormal algorithm design)
*	llvm-tools (llvm-mca, assembly level)
*	Emulator test? --> 
*	Chip test? -->
*	Cmodel test -->
*	XRay -->
## 2. CI & CD flow
Generally, there should be those stages,
*	build
*	Static Code-check
*	Functional Test (unit test & regression test)
*	Performance Test
*	Evaluation / Monitor (System to view results)
### 2.1 Trigger point
*	User commit
*	Daily Build
*	Weekly Build

### 2.2 User Triggerred
如下图所示，用户触发的CI & CD 包含以下几点：
*	Pre-Build Check
*	Buid, 
*	Static Check, 
*	Functional tests (unit test和regression test), 
*	基本的性能测试。
侧重在功能方面的完备性。

对于整个CI运行的时间，尽量缩减到30分钟之内，以便于高效的开发和迭代。

性能测试只作为最基本的guard条件来保证基本的性能指标没有明显变化。
 
### 2.3 Nightly Triggerred
Nightly build的任务会比较耗时. 旨在发现可能存在的性能问题。
运行任务如下：
*	所有的regression test, 
*	全量的性能测试。
*	build Debug版本的compiler
 


### 2.4 Weekly Triggerred
Weekly build的任务会更加侧重于不经常跑的，但又比较重要的任务. 
主要有以下几点：
*	内存错误分析(valgrind, address-sanitizer), 
*	代码覆盖率测试，
*	部分在static check不容易快速暴露的问题。

 
## 3.  Interface with CI & CD team
### 3.1 环境问题
* CI环境准备
    * 操作系统版本，kernel版本
    * 硬件需求
        *   注意，调试（Debug）版本的构建需要大量的时间和磁盘空间。仅构建 LLVM 需要大约 1-3 GB 的空间。完整构建 LLVM 和 Clang 需要大约 15-20 GB 的磁盘空间。具体的空间需求因系统而异。（之所以需要这么多空间，是因为所有的调试信息以及库被静态链接到多个工具中）。
    *	编译器版本
        > LLVM is written using the subset of C++ documented in coding standards. To enforce this language version, we check the most popular host toolchains for specific minimum versions in our build systems:

    	Clang >=5.0
    	GCC >=7.4
        *	最好提供两个以上compiler的build结果，用于保证较好的兼容性. （保留哪一份？）
    *	工具软件版本
        *	进一步参考可以参见这篇LLVM文档： Getting Started with the LLVM System ¶
*	Compiler代码准备
    *	需要将LLVM Repo在内网可见，（CI & CD会deploy在内网）
    *	外网repo: http://gitlab-arch.yizhu.local/yztoolchain/llvm18
*	关联工具准备
    *	CodeChecker：静态检查的一个框架（具体有以下几种检查工具，即analyzer）
    *	Clang Static Analyzer
    *	Clang Tidy *
    *	Clang Sanitizer
    *	CppCheck *
    *	Valgrind：内存分析工具，需要单独安装。
    *   gem5：拉Cmodel代码即可，cmodel环境自带。

### 3.2 CI & CD Stages定义
以下的各个stage分别会以前置准备，执行的命令，输出的格式，以及预期的输出三个部分进行展开。
#### 3.2.1 Pre-Build Check
Pre-Build阶段会做一些轻量级的任务，列举如下：
* commit消息的检查
* branch名字的检查
* code风格的检查
a) 前置准备
安装clang-format, 以及commit msg检查脚本。

b) 运行命令
*	commit msg检查 Conventional Commits
	根据Compiler代码开发流程 Compiler 代码开发流程约定，所有的commit消息格式需要符合如下的格式：
	`<type><scope>: <description>`
	type只可以是以下几类之一，**fix, feat, build, ci, docs, style, refactor, perf, test**
	scope可以任意字符串，但中间不能有空格比如llc, clang, intrinsics

	举例：fix(llc): fix wrong yis instruction generation
*	branch名字的检查
    *	branch名字必须是以<number>-<type>的形式作为起始。(<number>其实是issue id)
    *	例如：20-fix-llc-fix-wrong-yis-instruction-generation
*	clang-format检查改动的格式是否符合LLVM规范
	* 命令：clang-format --style=LLVM --dry-run xxx.c
	* 对于commit中的改动行，不能有clang-format的报错信息。

c) 预期输出
没有任何错误信息。

#### 3.2.2 Build
a) 前置准备
参见3.1中的环境准备中的内容，无其它额外准备工作。

b) 配置命令（产生makefile文件）
*	在llvm目录下mkdir build 
*	cd build目录
*	cmake 配置整个项目 (这个配置是否合理？)
*	cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_ENABLE_PROJECTS="clang;llvm"  -DLLVM_TARGETS_TO_BUILD="RISCV" -DLLVM_DEFAULT_TARGET_TRIPLE="riscv32-unknown-elf"../
*	视不同的compiler可以添加 -DCMAKE_C_COMPILER=gcc-11 -DCMAKE_CXX_COMPILER=g++-11 或 -DCMAKE_C_COMPILER=clang-12 -DCMAKE_CXX_COMPILER=clang++-12 (这里的11只是举例)
*	设置 -DCMAKE_lsINSTALL_PREFIX=/tmp/llvm
*	make install -j > build.log 2>&1 
*	需要同时提供Debug & Release的Compiler, 以供问题分析。

c) 输出格式
*	文本文件 build.log

d) 预期输出
*	仅包含commit改动的build error
*	所有warning都当成error处理，-DCMAKE_CXX_FLAGS="-Werror" -DCMAKE_C_FLAGS="-Werror"

#### 3.2.3 Static Check
Static Check的主要框架由CodeChecker工具来完成。关于CodeChecker的进一步使用，可以查看这个文档 CodeChecker Research Record
a) 前置准备
*	1) 工具准备
*	pip install codechecker (参考版本，6.23.1)
*	install clang & clang-tidy
*	install cppcheck
*	2) 输入数据准备
*	diff.txt (由git系统的diff命令产生的输出)
 
diff文件示例

*	需要有llvm的build目录，且已经完成build (某些文件单独重新build需要依赖之前生成的某些.inc文件)
*	需要有之前build的json compile database （通过添加cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1）

b) 执行命令
*	CodeChecker analyze compile_commands.json -o ./reports 该命令用于利用分析器分析代码。利用的compile命令存储在compile_commands.json这个文件中。
*	判断是否有change violate static check rules, 可以通过CodeChecker parse ./reports -e json -o ./reports/report.json 来生成报错信息的json表示。然后通过diff中的信息来进行判断。
*	CodeChecker parse ./reports -e html  -o ./reports_html
*	该命令可以将static check的数据以html网页的形式dump出来。这个可以存储到Server上某个位置，用于在GitLab中跳转查看具体的问题。
*	analyzer的配置可以通过命令行配置实现
*	举个例子：CodeChecker analyze compile_commands.json --analyzers clangsa,clang-tidy --tidyargs='-checks=-*,clang-analyzer-*,modernize-*' --saargs='-analyzer-checker=core,deadcode,security.insecureAPI'
*	--tidyargs和--saargs分别是传递给clang static analyzer和clang-tidy的参数信息，用于控制特定的错误检查逻辑。
*	具体的分析器分类，以及说明，请参考这个文档 Compiler Preferred Static Code Analyzer
*	需要实现一个python脚本来管理整个检查逻辑（让开发者只关注到他改动的部分所引起的静态检查问题）
*	对于间接错误，即当前改动引起另一处代码产生逻辑上的bug，可以通过Weekly的全量静态检查进一步进行捕获。参考2.1.3章节中的描述。

c) 输出格式
*	错误信息的.json文件 （用于判断是否改动引入了新的analyzer错误）
*	错误信息的html静态网页 （用于User定位具体的代码问题）

d) 预期输出
*	若有任何analyzer在改动的文件行上报错，则在GitLab上报错，中止后续的stage
*	在GitLab上输出简要的出错信息，并提供具体信息的链接，用于查看具体问题
*	若没有任何analyzer在改动的文件行上报错，则Statck Code Check Pass


#### 3.2.4 Functional Test
3.2.3.1 单元测试
a) 前置步骤
*	按照3.2.1中的cmake命令进行cmake配置，然后在llvm/build目录下执行

b) 执行命令
```bash
make check-llvm-unit -j
make check-clang-unit -j
```

c) 输出格式
*	具体的输出如下图所示，可以通过grep对应的pattern将错误输出获取到
 

d) 预期输出
*	没有Failed case, 若有任一case Failed就视为整个CI Fail了，中止后续流程，代码不能合入。

3.2.3.2 Regression tests
a) 前置命令
*	按照3.2.1中的cmake命令进行cmake配置，然后在根目录下执行
*	llvm-lit位于llvm/build/bin目录下

b) 执行命令
llvm-lit执行时要给出工具和test的绝对或相对路径。 LLVM Lit （LLVM Integrated Tester）
```bash
llvm-lit llvm/test （在build目录下是./bin/llvm-lit ../test）
llvm-lit clang/test (在build目录下是./bin/llvm-lit ../test)
```

c) 输出格式
 
d) 预期输出
*	没有Failed, 任一case Failed视为整个CI Fail了，代码不可以合入。

#### 3.2.5 Code Coverage Test
Source-based Code Coverage
对于代码覆盖率的测试，可以采用gcc提供的coverage功能来进行实现。
步骤如下：
*	利用gcc作为compiler, 添加--coverage参数进行编译整个compiler项目
*	运行单元测试以及regression测试，收集coverage数据
*	生成html格式的report
*	利用git blame, 获取对应行的开发者信息，然后append到html文件中
*	统计每个开发者开发行数，未覆盖代码行数，可以按未覆盖比例或者代码行总量进行排序。

代码覆盖率的测试可以在Weekly build的时候进行。不需要每次commit, 或者每天跑。

#### 3.2.6 Memory Test
由于Memory test不是基于一个commit的。可能需要额外的脚本来定位负责的开发者。
1) valgrind
    valgrind的安装和cppcheck类似，可以通过apt-get之类的方式进行安装。

    对于unit test和regression test, 我们可以利用lit来进行valgrind的调用。只需要将参数中加上 -v --vg --vg-leak（如果是通过make命令的话，可以用make check-all LIT_ARGS="-v --vg --vg-leak"）

2) address-sanitizer
    Clang Sanitizer
    运行clang的sanitizer进行测试，可以通过添加编译参数进行。
    我们需要的是以下这四个方面的测试。
    *	Address Sanitizer
    *	Memory Sanitizer
    *	UndefinedBehavior Sanitizer
    *	Leak Sanitizer
    cmake -DCMAKE_C_FLAGS="-fsanitize=address,memory,leak,undefined" -DCMAKE_CXX_FLAGS="-fsanitize=address,memory,leak,undefined"

注意：Santizer的报错信息不止会在编译时报告，同样在compiler运行时也会报错。因此需要捕获编译时的错误信息，同时运行单元测试和regression测试，拿到运行的错误信息。

### 3.3 性能测试
由于性能测试极为重要，这里单列一个章节来进行具体描述以及定义测试过程。
#### 3.3.1 性能参数
定义对Compiler来说，比较关键的性能参数
*	Compile
    *	Time, (CT), 即编译时间，编译Kernel的时间需要作为一个性能参数被monitor起来，以防有效率不高的算法被引入。
    *	Memory，(CM), 即编译内存，编译Kernel时，Compiler需要分配内存进行编译和优化，效率比较差的实现可能造成内存的过度使用。
    *	Executable Size，(ES),  即编译生成的二进制文件大小，文件过大可能造成不必要的Cache Miss, 甚至消耗宝贵的片上指令空间。（*）
*	Run
    *	Time，(RT), 即运行时间，某个Kernel在特定环境下的执行时间 （*）
    *	Memory，(RM), 运行时消耗的内存，主要是动态内存和总内存的开销。（如果不符合实际，可以不要）

#### 3.3.2 执行环境
不同的执行环境可能可以暴露不同的性能问题。这里列举一下可能的执行环境。
*	Simulator (Gem5)
仿真器的资源开销比较小，也容易Debug.
*	FPGA
环境极为接近真实的硬件，性能更强，得到的结果数据更有代表性。
*	Chip
真实的硬件环境。

#### 3.3.3 必要条件
硬件资源在测试时的独占性。出于节约资源目的而进行的共享环境的性能测试，没有任何意义。

#### 3.3.4 测试粒度
*	Kernel级别 （C级别和Triton级别）

#### 3.3.5 静态性能分析
汇编级别的静态代码分析。
llvm-mca.

### 3.4 Report
对于Per Commit, Nightly, Weekly跑的CI结果，需要有邮件形式的输出进行提醒。
对于Per Commit的报告，可以提供给对应的开发者。
对于Nightly, Weekly的报告，可以发给compiler的owner进行统筹解决。
