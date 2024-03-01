Inductive List = nil Unit | cons {Int, List};

Inductive NList = nnil Unit | ncons {List, NList};

append = \w: Int. 
    fix (
    \f: List -> List. \xs: List. 
    match xs with
      nil _ -> cons {w, nil unit}
    | cons {h, t} -> cons {h, f t}
    end
);

prefixes = fix (
    \f: Int -> List -> Int. \prefix: Int. \xs: List. 
    match xs with
      nil _ -> 
        if (< 0 prefix) then 1
        else 0
    | cons {h, t} -> 
        let tmp3 = (f (+ prefix h) t) in 
            if (< prefix 1) then tmp3
            else + 1 tmp3
    end
) (0);

sum = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 0
    | cons {h, t} -> + h (f t)
    end
);

map = \op: List -> Int. 
    fix (
    \f: NList -> List. \xs: NList. 
    match xs with
      nnil _ -> nil unit
    | ncons {h, t} -> cons {op h, f t}
    end
);

filter = \op: Int -> Bool. 
    fix (
    \f: List -> List. \xs: List. 
    match xs with
      nil _ -> xs
    | cons {h, t} -> if (op h) then cons {h, f t}
        else f t
    end
);

is_pos = \w: Int. 
    > w 0;

length = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 0
    | cons {h, t} -> + 1 (f t)
    end
);

main = \xs: List. 
    let tmp7 = (prefixes xs) in 
        tmp7;
