# Part2

在这一部分中，有一些开放性的思考问题 (用 * 标注，例如 **Q2.3***)。我们对这些问题没有强制的要求，简单思考，视自己的兴趣挑选 0~1 个问题深入探究即可。

### Task 0

请阅读 SuFu 论文 `SuFu.pdf` 的前三章，了解 SuFu 工具的运行原理。

To prevent this, we restrict the program space of sketch holes to include only recursion-free programs that run in O (1) time.

几个问题：
1. 在AutoLabel之前，
To make the synthesizer’s job easier, SuFu attempts to reuse as much of the original program as possible, moving subterms that don’t directly operate on Packed data structures out of the holes, into let-bindings. For example, the two invocations of tails in Fig. 1b are moved out, because they do not contain any NList-specific operations.
这一步具体是如何实现的？把里面相对独立的term移出去？产生数据结构的只能是最外层的type是对应的数据结构，消耗数据结构的只能是有一个参数的type是对应的数据结构，如果是内部的term并且type是对应的数据结构 也是可以移出去的？

2. SuFu用了CEGIS框架吗？合成的时候是先产生一些全局的example，并且对应到每个hole的example，然后直接开始了合成？
To make the synthesizer’s job easier, SuFu attempts to reuse as much of the original program as possible, moving subterms that don’t directly operate on Packed data structures out of the holes, into let-bindings. For example, the two invocations of tails in Fig. 1b are moved out, because they do not contain any NList-specific operations.
这里是假设CEGIS框架+一个外部的verifier，可以针对所有错误程序都生成反例，所以保证了正确性。但实际上没有这样的verifier？而只是在有限的一组io example上面验证？

3. For ?compress, while the whole ?compress may be large, the component for generating each scalar attribute is small and can be efficiently enumerated. For the sketch holes, while they cannot always be directly eliminated from the specification, they can be further decomposed into components, where some can be eliminated and some can be efficiently enumerated with ?compress.
没看懂。。。

4. This specification is also unsatisfiable. Intuitively, this is because the mts of the tail, which is 0 in both cases, clearly does not contain enough information to compute the mts of the whole list, which is 2 in the first case and 1 in the second case; and although ?t2 also has access to the input list xs, it cannot compute mts from xs in O (1) time since xs can be arbitrarily long.
这要如何确定无法合成？因为O(1)的程序空间也是无限大的？



### Task 1

在 Part1 Task1 中，我们为程序 `pos-prefix.f` 添加了 `Reframe` 标注并使用了 SuFu 对其进行优化。 

**Q1**: 尝试在这一程序上进一步添加 `rewrite`、`label`、与 `unlabel` 标注，并在 SuFu 的线上 Demo 中测试。注意在测试时，你需要取消 `AutoLabel` 选项以禁用 SuFu 的自动标注功能。
done
没有用到let-binding，需要测试



### Task 2

在 Part1 Task5 中，我们使用 SuFu 优化了 01 背包问题上的一个穷举程序，并得了一个可以在更快的时间内计算最大价值和的程序。

然而，在很多动态规划问题中，我们关心的并不是最优的目标值，而是最优目标值所对应的**方案**。文件 `01knapsack-with-plan.f` 中包含了一个修改后的穷举程序，其中 `getbest` 的返回值被修改为具有最大价值和的放置物品方案。

**Q2.1**: 在默认选项下（即仅勾选 `AutoLabel`）对该程序进行优化。优化是否能成功？如果成功，请比较这次的结果与 Part1 Task5 中的结果有何不同；如果失败，请简单分析原因。
不能成功，RuntimeError？
AutoLabel都可以成功
如果reframe写在Plan的定义中，和最终输出类型不能包含compress冲突。
如果reframe写在PlanList的定义中，因为最终输出是最优方案，所以无论如何压缩Plan，都需要保留ItemList，导致无法压缩成scalar value。但如果勾选AutoLabel，就必须压缩成scalar，导致优化无法成功。


