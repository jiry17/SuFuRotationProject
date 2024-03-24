/* Consider only non-negative integers */
/* Consider only small inputs to avoid timing out */
Config SampleIntMin = 0;
Config SampleIntMax = 3;
Config SampleSize = 4;

Inductive List = nil Unit | cons {Int, List};
Inductive NList = nnil Unit | ncons {List, NList};

concat = fix (
  \f: Reframe NList -> Reframe NList -> Reframe NList. \xs: Reframe NList. \ys: Reframe NList.
  match xs with
    nnil _ -> ys
  | ncons {h, t} -> ncons {h, f t ys}
  end
);

map = \g: List -> Int. fix (
  \f: NList -> List. \xs: NList.
  match xs with
    nnil _ -> nil unit
  | ncons {h, t} -> cons {g h, f t}
  end
);

min = \a: Int. \b: Int. if < a b then a else b;

/* map+cons */
mapcons = \w: Int. fix (
  \f: Reframe NList -> Reframe NList. \xs: Reframe NList.
  match xs with
    nnil _ -> xs
  | ncons {h, t} -> ncons {cons {w, h}, f t}
  end
);

/* move n prefix */
remove_prefix = fix (
  \f: List -> Reframe NList. \xs: List.
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

/* Generate all possible results of performing one operation */
operation = fix (
  \f: List -> Reframe NList. \xs: List.
  match xs with
    nil _ -> nnil unit
  | cons {h, t} ->
    let hres = remove_prefix xs in
    let tres = mapcons h (f t) in
    concat hres tres
  end
);

merge = fix (
  \f: List -> Int. \xs: List.
  match xs with
    nil _ -> 0
  | cons {h, nil _} -> + 1 h
  | cons {h, t} -> min (+ 1 h) (f t)
  end
);

/* Brute-force search */
search = fix (
  \f: List -> Int. \xs: List.
  let ops = operation xs in
  merge (map f ops)
);

run = fix (
    \f: List -> Reframe List. \xs: List.
    match xs with
      nil _ -> nil unit
    | cons {h, t} -> cons {h, f t}
    end
  );

single_pass = \g: List -> Int. \xs: List. g (run xs);

main = \xs: List. single_pass search xs;