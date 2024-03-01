Inductive List = cons {Int, List} | nil Unit;
Inductive NList = ncons {List, NList} | nnil Unit;

max = \x: Int. \y: Int. if (< x y) then y else x;

step = \i: Int. fix (\f: NList -> NList. \ps: List.
  match ps with
    consPlan {p, t} ->
      let res = f t in ncons {cons {i, p}, ncons {p, res}}
  | nilPlan _ -> ps
  end
);

gen = fix (
  \f: List -> NList. \items: List.
  match items with
    cons {i, t} ->
      let res = f t in step i res
  | nil _ -> ncons {nil unit, nnil unit}
  end
);

length = fix (
    \f: List -> Int. \xs: List.
    match xs with
      nil _ -> 0
    | cons {_, t} -> + 1 (f t)
    end
);

is_increase = fix (
    \f: Int -> List -> Bool. \prefix: Int. \xs: List.
    match xs with
      nil _ -> true
    | cons {h, t} -> and (< prefix h) (f h t)
    end
);

getbest = fix (
    \f: NList -> Int. \xs: NList.
    match xs with
      nil _ -> 0
    | cons {h, t} -> if is_increase -100 h then max (length h) (f t) else f t
    end
);

knapsack = \is: List. getbest (gen is);