**Q2.2**: 对 `01knapsack-with-plan.f` 进行修改，使得在不改变输出、不改变 SuFu 选项的情况下，SuFu 可以成功地进行优化。在这个过程中，请尽量使重构的规模最小。
auto-label.f:
没有main函数。在Plan上Reframe
源程序先用autolabel的结果，然后AutoLabel=false，scalar=false尝试合成
因为knapsack的输出类型是Plan，这里在Plan上Reframe导致输出类型错误。


opt-5.f:
增加了main函数。在Plan上Reframe
先生成autolabel，然后AutoLabel=false，scalar=false尝试合成
压缩结果：Plan = {ItemList, Int, Int};
合成成功了


opt-3.f:
没有main函数。在PlanList里面的Plan上Reframe。
选项是AutoLabel=true，scalar=true。AutoLabel失败 (opt-6.f)
先用autolabel=true, scalar=false来生成自动标注的结果，然后设置autolabel=false，scalar=false
报错：incre/autolifter/nonscalar/incre_nonscalar_ds_solver.cpp, line123


opt-7.f:
增加了main函数。在PlanList里面的Plan上Reframe
选项是AutoLabel=true，scalar=false。
报错：incre/autolifter/nonscalar/incre_nonscalar_ds_solver.cpp, line123
先用autolabel=true, scalar=false来生成自动标注的结果，然后设置autolabel=false，scalar=false
报错：incre/autolifter/nonscalar/incre_nonscalar_ds_solver.cpp, line123


opt-8.f:
没有main函数。在PlanList里面的Plan和getbest的输出上Reframe
AutoLabel=true，scalar=false。输出类型上有Reframe导致报错？
需要尝试


opt-1.f:
增加了main函数。在PlanList里面的Plan和getbest的输出上Reframe
选项是AutoLabel=true，scalar=false。
一种方法是在最后加一个main函数，计算最优方案的sumv。因为整个程序START的输出不能是和compress相关的？加了main之后就可以给Plan加上compress，并且能够正确优化。
优化结果是 ItemList -> {ItemList, sumv, sumw}。原本每种方案都需要到最后单独计算sumw和sumv，现在是在枚举的过程中就计算上了，所以时间复杂度从 $O(2^n * n)$ 优化到了 $O(2^n)$ ？
这里的一个问题是，最终保证了main函数的输入输出在优化前后保持不变（都返回最优解的sumv），但knapsack函数的输出改变了（原本返回的是最优解对应的ItemList，现在变成了{ItemList, sumw, sumv}，因为knapsack原本的类型就是通过自动推导得到的，所以并没有保持一直是 Int -> ItemList -> Plan？


opt-2.f:
增加了main函数。在PlanList里面的Plan和getbest的输出上Reframe
选项是AutoLabel=true，scalar=true。
把Plan压缩成了{Int, Int}，和之前的01knapsack结果一样了。


opt-4.f:
修改了程序，在gen的过程中删除 sumw > lim 的方案
先用autolabel=true, scalar=false来生成自动标注的结果，然后设置autolabel=false，scalar=true
报错：incre/autolifter/nonscalar/incre_nonscalar_ds_solver.cpp, line123



主要问题：
不改变输出，说明最终需要输出最优方案的ItemList，所以不可能把Plan压缩到scalar；不改变SuFu选项说明只能AutoLabel+scalar。这就产生了矛盾？


**Q2.3***: 在 **Q2.2** 中你作出的手动修改是可以被自动化的吗？
如果是单纯自动增加一个main函数，把原本的non-scalar输出转成scalar输出，并且尽量保证不同的non-scalar结果对应到不同的scalar输出，应该不复杂？比如输出为List就计算sum？


### Task 3

阅读 SuFu 主页中的 Example 1: Rewrite using programs with non-scalar outputs 小节。

