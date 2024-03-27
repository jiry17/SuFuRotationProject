Inductive List = nil Unit | cons {Int, List};

single_pass = \g: List -> Int.
  let run = fix (
    \f: List -> List. \xs: List.
    match xs with
      nil _ -> xs 
    | cons {h, t} -> cons {h, f t}
    end
  ) in
  \xs: List. g (run xs);