Item = {Int, Int};

Inductive ItemList = cons {Item, ItemList} | nil Unit;

Plan = ItemList;

Inductive PlanList = consPlan {Reframe Plan, PlanList} | nilPlan Unit;

max = \x: Int. \y: Int. 
    if (< x y) then y
    else x;

step = \i: Item. 
    fix (
    \f: PlanList -> PlanList. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            consPlan {let tmp1 = (cons (rewrite  {i, unlabel p } )) in 
                rewrite  (label tmp1 ) , consPlan {p, res}}
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
            rewrite  (label tmp2 ) , nilPlan unit}
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
    \f: PlanList -> Plan. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            let tmp3 = (or (< lim (rewrite  (sumw (unlabel p )) )) (< (rewrite  (sumv (unlabel p )) ) (sumv res))) in 
                rewrite  (if (tmp3) then res
                else unlabel p ) 
    | nilPlan _ -> nil unit
    end
);

knapsack = \w: Int. \is: ItemList. 
    getbest w (gen is);