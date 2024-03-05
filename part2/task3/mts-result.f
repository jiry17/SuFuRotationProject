Inductive List = nil Unit | cons {Int, List};

Inductive NList = nnil Unit | ncons {List, NList};

sum = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 0
    | cons {h, t} -> + h (f t)
    end
);

map = \g: List -> Int. 
    fix (
    \f: NList -> List. \xs: NList. 
    match xs with
      nnil _ -> nil unit
    | ncons {h, t} -> cons {g h, f t}
    end
);

maximum = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 0
    | cons {h, t} -> 
        let res = (f t) in 
            if (> res h) then res
            else h
    end
);

tails = fix (
    \f: List -> List. \xs: List. 
    match xs with
      nil _ -> xs
    | cons {h, t} -> 
        let tres = (f t) in 
            match tres with
              cons tres@0 -> cons {+ h tres@0.1, tres}
            | nil tres@0 -> xs
            end
    end
);

mts = \xs: List. 
    let ts = (tails xs) in 
        maximum ts;