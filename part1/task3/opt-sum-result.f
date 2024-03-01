Inductive List = nil Unit | cons {Int, List};

Inductive SnocList = lin Unit | snoc {SnocList, Int};

snoc_for_cons = \w: Int. 
    fix (
    \f: List -> List. \xs: List. 
    match xs with
      nil _ -> cons {w, nil unit}
    | cons {h, t} -> cons {h, f t}
    end
);

cons_for_snoc = \w: Int. 
    fix (
    \f: SnocList -> SnocList. \xs: SnocList. 
    match xs with
      lin _ -> snoc {lin unit, w}
    | snoc {t, h} -> snoc {f t, h}
    end
);

list_to_snoc = fix (
    \f: List -> SnocList. \xs: List. 
    match xs with
      nil _ -> lin unit
    | cons {h, t} -> cons_for_snoc h (f t)
    end
);

snoc_to_list = fix (
    \f: SnocList -> Int. \xs: SnocList. 
    match xs with
      lin _ -> 
        0
    | snoc {t, h} -> 
        let tmp3 = (f t) in 
            + h tmp3
    end
);

snoc_rec = \f: List -> Int. \xs: SnocList. 
    let tmp4 = (snoc_to_list xs) in 
        tmp4;

sum = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 0
    | cons {h, t} -> + h (f t)
    end
);

main = \xs: SnocList. 
    snoc_rec sum xs;
