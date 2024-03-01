Inductive List = nil Unit | cons {Int, List};

run = fix (
    \f: List -> List. \xs: List.
    match xs with
      nil _ -> xs 
    | cons {h, t} -> cons {h, f t}
    end
  );

single_pass = \g: List -> Int.
  \xs: List. g (run xs);