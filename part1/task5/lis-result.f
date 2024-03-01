Inductive List = cons {Int, List} | nil Unit;

Inductive NList = ncons {{Bool, Int, Int}, NList} | nnil Unit;

max = \x: Int. \y: Int. 
    if (< x y) then y
    else x;

step = \i: Int. 
    fix (
    \f: NList -> NList. \ps: NList. 
    match ps with
      ncons {p, t} -> 
        let res = (f t) in 
            ncons {{or (and (< i p.3) p.1) (== p.2 0), + 1 p.2, i}, ncons {p, res}}
    | nnil _ -> ps
    end
);

gen = fix (
    \f: List -> NList. \items: List. 
    match items with
      cons {i, t} -> 
        let res = (f t) in 
            step i res
    | nil _ -> ncons {{true, 0, 0}, nnil unit}
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
      nnil _ -> 0
    | ncons {h, t} -> if (h.1) then max (h.2) (f t)
        else f t
    end
);

lis = \is: List. 
    getbest (gen is);