**Q3.1**: 为 `01knapsack-with-plan.f` 添加合适的 `rewrite`、`label`、与 `unlabel` 标注，并使用 SuFu 的 `NonScalar` 选项对其进行优化。

a-label.f:
没有main函数，先用autolabel，然后autolabel=false, scalar=false。
输出类型Plan有Reframe，合成肯定不能成功


opt-1-label.f:
来自于part2-task2-opt-5.f
之前是先生成autolabel，然后AutoLabel=false，scalar=false尝试合成
如果直接AutoLabel=true，scalar=false，也可以成功合成




**Q3.2**: 回忆 SuFu 论文第 3 章中关于标注生成的描述。为什么这个标注生成算法与选项 `NonScalar` 无法兼容？
自动标注算法中feasible的实现方式是rewrite返回的如果是一个数据结构，必须是有Packed标记的数据结构，否则如果返回一个不被压缩的数据结构，但实际上改写整个hole之后，并不能保留原有数据结构的所有信息，导致程序出错。
但如果用nonscalar选项，中间数据结构可能被压缩成另一种中间数据结构，在标记的时候没必要增加这一条要求？rewrite也可以返回没有Packed标记的中间数据结构？


**Q3.3***: 能否扩展标注生成算法以解决 **Q3.2** 中的兼容性问题？


### Task 4

考虑一个简单的优化问题：给定一个 01 串，你需要从中选择一个子序列，满足子序列中不存在任何两个相邻的 1 ，并最大化子序列的长度。尽管这个问题可以用贪心的方法解决，在这里，让我们尝试将 Part1 Task5 中关于动态规划的处理方法应用过来。

**Q4.1**: 文件 `11-free-subsequence` 中包含着这个问题的一个穷举程序。请尝试为其添加合适的 `Reframe` 标注，使得 SuFu 能像 Part1 Task5 中那样，对该程序中的方案进行压缩。这个可以做到吗？如果你的答案是可以做到，则跳过这一任务中余下的三个问题。

**Q4.2**: 选择你觉得最合理的标注方式，对照 SuFu 论文第三章的标注算法，尝试还原 SuFu 的标注过程，并分析为什么 SuFu 无法产生满意的标注。

**Q4.3**: 请手动为穷举添加所有标注（即 `Reframe`, `label`, `unlabel`, 和 `rewrite`），使得 SuFu 可以在取消勾选 `AutoLabel` 的情况下完成优化。在这个过程中，你可以对穷举程序进行重构，但请尽量使重构的规模最小。

**Q4.4***: 对比 **Q4.3** 中你的手动标注与 SuFu 的标注算法，能否扩展标注生成算法使得 SuFu 能够自动产生你得到的手动标注？

### Task 5

这是一道最近的 [Coedeforces 比赛题](https://codeforces.com/contest/1937/problem/B)。 文件 `1937B.cpp` 中是这道题上用 C++ 编写的一个暴力程序（为了方便，此处省略原题中的多组数据并只输出方案数），其时间复杂度是 $O(n^2)$ 的。

**Q5.1**: 尝试将 `1937B.cpp` 翻译到 SuFu 的语言，并用 SuFu 将其优化到线性时间。为了方便，我在 `1937B.f` 中给出了一些基本数据结构和函数的定义。
翻译done
opt-1来自1937B，递归方式好像不太对
opt-2来自1937B-2，但报错
I0304 21:46:25.245357 120753 incre_instru_runtime.cpp:580] Start generate 9.99999
terminate called after throwing an instance of 'SemanticsError'
  what():  std::exception
terminate called recursively
已放弃 (核心已转储)

**Q5.2***: 上述翻译过程的难点是什么？这个翻译可以做到自动化吗？

**Q5.3***: 考虑如果不进行翻译，而是直接把 SuFu 的算法迁移到 C++，那么 SuFu 算法中的哪些部分是可以直接迁移的，哪些部分又会出现问题？你有什么解决这些问题的想法吗？

