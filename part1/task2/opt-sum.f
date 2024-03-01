Inductive List = nil Unit | cons {Int, List};

run = fix (
    \f: List -> Reframe List. \xs: List.
    match xs with
      nil _ -> nil unit
    | cons {h, t} -> cons {h, f t}
    end
  );

single_pass = \g: List -> Int. \xs: List. g (run xs);

sum = fix (
    \f: List -> Int. \xs: List.
    match xs with
      nil _ -> 0
    | cons {h, t} -> + h (f t)
    end
  );

main = \xs: List. single_pass sum xs;