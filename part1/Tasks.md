# Part1

### Task0

请阅读 [SuFu 主页](http://8.140.207.65/) 中的第三节 Example: Maximum Suffix Sum，并在线上 Demo 中运行例子 Mts。

注意：目前 SuFu 的接口语言使用了 lambda 演算及其变种中的一些概念（例如 lambda 表达式和 fix 操作符）。如果你对这些概念感到陌生，可以参考北京大学的课程[编程语言的设计原理](https://pku-dppl.github.io/2023/lectures.html)（特别是课件 The Untyped Lambda Calculus 和 Simply Typed Lambda-Calculus）.

如果出现了网站崩溃、无法连接的情况，请随时与负责的同学联系。

### Task1

考虑如下编程任务：给定一个整数列表，计算其有多少个和大于零的前缀。举例来说，列表 [3, -1, -2, 4] 上的期望输出是 3，其中满足要求的前缀分别是 [3], [3, -1], 和 [3, -1, -2, 4]。

**Q1.1**:  `pos-prefix.f` 是该问题的一个参考程序。请使用线上 Demo 的 Test Case 框测试该程序在上述列表上的输出是否是 3。

**Q1.2**: 这一参考程序的时间复杂度是什么？其瓶颈在哪里？

**Q1.3**: 请尝试对该程序中的中间数据结构进行标注，使得 SuFu 能将其优化为一个**线性时间**的程序。标注方式是否唯一？SuFu 是否总能得到相同的程序？

### Task2

单次遍历 (single-pass) 算法是一种常见的算法设计模式。给定数据结构，单次遍历算法会按照其结构遍历每个元素至多一次，并同时计算出预期的结果。

**Q2.1**: `single-pass-for-list.f` 是一个模板程序。在给定函数 `f` 和列表 `xs` 的情况下，`single_pass f xs` 的结果和时间复杂度分别是什么？它和单次遍历算法的联系是什么？

**Q2.2**: 请适当地标注 `single-pass-for-list.f` 中的数据结构，使得 SuFu 会尝试将 `single_pass f` 优化成一个线性时间的单次遍历算法。使用列表和函数 `sum` 和 Task0 中涉及的最大后缀和函数 `mts` 测试你的标注结果。

### Task3

在前几个任务中，我们使用了列表的如下定义：

```
Inductive List = nil Unit | cons {Int, List};
```

该定义下的列表按照从左到右的顺序给出了列表中的每一个元素。

自然地，列表也可以被定义成从右到左给出列表的形式，如下所示：

```
Inductive SnocList = lin Unit | snoc {SnocList, Int};
```

程序 `list_convert.f` 中给出了在 `List` 与 `SnocList` 之间互相转化的函数。

**Q3.1**:  请仿照 Task 2 中的模板程序，在 `list_convert.f` 的基础上编写一个模板程序 `snoc_rec`，使得给定任何 `List->Int` 的函数 `f`，SuFu 都会尝试将 `snoc_rec f` 重写成一个 `SnocList` 的递归函数。

**Q3.2**: 使用列表和函数 `sum` 和 Task 1 中的参考程序测试你的模板。

### Task 4 

让我们来看一些更加复杂的算法。滑动窗口算法 (sliding-windows) 是一种用于求解最长子段问题的算法。给定一个 `List->Bool` 的函数 `p` 和数组 `xs`，滑动窗口算法的目标是在线性时间内计算出 `xs` 内最长的满足 `p` 的区间。关于该算法的介绍可以参考[这篇博客](https://blog.csdn.net/V_zjs/article/details/132795860).

**Q4.1**: 文件 `sliding-wondow.f` 中包含了一个滑动窗口算法的模板程序。请适当地标注其中的数据结构，使得在给定函数 `p` 的情况下，SuFu 会尝试将 `sliding_window p` 优化成一个线性时间的滑动窗口算法。 

**Q4.2**: 文件 `positive.f` 包含了一个函数 `positive`，它接受所有仅包含正整数的列表。使用这个函数测试你的标注结果。

### Task 5 

01 背包问题是一个经典的动态规划问题，其定义可以参考[这篇文章](https://www.geeksforgeeks.org/0-1-knapsack-problem-dp-10/)。在线上 demo 中有一个内置的例子 0/1Knapsack。该例子中的参考程序是对 01 背包问题的一个穷举程序。给定 $n$ 个物品，该程序会产生 $2^n$ 种将物品放进背包的方案，并在所有不超过重量限制的方案中，计算可以达到的最大价值和。

**Q5.1**: 运行这个例子并在参考程序与优化结果之间进行比较，尝试回答以下问题。SuFu 做了什么优化？结果程序的时间复杂度是什么？结果程序和动态规划算法的联系是什么？

**Q5.2**: 尝试仿照这个例子，编写一个[最长上升子序列问题](https://www.geeksforgeeks.org/longest-increasing-subsequence-dp-3/)的穷举程序，并使用 SuFu 进行优化。

### Task 6

最后，让我们尝试一道竞赛真题。`building-block.pdf` 中展示的是 NOIP2013 提高组的一道真题，`building-block.f` 中是对应的穷举程序。

请根据前 5 个任务的经验，回答如下两个问题。

**Q6.1**: 简单简要阅读穷举程序 `building-block.f`，并在上手优化前回答：是否有可能通过消除该程序中原有的中间数据结构，将其优化成为一个线性时间的程序。

**Q6.2**: 尝试使用 SuFu 将穷举程序优化成为线性时间的高效程序。