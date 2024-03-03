Config SampleSize = 4; /* Limit the time cost of running on random examples */

Item = {Int, Int};
Inductive ItemList = cons {Item, ItemList} | nil Unit;
Plan = ItemList;
Inductive PlanList = consPlan {Reframe Plan, PlanList} | nilPlan Unit;

max = \x: Int. \y: Int. if (< x y) then y else x;

/* A trivial program for 01knapsack */

step = \i: Item. fix (\f: PlanList -> PlanList. \ps: PlanList.
  match ps with
    consPlan {p, t} ->
      let res = f t in consPlan {cons {i, p}, consPlan {p, res}}
  | nilPlan _ -> ps
  end
);

gen = fix (
  \f: ItemList -> PlanList. \items: ItemList.
  match items with
    cons {i, t} ->
      let res = f t in step i res
  | nil _ -> consPlan {nil unit, nilPlan unit}
  end
);

sumw = fix (
  \f: ItemList -> Int. \xs: ItemList.
  match xs with
    nil _ -> 0
  | cons {h, t} -> + h.1 (f t)
  end
);

sumv = fix (
  \f: ItemList -> Int. \xs: ItemList.
  match xs with
    nil _ -> 0
  | cons {h, t} -> + h.2 (f t)
  end
);

getbest = \lim: Int. fix (
  \f: PlanList -> Reframe Plan. \ps: PlanList.
  match ps with
    consPlan {p, t} ->
      let res = f t in 
      if or (< lim (sumw p)) (< (sumv p) (sumv res)) then res else p
  | nilPlan _ -> nil unit
  end
);

knapsack = \w: Int. \is: ItemList. getbest w (gen is);

main = \w: Int. \is: ItemList. sumv (knapsack w is);