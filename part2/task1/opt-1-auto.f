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
    \f: Reframe List -> List -> Reframe NList. \prefix: Reframe List. \xs: List. 
    match xs with
      nil _ -> 
        let tmp1 = (nnil unit) in 
            rewrite  (label (ncons {unlabel prefix , tmp1}) ) 
    | cons {h, t} -> 
        let tmp3 = (f (let tmp2 = (append h) in 
            rewrite  (label (tmp2 (unlabel prefix )) ) ) t) in 
            rewrite  (label (ncons {unlabel prefix , unlabel tmp3 }) ) 
    end
) (let tmp4 = (nil unit) in 
        rewrite  (label tmp4 ) );

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
    let tmp5 = (filter is_pos) in 
        let tmp6 = (map sum) in 
            let tmp7 = (prefixes xs) in 
                rewrite  (length (tmp5 (tmp6 (unlabel tmp7 )))) ;