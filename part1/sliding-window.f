Inductive List = cons {Int, List} | nil Unit;

append = \w: Int. fix (
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
  end;

tail = \xs: List.
  match xs with
    nil _ -> xs
  | cons {h, t} -> t
  end;

max = \a: Int. \b: Int. if < a b then b else a;

ref = \valid: List -> Bool.     /* A brute force program for the longest valid problem*/
  let tail_res = fix (
    \f: List -> Int. \xs: List.
    match xs with
      nil _ -> 0
    | cons {h, t} ->
      max (f t) (if valid xs then length xs else 0)
    end
  ) in let run = fix (
    \f: List -> List -> Int. \xs: List. \prefix: List.
    match xs with
      nil _ -> tail_res prefix
    | cons {h, t} -> max (tail_res prefix) (f t (append h prefix))
    end
  ) in \xs: List.
    run xs (nil unit);

sliding_window = \valid: List -> Bool.
  let run = fix (
    \f: List -> List -> List -> List -> List.
    \l: List.                   /* The suffix corresponding to the left boundary. */
    \r: List.                   /* The suffix corresponding to the right boundary. */
    \seg: List.                 /* The current segment. */
    \state: List.               /* The prefix to the right boundary. */
    match r with 
      nil _ -> state
    | cons {next, rt} ->        /* Try to extend seg with the next value */
      let tmp = append next seg in
      if valid tmp then         /* If valid, then extend directly */
        f l rt tmp (append next state)
      else if is_empty seg then /* If already empty, then consider the next suffix with an empty seg*/
        f rt rt (nil unit) (append next state)
      else match l with         /* Otherwise, pop out the first element of seg and try again*/
        cons {h, lt} ->        
          f lt r (tail seg) state
      end
    end
  ) in \xs: List.
    ref valid (run xs xs (nil unit) (nil unit));

positive = fix (
  \f: List -> Bool. \xs: List.
  match xs with
    nil _ -> true
  | cons {h, t} -> and (> h 0) (f t)
  end
);

main = sliding_window positive;
