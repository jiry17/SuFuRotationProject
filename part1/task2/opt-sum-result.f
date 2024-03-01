Inductive List = nil Unit | cons {Int, List};

run = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 
        0
    | cons {h, t} -> 
        let tmp2 = (f t) in 
            + h tmp2
    end
);

single_pass = \g: List -> Int. \xs: List. 
    let tmp3 = (run xs) in 
        tmp3;

sum = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 0
    | cons {h, t} -> + h (f t)
    end
);

main = \xs: List. 
    single_pass sum xs;
