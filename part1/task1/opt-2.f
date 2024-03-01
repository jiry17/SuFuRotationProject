Inductive List = nil Unit | cons {Int, List};
Inductive NList = nnil Unit | ncons {List, NList};

append = \w: Int. fix (
  \f: Reframe List -> Reframe List. \xs: Reframe List.
  match xs with
    nil _ -> cons {w, nil unit}
  | cons {h, t} -> cons {h, f t}
  end
);

prefixes = fix (
  \f: Reframe List -> List -> Reframe NList. \prefix: Reframe List. \xs: List.
  match xs with
    nil _ -> ncons {prefix, nnil unit}
  | cons {h, t} -> ncons {prefix, f (append h prefix) t}
  end
) (nil unit);


sum = fix (
  \f: List -> Int. \xs: List.
  match xs with
    nil _ -> 0
  | cons {h, t} -> + h (f t)
  end
);

map = \op: List -> Int. fix (
  \f: NList -> List. \xs: NList.
  match xs with
    nnil _ -> nil unit
  | ncons {h, t} -> cons {op h, f t}
  end 
);

filter = \op: Int -> Bool. fix (
  \f: List -> List. \xs: List.
  match xs with
    nil _ -> xs
  | cons {h, t} -> if op h then cons {h, f t} else f t
  end
);

is_pos = \w: Int. > w 0;

length = fix (
  \f: List -> Int. \xs: List.
  match xs with
    nil _ -> 0
  | cons {h, t} -> + 1 (f t)
  end
);

main = \xs: List. length (filter is_pos (map sum (prefixes xs)));