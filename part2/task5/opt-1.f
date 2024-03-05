Config SampleIntMin = 0;
Config SampleIntMax = 1;
Config SampleSize = 6; /*Reduce the time of random testing*/

Inductive List = cons {Int, List} | single Int;
Input = {List, List};

head = \xs: List.
  match xs with
    cons {h, t} -> h
  | single h -> h
  end;

tail = \xs: List.
  match xs with
    cons {h, t} -> t
  end;

/* get the last element from List */
last = fix (
  \f: List -> Int. \xs: List.
  match xs with
    cons {h, t} -> f t
  | single h -> h
  end
);

/* add x to the end of List */
snoc = \x: Int. fix (
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
  match {xs, ys} with
    {cons {xh, xt}, cons {yh, yt}} ->
      if == xh yh then f xt yt else false
  | {single x, single y} -> == x y
  | _ -> false
  end
);

list_lt = fix (
  \f: Reframe List -> Reframe List -> Bool. \xs: Reframe List. \ys: Reframe List.
  match {xs, ys} with
    {cons {xh, xt}, cons {yh, yt}} ->
      if == xh yh then f xt yt
      else if < xh yh then true
      else false
  | {single x, single y} -> < x y
  | {single x, cons {y, _}} -> <= x y
  | {cons {x, _}, single y} -> < x y
  end
);

cal = fix (
  \f: List -> List -> Reframe List -> Reframe List -> Int -> Int.
  \ch0: List.
  \ch1: List.
  \path0: List.
  \path1: List.
  \way: Int.
  match ch0 with
    cons {h0, t0} ->
      match ch1 with
        cons {h1, t1} ->
          let path11 = cons {h1, path1} in
          let path01 = path0 in
          if list_lt path11 path01
          then f t0 t1 (cons {h0, path11}) path11 1
          else if list_eq path11 path01
               then f t0 t1 (cons {h0, path01}) path11 (+ way 1)
               else f t0 t1 (cons {h0, path01}) path11 way
      end
  | single h0 ->
      match ch1 with
        single h1 ->
          let path11 = cons {h1, path1} in
          let path01 = path0 in
          if list_lt path11 path01
          then 1
          else if list_eq path11 path01
               then (+ way 1)
               else way
      end
  end
);

main = \inp: Input.
  match inp with
    {xs, ys} ->
      let ch0 = reverse xs in
      let ch1 = reverse ys in
      let path1 = single (head ch1) in
      let path0 = cons {head ch0, path1} in
      cal (tail ch0) (tail ch1) path0 path1 1
  end
;