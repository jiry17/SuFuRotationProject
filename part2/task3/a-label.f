Config SampleSize = 4; /* Limit the time cost of running on random examples */

Item = {Int, Int};
Inductive ItemList = cons {Item, ItemList} | nil Unit;
Plan = Reframe ItemList;
Inductive PlanList = consPlan {Plan, PlanList} | nilPlan Unit;

max = \x: Int. \y: Int. if (< x y) then y else x;

/* A trivial program for 01knapsack */

step = \i: Item. fix (\f: PlanList -> PlanList. \ps: PlanList.
  match ps with
    consPlan {p, t} ->
      let res = f t in rewrite (consPlan {label (cons {i, (unlabel p)}), consPlan {p, res}})
  | nilPlan _ -> ps
  end
);

gen = fix (
  \f: ItemList -> PlanList. \items: ItemList.
  match items with
    cons {i, t} ->
      let res = f t in step i res
  | nil _ -> rewrite (consPlan {label (nil unit), nilPlan unit})
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
  \f: PlanList -> Plan. \ps: PlanList.
  match ps with
    consPlan {p, t} ->
      let res = f t in 
      let tmp1 = rewrite (< lim (sumw (unlabel p))) in
      let tmp4 = rewrite (sumv (unlabel p)) in
      let tmp5 = rewrite (sumv (unlabel res)) in
      let tmp2 = (< tmp4 tmp5) in
      let tmp3 = or tmp1 tmp2 in
      if tmp3 then res else p
  | nilPlan _ -> rewrite (label (nil unit))
  end
);

knapsack = \w: Int. \is: ItemList. getbest w (gen is);

