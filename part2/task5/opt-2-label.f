Inductive List = cons {Int, List} | single Int;

Input = {List, List};

head = \xs: List. 
    match xs with
      cons {h, t} -> h
    | single h -> h
    end
;

tail = \xs: List. 
    match xs with
      cons {h, t} -> t
    end
;

last = fix (
    \f: List -> Int. \xs: List. 
    match xs with
      cons {h, t} -> f t
    | single h -> h
    end
);

snoc = \x: Int. 
    fix (
    \f: List -> List. \xs: List. 
    match xs with
      cons {h, t} -> cons {h, f t}
    | single h -> cons {h, single x}
    end
);

reverse = fix (
    \f: List -> List. \xs: List. 
    match xs with
      cons {h, t} -> snoc h (f t)
    | single h -> xs
    end
);

list_eq = fix (
    \f: Reframe List -> Reframe List -> Bool. \xs: Reframe List. \ys: Reframe List. 
    let tmp1 = false in 
        rewrite  (match {unlabel xs , unlabel ys } with
          {cons {xh, xt}, cons {yh, yt}} -> if (== xh yh) then f (label xt ) (label yt )
            else false
        | {single x, single y} -> == x y
        | _ -> tmp1
        end
) );

list_lt = fix (
    \f: Reframe List -> Reframe List -> Bool. \xs: Reframe List. \ys: Reframe List. 
    rewrite  (match {unlabel xs , unlabel ys } with
      {cons {xh, xt}, cons {yh, yt}} -> if (== xh yh) then f (label xt ) (label yt )
        else if (< xh yh) then true
        else false
    | {single x, single y} -> < x y
    | {single x, cons {y, _}} -> <= x y
    | {cons {x, _}, single y} -> < x y
    end
) );

cal = fix (
    \f: List -> List -> {Reframe List, Reframe List, Int}. \ch0: List. \ch1: List. 
    match {ch0, ch1} with
      {cons {h0, t0}, cons {h1, t1}} -> 
        let tmp = (f t0 t1) in 
            let path00 = tmp.1 in 
                let path10 = tmp.2 in 
                    let way0 = tmp.3 in 
                        let path11 = (rewrite  (label (cons {h1, unlabel path10 }) ) ) in 
                            let path01 = path00 in 
                                let way1 = way0 in 
                                    if (list_lt path11 path01) then {rewrite  (label (cons {h0, unlabel path11 }) ) , path11, 1}
                                    else if (list_eq path11 path01) then {rewrite  (label (cons {h0, unlabel path01 }) ) , path11, + way1 1}
                                    else {rewrite  (label (cons {h0, unlabel path01 }) ) , path11, way1}
    | {single h0, single h1} -> 
        let path1 = (single h1) in 
            let path0 = (cons {h0, path1}) in 
                let way = 1 in 
                    {rewrite  (label path0 ) , rewrite  (label path1 ) , way}
    end
);

main = \inp: Input. 
    match inp with
      {xs, ys} -> (cal xs ys).3
    end
;