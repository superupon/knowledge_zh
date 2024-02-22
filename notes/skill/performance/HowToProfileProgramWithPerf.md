# How to profile your running program with perf

## Why no symbol names, only address?
Sometimes, you may find that perf does not show any symbol name, only address. Then please check your perf, which perf your are using?

With debug version of application, it will show a lot of information and call graph are almost accurate. But `RelWithDebInfo` still can not show a lot of information.

## Commands freqently used
* `perf stat -d -d -- [your command]`
* `perf record -F max -g -- [your command]` and `perf report`
* `perf record -F max -g --call-graph dwarf -- [your command]`
  * This command can provide more accurate call graph information for the application you are running. 
  * You can refer to this link for more detailed discussion about symbols in perf [How can I get perf to find symbols in my program](https://stackoverflow.com/questions/10933408/how-can-i-get-perf-to-find-symbols-in-my-program)


# Backlink
* [Tools Used for Analysis Performance](ToolsUsedforAnalysisPerformance.md)

