Item = {Int, Int};

Inductive ItemList = cons {Item, ItemList} | nil Unit;

Plan = ItemList;

Inductive PlanList = consPlan {{ItemList, Int, Int}, PlanList} | nilPlan Unit;

max = \x: Int. \y: Int. 
    if (< x y) then y
    else x;

step = \i: Item. 
    fix (
    \f: PlanList -> PlanList. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            consPlan {let tmp1 = (cons {{i.1, i.2}, p.1}) in 
                {tmp1, + i.2 p.2, + i.1 p.3}, consPlan {p, res}}
    | nilPlan _ -> ps
    end
);

gen = fix (
    \f: ItemList -> PlanList. \items: ItemList. 
    match items with
      cons {i, t} -> 
        let res = (f t) in 
            step i res
    | nil _ -> consPlan {let tmp2 = (nil unit) in 
            {tmp2, 0, 0}, nilPlan unit}
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
    \f: PlanList -> {ItemList, Int, Int}. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            if (or (< lim p.3) (< p.2 res.2)) then res
            else p
    | nilPlan _ -> 
        let tmp3 = (nil unit) in 
            {tmp3, 0, 0}
    end
);

knapsack = \w: Int. \is: ItemList. 
    getbest w (gen is);

main = \w: Int. \is: ItemList. 
    let tmp4 = (knapsack w is) in 
        tmp4.2;