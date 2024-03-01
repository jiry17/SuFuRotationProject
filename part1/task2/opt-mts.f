Inductive List = nil Unit | cons {Int, List};

run = fix (
    \f: List -> Reframe List. \xs: List.
    match xs with
      nil _ -> nil unit
    | cons {h, t} -> cons {h, f t}
    end
  );

single_pass = \g: List -> Int. \xs: List. g (run xs);

max = \x: Int. \y: Int. if (< x y) then y else x;

tmp = fix (
    \f: List -> {Int, Int}. \xs: List.
    match xs with
      nil _ -> {0, 0}
    | cons {h, t} -> let tmp2 = f t in {max tmp2.1 (+ h tmp2.2), + h tmp2.2}
    end
  );

mts = \xs: List. let tmp3 = tmp xs in tmp3.1;

main = \xs: List. single_pass mts xs;