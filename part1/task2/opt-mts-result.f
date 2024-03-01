Inductive List = nil Unit | cons {Int, List};

run = fix (
    \f: List -> {Int, Int}. \xs: List. 
    match xs with
      nil _ -> 
        {0, 0}
    | cons {h, t} -> 
        let tmp2 = (f t) in 
            {if (< (+ h tmp2.2) tmp2.1) then tmp2.1
            else + h tmp2.2, + h tmp2.2}
    end
);

single_pass = \g: List -> Int. \xs: List. 
    let tmp3 = (run xs) in 
        tmp3.1;

max = \x: Int. \y: Int. 
    if (< x y) then y
    else x;

tmp = fix (
    \f: List -> {Int, Int}. \xs: List. 
    match xs with
      nil _ -> {0, 0}
    | cons {h, t} -> 
        let tmp2 = (f t) in 
            {max tmp2.1 (+ h tmp2.2), + h tmp2.2}
    end
);

mts = \xs: List. 
    let tmp3 = (tmp xs) in 
        tmp3.1;

main = \xs: List. 
    single_pass mts xs;
