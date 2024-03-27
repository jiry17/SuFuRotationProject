Config SampleIntMin = 0;
Config SampleIntMax = 1;

Inductive List = cons {Int, List} | nil Unit;
Inductive PlanList = consPlan {List, PlanList} | nilPlan Unit;

max = \x: Int. \y: Int. if (< x y) then y else x;

length = fix (
  \f: List -> Int. \xs: List.
  match xs with
    nil _ -> 0
  | cons {h, t} -> + 1 (f t)
  end 
);

step_each = \i: Int. \xs: List.
  match xs with
    nil _ -> consPlan {cons {i, nil unit}, consPlan {nil unit, nilPlan unit}}
  | cons {h, t} ->
    if and (== i 1) (== h 1) then consPlan {xs, nilPlan unit}
    else consPlan {cons {i, xs}, consPlan {xs, nilPlan unit}}
  end;

cat = fix (
  \f: PlanList -> PlanList -> PlanList. \xs: PlanList. \ys: PlanList.
  match xs with
    consPlan {h, t} -> consPlan {h, f t ys}
  | nilPlan _ -> ys
  end
);

step = \i: Int. fix (
  \f: PlanList -> PlanList. \xs: PlanList.
  match xs with
    nilPlan _ -> nilPlan unit
  | consPlan {h, t} -> cat (step_each i h) (f t)
  end
);

gen = fix (
  \f: List -> PlanList. \items: List.
  match items with
    cons {i, t} ->
      let res = f t in step i res
  | nil _ -> consPlan {nil unit, nilPlan unit}
  end
);

getbest = fix (
  \f: PlanList -> Int. \ps: PlanList.
  match ps with
    consPlan {p, t} -> max (length p) (f t)
  | nilPlan _ -> 0
  end
);

main = \is: List. getbest (gen is);