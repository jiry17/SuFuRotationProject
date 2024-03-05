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
  \f: List -> Reframe NList. \xs: List.
  match xs with
    nil _ -> rewrite (label (nnil unit))
  | cons {h, t} -> 
    let tres = f t in
    rewrite (label (ncons {xs, unlabel tres}))
  end
);

mts = \xs: List. let ts = tails xs in
  maximum (rewrite (map sum (unlabel ts)));