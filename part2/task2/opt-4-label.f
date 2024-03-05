Item = {Int, Int};

Inductive ItemList = cons {Item, ItemList} | nil Unit;

Plan = ItemList;

Inductive PlanList = consPlan {Reframe Plan, PlanList} | nilPlan Unit;

max = \x: Int. \y: Int. 
    if (< x y) then y
    else x;

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

step = \i: Item. \lim: Int. 
    fix (
    \f: PlanList -> PlanList. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            if (< lim (sumw (cons (rewrite  {i, unlabel p } )))) then consPlan {p, res}
            else consPlan {let tmp1 = (cons (rewrite  {i, unlabel p } )) in 
                rewrite  (label tmp1 ) , consPlan {p, res}}
    | nilPlan _ -> ps
    end
);

gen = \lim: Int. 
    fix (
    \f: ItemList -> PlanList. \items: ItemList. 
    match items with
      cons {i, t} -> 
        let res = (f t) in 
            step i lim res
    | nil _ -> consPlan {let tmp2 = (nil unit) in 
            rewrite  (label tmp2 ) , nilPlan unit}
    end
);

getbest = fix (
    \f: PlanList -> Plan. \ps: PlanList. 
    match ps with
      consPlan {p, t} -> 
        let res = (f t) in 
            let tmp3 = (< (rewrite  (sumv (unlabel p )) ) (sumv res)) in 
                rewrite  (if (tmp3) then res
                else unlabel p ) 
    | nilPlan _ -> nil unit
    end
);

knapsack = \w: Int. \is: ItemList. 
    getbest (gen w is);