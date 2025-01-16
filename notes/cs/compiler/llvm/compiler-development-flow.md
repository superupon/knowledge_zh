# Compiler 代码开发流程
记录一下大家共识的一些关于开发流程上的约定。
## 1. 开发流程
大致可以分如下的一些步骤：
1.	GitLab中创建issue
2.	基于main branch创建issue对应的分支以及对应的merge request
3.	代码开发
4.	本地进行功能测试
5.	格式化修改，以及self review
6.	push commit到分支上，并提交merge request
7.	ci自动运行测试用例
8.	code review  (merger: wuyang, test case only: swim or yuchen)
9.	deliver到main分支

 
## 2. 流程细节
为了更好的维护整个项目，以及节约大家事后trace问题的时间。这里提出一些推荐的做法。供大家参考后共同遵守。

### 2.0 背景信息
目前git代码合入的策略是git merge, 即开发分支上的所有commit都会合入进来。同时，merge本身会产生一个commit. （这意味着每个merge的commit都是高质量commit，CI的daily build只会pick main分支上，每天的最后一个merge commit作为build的基线) ![Merge Commit](pictures/merge-commit.png)

 
这里不推荐多分支管理的方式，而只保留一个main分支。

**为什么不采用squash commit的方式？**
•	squash commit的方式，即使是在不删除source branch的情况下，也无法呈现分支树的形式。丢失了不少信息。
•	如果想要学习某个feature的具体实现，没有历史commit的情况下，难以理解是怎么演变的。
•	代码的问题难以追溯到真正的源头。
因此目前阶段，暂时以缺省的`git merge`作为默认合入方式。
 

如果试运行一段时间，仍然有大量的问题，再考虑squash commit的方式合入。

**Release分支的策略**
如果后期需要管理official release，可以只为某个正式发布的版本开release分支。该分支只用于fix bug.

### 2.1 issue的管理
目前GitLab系统中，对于issue是没有分类的。但很显然，拥有分类会让所有的issue更清晰。
有两种方式可以进行issue的管理, (这里推荐用命名的方式进行管理)
* 命名
    Conventional Commits 根据这里对于Commit的约定，我们可以使用例如`feat(llc): add support for new yis instruction`的形式来命名一个issue. 名字本身就代表了分类信息。（表示这个issue是在实现一个feature, 和llc有关）。这有一个好处是，在创建branch时，自动会生成1-feat-llc-add-suuport-for-new-yis-instruction的branch.

    issue的粒度基本和commit接近。一般一个issue对应两三个commit, 都对应于完成issue中的主题。

    而scope可以参考如下的命名方式,  这里的scope也可以用于后面commit消息中的scope：（scope的命名原则是尽可能精炼，比较容易理解）
    *	scope命名分类 （后面增加的scope都可以列在此处，只要大家align好就可以。）
        *	按feature，可以横跨多个component
            *	meta (metadata)
            *	kd (kernel descriptor)
            *	intrinsic (YBX instructions)
            *	yica (YICA dialect)
        *	按LLVM component
            *	clang, (表示仅前端相关改动)
            *	llc，（表示仅后端改动）
            *	opt，（表示仅LLVM IR层改动）
            *	mc，（表示仅汇编器相关改动）
            *	mlir,  (表示仅MLIR层的改动)
            *	objdump, (表示仅工具objdump的改动)

* Label
	label是借助于GitLab提供的功能，但是它的信息比较单一，不如通过命名来得比较灵活。

### 2.2 branch命名
branch的名字起始以Commit的具体分类为起始。比如commit是test(clang): xxxxx, 那么branch的起始名字是123-test-clang-*(这个可以GitLab帮助自动生成)

### 2.3 Commit 消息命名
参考如下的文档，可以看到commit的消息可以按照命名issue的方式进行命名commit.

由于我们采取的是git merge的分支管理策略，这要求每个在开发分支上的commit都有比较高的质量。（当然, 如果开发分支上的commit暂时没有厘清，可以在本地进行rebase之后再push, 或者远程的分支上已经有不想出现的commit时，可以采用本地rebase 再加上git push -f的方式强制修改远程分支。）

