# Part1

### Task0

请阅读 [SuFu 主页](http://8.140.207.65/) 中的第三节 Example: Maximum Suffix Sum，并在线上 Demo 中运行例子 Mts。

如果出现了网站崩溃、无法连接的情况，请随时与负责的同学联系。

### Task1

考虑如下编程任务：给定一个整数列表，计算其有多少个和大于零的前缀。举例来说，列表 [3, -1, -2, 4] 上的期望输出是 3，其中满足要求的前缀分别是 [3], [3, -1], 和 [3, -1, -2, 4]。

**Q1.1**:  `pos-prefix.f` 是该问题的一个参考程序。请使用线上 Demo 的 Test Case 框测试该程序在上述列表上的输出是否是 3。
done

**Q1.2**: 这一参考程序的时间复杂度是什么？其瓶颈在哪里？
时间复杂度：$O(n^2)$
瓶颈在于 prefixes/append 和 sum 函数。首先 prefixes 中生成所有前缀，每次都要掉用 append 函数将当前元素加到上一个前缀的最后，这一步的时间复杂度正比于该前缀的长度，导致 prefixes 整体的时间复杂度是 $O(n^2)$。其次，sum函数中，需要遍历每一个前缀进行求和，时间复杂度也是 $O(n^2)$。

**Q1.3**: 请尝试对该程序中的中间数据结构进行标注，使得 SuFu 能将其优化为一个**线性时间**的程序。标注方式是否唯一？SuFu 是否总能得到相同的程序？
prefix: List -> List -> NList

opt-1.f
动机是只保留prefix，其他函数全部丢掉，并且把prefix优化成线性时间复杂度
label prefix: Reframe List -> List -> Reframe NList
result prefix: Int -> List -> Int
优化成 $O(n)$ 复杂度的程序，递归计算前缀和并作为参数往下传递，返回值就是当前大于零的前缀数量。

opt-2.f
动机是把append优化成线性时间复杂度
label append: Reframe List -> Reframe List
result append: Int -> Int
label prefix: Reframe List -> List -> Reframe NList
result prefix: Int -> List -> Int
最终程序的思路和opt-1是基本一样的，只是opt-1中的加法是额外合成的，这里是从append函数修改而来

opt-3.f
动机是优化sum，但如果要标记sum，就肯定要标记map，但所有标记的数据结构都要压缩成scalar value，而map不行，所以不太可行？


### Task2

单次遍历 (single-pass) 算法是一种常见的算法设计模式。给定数据结构，单次遍历算法会按照其结构遍历每个元素至多一次，并同时计算出预期的结果。

**Q2.1**: `single-pass-for-list.f` 是一个模板程序。在给定函数 `f` 和列表 `xs` 的情况下，`single_pass f xs` 的结果和时间复杂度分别是什么？它和单次遍历算法的联系是什么？
结果：在 xs 上 apply f
时间复杂度：如果 f 的时间复杂度是 m，就是 $O(n) + m$
和单次遍历的区别是这里先用 run 函数遍历了一遍，然后再 apply f？

**Q2.2**: 请适当地标注 `single-pass-for-list.f` 中的数据结构，使得 SuFu 会尝试将 `single_pass f` 优化成一个线性时间的单次遍历算法。使用列表和函数 `sum` 和 Task0 中涉及的最大后缀和函数 `mts` 测试你的标注结果。
源程序是run遍历一遍但是什么都不做，然后在List上应用g函数。如果只是原本的run和single_pass函数，好像没法直接把无意义的run优化掉？
在single_pass上传入sum函数，然后在run的类型改为 List -> Reframe List，结果是run完成了sum的工作。
在single_pass上传入mts函数，然后在run的类型改为 List -> Reframe List，结果是run完成了mts的工作。

==这里的问题是，如果不给single_pass传入一个函数，就不可能直接把run函数给优化掉？==


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
done

**Q3.2**: 使用列表和函数 `sum` 和 Task 1 中的参考程序测试你的模板。
done
类似2.2，不过是在 snoc_to_list（转换函数）而非 snoc_rec 实现递归的部分，sum和mts在结果中没有被直接用到。
不过在SnocList上计算mts，就类似于从前往后扫一遍，和大于零就继续保留，否则就清零，一路加到最后。


### Task 4 

让我们来看一些更加复杂的算法。滑动窗口算法 (sliding-windows) 是一种用于求解最长子段问题的算法。给定一个 `List->Bool` 的函数 `p` 和数组 `xs`，滑动窗口算法的目标是在线性时间内计算出 `xs` 内最长的满足 `p` 的区间。关于该算法的介绍可以参考[这篇博客](https://blog.csdn.net/V_zjs/article/details/132795860).

**Q4.1**: 文件 `sliding-window.f` 中包含了一个滑动窗口算法的模板程序。请适当地标注其中的数据结构，使得在给定函数 `p` 的情况下，SuFu 会尝试将 `sliding_window p` 优化成一个线性时间的滑动窗口算法。 

**Q4.2**: 文件 `positive.f` 包含了一个函数 `positive`，它接受所有仅包含正整数的列表。使用这个函数测试你的标注结果。
sliding_window函数本质是以滑动窗口这个算法的形式遍历了List，第一个参数对应l的位置，第二个参数对应r的位置，第三个参数表示当前窗口的result，第四个参数表示当前的最优结果。所以后两个都可以压缩成Int。
最终结果就在递归遍历的过程中，加上计算结果的过程。


### Task 5 

01 背包问题是一个经典的动态规划问题，其定义可以参考[这篇文章](https://www.geeksforgeeks.org/0-1-knapsack-problem-dp-10/)。在线上 demo 中有一个内置的例子 0/1Knapsack。该例子中的参考程序是对 01 背包问题的一个穷举程序。给定 $n$ 个物品，该程序会产生 $2^n$ 种将物品放进背包的方案，并在所有不超过重量限制的方案中，选择价值和最大的程序。

**Q5.1**: 运行这个例子并在参考程序与优化结果之间进行比较，尝试回答以下问题。SuFu 做了什么优化？结果程序的时间复杂度是什么？结果程序和动态规划算法的联系是什么？
优化：将Plan从ItemList压缩成{w, v}
时间复杂度：原本是 $O(2^n * n)$ 优化到了 $O(2^n)$
联系是都用 {w, v} 压缩一个 Plan，区别是动态规划在每一步会进一步压缩子问题的解，而这里是先把所有可能的解全部列出来，最后再用 getbest 计算。

**Q5.2**: 尝试仿照这个例子，编写一个[最长上升子序列问题](https://www.geeksforgeeks.org/longest-increasing-subsequence-dp-3/)的穷举程序，并使用 SuFu 进行优化。
标记方法类似于01knapsack，原本是暴力枚举所有子序列，然后计算结果。把所有子序列压缩成{length, last}这样的形式其实就可以了。length表示子序列长度，last表示子序列最后一个元素的值
最终结果压缩成了{Bool, Int, Int}，Bool表示当前子序列是否为上升子序列。
但其实可以进一步压缩？因为如果当前子序列不是上升子序列，那么这个部分解就可以直接丢掉了。


### Task 6

最后，让我们尝试一道竞赛真题。`building-block.pdf` 中展示的是 NOIP2013 提高组的一道真题，`building-black.f` 中是对应的穷举程序。

**Q6.1**: 请根据之前 5 个任务的经验，尝试使用 SuFu 将其优化为一个线性时间的程序。


### 一些问题
1. 需要已经有一个递归结构
也许可以写一个库，放进去所有常见的递归结构。即使现在的程序里没有递归结构，也可以直接调用，然后在递归结构上实现优化。
2. 需要大致知道最后如何实现，才能正确标记Reframe
标第一个遇到的中间数据结构（mts）那么后面的中间数据结构就不会创建了。
或者有一些类型依赖，那么一般就都要标上。
3. 如何丢掉更多的部分解？例如背包/lis问题，优化结果是把所有Plan列出来，然后再计算结果，虽然Plan的表示本身压缩了，但Plan的数量并未减少，依然是指数大小。但是如果用动态规划，可以变成二次大小？
确实没有压缩成动态规划

