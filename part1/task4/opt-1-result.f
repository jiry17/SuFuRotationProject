Inductive List = cons {Int, List} | nil Unit;

append = \w: Int. 
    fix (
    \f: List -> List. \xs: List. 
    match xs with
      nil _ -> cons {w, nil unit}
    | cons {h, t} -> cons {h, f t}
    end
);

length = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 0
    | cons {h, t} -> + 1 (f t)
    end
);

is_empty = \xs: List. 
    match xs with
      nil _ -> true
    | _ -> false
    end
;

tail = \xs: List. 
    match xs with
      nil _ -> xs
    | cons {h, t} -> t
    end
;

max = \a: Int. \b: Int. 
    if (< a b) then b
    else a;

ref = \valid: List -> Bool. 
    let tail_res = (fix (
    \f: List -> Int. \xs: List. 
    match xs with
      nil _ -> 0
    | cons {h, t} -> max (f t) (if (valid xs) then length xs
        else 0)
    end
)) in 
        let run = (fix (
        \f: List -> List -> Int. \xs: List. \prefix: List. 
        match xs with
          nil _ -> tail_res prefix
        | cons {h, t} -> max (tail_res prefix) (f t (append h prefix))
        end
    )) in 
            \xs: List. 
            run xs (nil unit);

sliding_window = \valid: List -> Bool. 
    let run = (fix (
    \f: List -> List -> Int -> Int -> Int. \l: List. \r: List. \seg: Int. \state: Int. 
    match r with
      nil _ -> state
    | cons {next, rt} -> 
        let tmp = (+ 1 seg) in 
            if (< 0 next) then f l rt tmp (max state tmp)
            else if (== tmp 1) then f rt rt (0) (state)
            else match l with
              cons {h, lt} -> f lt r (+ -2 tmp) state
            end

    end
)) in 
        \xs: List. 
        let tmp8 = (run xs xs (0) (0)) in 
            tmp8;

positive = fix (
    \f: List -> Bool. \xs: List. 
    match xs with
      nil _ -> true
    | cons {h, t} -> and (> h 0) (f t)
    end
);

main = \xs: List. 
    sliding_window positive xs;