这里简单的约定一下分类以及消息的格式：
*	**消息格式**
比较推荐的做法是commit with scope, 示例如下
```bash
feat(clang): add support for xxx 
// 空一行
add detailed description here
....
....
```
*	**commit分类**
    *	fix, 用于修正某些代码的问题
    *	feat，用于开发新的功能
    *	build，用于在构建方面commit的管理
    *	chore，不改动生产代码的commit, 这个链接中有一些讨论 When to use "chore" as type of commit message? （我们这里可以约定成，不符合其它分类的commits）
    *	ci, 描述ci相关的commit, （这个主要由CI的人维护）
    *	docs，描述文档相关的改动
    *	style，描述代码风格相关的改动
    *	refactor，描述代码重构方面的改动
    *	perf，描述性能相关改动
    *	test，描述仅测试用例的相关改动

### 2.4 本地功能测试
每个commit, 最好在本地能保证build是过的。
同时，可以利用make check-all或者ninja check-all来跑所有的unit test和regression test, 看是否引入了问题。

对于新feature, 或者bug fix, 可以添加对应的测试用例来进行覆盖, 以防被break.

关于测试用例和框架，可以参考这篇文档， LLVM Test Framework
关于测试用例实现的约定，可以参考这份文档， G100 Compiler Test Cases Design

### 2.5 代码格式化
对于改动的代码，推荐可以使用Visual Studio Code中的Format工具（调的是clang-format）, 把Fomat格式设置成LLVM, 进行格式化。

 
这一点会在CI的Pre-Build检查时会自动进行检查。

代码风格目前只以clang-format为主。其它的工具在功能上和clang-format有较大的重叠。
### 2.6 Self Review
如果想有代码提交有更高的效率，推荐自己本身使用diff工具查看自己的改动。（大多数问题都可以通过review来发现。）

这样可以避免reviewer花过多的时间指出简单问题。
（Tips: 添加必要的注释，以及assert可以帮助reviewer更好的理解code）

### 2.7 Resolve CI Issue
目前的CI部署会在内网进行，这就意味着具体CI跑的报错信息可能需要到内网进行查看。（可以以邮件的形式在外网提供摘要）

CI会自动进行多种形式，多个维度的检查（**style, static check, regression, performance, memory**），以保证代码质量。

对于某些代码如果确实不需要检查，可以通过某种基于注释的语法进行过滤。过滤的方式后面会在下面列出。

* clang-format
	在//clang-format off或者/* clang-format off */和//clang-format on或/*clang-format off*/之间的代码不会被格式化，CI也不会检查
* clang-tidy
    Extra Clang Tools 20.0.0git documentation
    具体可以参考上面的链接。
* clangsa
    对于 Clang Static Analyzer，可以使用以下注释来禁用检查：
```cpp
int myFunction() {
// The following pragma disables static analyzer warnings for this function
#ifndef __clang_analyzer__
// Your code here
#endif
}
```
或者，你可以在特定位置使用 attribute((analyzer_noreturn))：
C++
[[clang::analyzer_noreturn]] void myFunction() {
// Your code here
}

* cppcheck
￮	使用cppcheck-suppress

同步自文档: https://q4e81ymnxv.feishu.cn/docx/KhHSduGMNowejPxFpXzcYM1cnrl#KFZMdci0ss7twlbRLWicqRIinwf

### 2.8 Code Review
具体可以参考这个里面的信息， Code Review Guideline

### 2.9 Check Weekly Report
CI会在Weekly build中做更多比较费时的检查（Memory, Performance, Full Static Check, 等等）。如果问题可以自动narrow down, 那么会以邮件的形式进行提醒。

关于CI, 如果想了解更多的信息，也可以参考这份主要和CI team沟通的文档。Compiler CI & CD Setup Plan

大家如果有任何疑问或者顾虑，欢迎随时沟通 :)