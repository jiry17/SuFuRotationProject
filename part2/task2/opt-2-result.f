Item = {Int, Int};

Inductive ItemList = cons {Item, ItemList} | nil Unit;

Plan = ItemList;

Inductive PlanList = consPlan {{Int, Int}, PlanList} | nilPlan Unit;

max = \x: Int. \y: Int. 
    if (< x y) then y
    else x;

step = \i: Item. 
    fix (
    \f: PlanList -> PlanList. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            consPlan {let c0 = i.1 in 
                let c1 = i.2 in 
                    {+ p.1 c0, + p.2 c1}, consPlan {p, res}}
    | nilPlan _ -> ps
    end
);

gen = fix (
    \f: ItemList -> PlanList. \items: ItemList. 
    match items with
      cons {i, t} -> 
        let res = (f t) in 
            step i res
    | nil _ -> consPlan {{0, 0}, nilPlan unit}
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

getbest = \lim: Int. 
    fix (
    \f: PlanList -> {Int, Int}. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            if (or (< lim p.1) (< p.2 res.2)) then res
            else p
    | nilPlan _ -> {0, 0}
    end
);

knapsack = \w: Int. \is: ItemList. 
    getbest w (gen is);

main = \w: Int. \is: ItemList. 
    let tmp3 = (knapsack w is) in 
        tmp3.2;