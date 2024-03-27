/* Consider only non-negative integers */
/* Consider only small inputs to avoid timing out */
Config SampleIntMin = 0;
Config SampleIntMax = 3;
Config SampleSize = 4;

Inductive List = nil Unit | cons {Int, List};
Inductive NList = nnil Unit | ncons {List, NList};

/* Generate all possible results of performing one operation */

concat = fix (
  \f: NList -> NList -> NList. \xs: NList. \ys: NList.
  match xs with
    nnil _ -> ys
  | ncons {h, t} -> ncons {h, f t ys}
  end
);

mapcons = \w: Int. fix (
  \f: NList -> NList. \xs: NList.
  match xs with
    nnil _ -> xs
  | ncons {h, t} -> ncons {cons {w, h}, f t}
  end
);

remove_prefix = fix (
  \f: List -> NList. \xs: List.
  match xs with
    nil _ -> nnil unit
  | cons {h, t} ->
    if > h 0 then
      let newh = - h 1 in 
      let tres = mapcons newh (f t) in
      ncons {cons {- h 1, t}, tres}
    else 
      nnil unit
  end
);

operation = fix (
  \f: List -> NList. \xs: List.
  match xs with
    nil _ -> nnil unit
  | cons {h, t} ->
    let hres = remove_prefix xs in
    let tres = mapcons h (f t) in
    concat hres tres
  end
);

/* Brute-force search */

map = \g: List -> Int. fix (
  \f: NList -> List. \xs: NList.
  match xs with
    nnil _ -> nil unit
  | ncons {h, t} -> cons {g h, f t}
  end
);

min = \a: Int. \b: Int. if < a b then a else b;

merge = fix (
  \f: List -> Int. \xs: List.
  match xs with
    nil _ -> 0
  | cons {h, nil _} -> + 1 h
  | cons {h, t} -> min (+ 1 h) (f t)
  end
);

search = fix (
  \f: List -> Int. \xs: List.
  let ops = operation xs in
  merge (map f ops)
);

run = \xs: List. search xs;