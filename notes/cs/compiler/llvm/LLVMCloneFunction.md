# 关于LLVM::CloneFunctionInto的使用

`llvm::CloneFunctionInto` 是 LLVM 的一个函数，用于将一个函数的内容（基本块和指令）克隆到另一个现有的函数中。这是一种深度克隆，它会创建新的基本块和指令，而不仅仅是复制引用。

这个函数的典型用法是当你想要创建一个现有函数的变种或版本时使用。它允许你在不修改原始函数的情况下创建一个新版本，并可能对新版本应用一些优化或变换。

`llvm::CloneFunctionInto` 的原型大致如下：

```cpp
void CloneFunctionInto(Function *NewFunc, const Function *OldFunc,
                       ValueToValueMapTy &VMap, bool ModuleLevelChanges,
                       SmallVectorImpl<ReturnInst *> *Returns = nullptr,
                       const char *NameSuffix = "", ClonedCodeInfo *CodeInfo = nullptr,
                       ValueMapTypeRemapper *TypeMapper = nullptr,
                       ValueMaterializer *Materializer = nullptr);
```

- `NewFunc` 是目标函数，即你要将内容克隆到的函数。
- `OldFunc` 是你要克隆的源函数。
- `VMap` 是一个从源值到目标值的映射，通常用于记录哪些值在克隆过程中被复制。
- `ModuleLevelChanges` 是一个布尔标志，表示是否允许修改模块级别的别名等。
- `Returns` 是一个可选参数，可以用于收集克隆函数中的返回指令。
- `NameSuffix` 是一个可选参数，指定添加到克隆值的名称的后缀。
- `CodeInfo` 是一个可选参数，可用于收集有关克隆代码的信息。
- `TypeMapper` 和 `Materializer` 用于更高级的用途，如类型映射和值材料化。

需要注意的是，`llvm::CloneFunctionInto` 不会自动添加新的函数到模块中，也不会处理任何调用站点的更改。这些任务需要在调用 `CloneFunctionInto` 之前或之后手动完成。

## 那如果源函数中调用了其它函数，我也想把这些被调用的函数复制过来，应该怎么做呢？

如果你想要克隆源函数以及它调用的所有函数，你需要遍历源函数的指令，找到所有的函数调用，并递归地克隆这些调用的函数。你可以使用深度优先搜索来遍历并克隆整个调用图。

下面是一个简单的示例代码，展示了如何使用 LLVM 进行此操作：

```cpp
#include <llvm/IR/Function.h>
#include <llvm/Transforms/Utils/Cloning.h>
#include <set>

void cloneFunctionAndCallees(llvm::Function* target, const llvm::Function* source,
                             llvm::ValueToValueMapTy& VMap, llvm::Module& module,
                             std::set<const llvm::Function*>& visited) {

    // 克隆源函数到目标函数
    llvm::CloneFunctionInto(target, source, VMap);

    // 遍历源函数的指令
    for (auto& BB : *source) {
        for (auto& I : BB) {
            if (auto* callInst = llvm::dyn_cast<llvm::CallInst>(&I)) {
                // 检查是否为函数调用
                auto* calledFunction = callInst->getCalledFunction();
                if (calledFunction && visited.find(calledFunction) == visited.end()) {
                    // 克隆被调用的函数
                    auto* newFunction = llvm::Function::Create(calledFunction->getFunctionType(),
                                                llvm::GlobalValue::LinkageTypes::ExternalLinkage,
                                                calledFunction->getName() + "_clone",
                                                &module);
                    visited.insert(calledFunction);
                    cloneFunctionAndCallees(newFunction, calledFunction, VMap, module, visited);
                }
            }
        }
    }
}

void cloneFunctionWithCallees(llvm::Function* target, const llvm::Function* source, llvm::Module& module) {
    llvm::ValueToValueMapTy VMap;
    std::set<const llvm::Function*> visited;
    cloneFunctionAndCallees(target, source, VMap, module, visited);
}
```

上面的代码定义了两个函数，`cloneFunctionAndCallees` 和 `cloneFunctionWithCallees`。`cloneFunctionWithCallees` 是主函数，它开始克隆过程。`cloneFunctionAndCallees` 是一个递归函数，它会克隆指定的源函数及其调用的函数。

请注意，这个示例假设你已经熟悉 LLVM，并且已经设置了适当的环境。这只是一个基本的示例，你可能需要根据你的具体需求对其进行调整。
