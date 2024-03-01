Inductive List = nil Unit | cons {Int, List};
Inductive SnocList = lin Unit | snoc {SnocList, Int};

snoc_for_cons = \w: Int. fix (
  \f: List -> List. \xs: List.
  match xs with
    nil _ -> cons {w, nil unit}
  | cons {h, t} -> cons {h, f t}
  end
);

cons_for_snoc = \w: Int. fix (
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
  \f: SnocList -> Reframe List. \xs: SnocList.
  match xs with
    lin _ -> nil unit
  | snoc {t, h} -> snoc_for_cons h (f t)
  end
);

snoc_rec = \f: List -> Int. \xs: SnocList. f (snoc_to_list xs);

max = \x: Int. \y: Int. if (< x y) then y else x;

tmp = fix (
    \f: List -> {Int, Int}. \xs: List.
    match xs with
      nil _ -> {0, 0}
    | cons {h, t} -> let tmp2 = f t in {max tmp2.1 (+ h tmp2.2), + h tmp2.2}
    end
  );

mts = \xs: List. let tmp3 = tmp xs in tmp3.1;

main = \xs: SnocList. snoc_rec mts xs;