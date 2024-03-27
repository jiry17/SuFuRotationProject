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

length = fix (
  \f: List -> Int. \xs: List.
  match xs with
    single _ -> 1
  | cons {h, t} -> + 1 (f t)
  end
);

list_eq = fix (
  \f: List -> List -> Bool. \xs: List. \ys: List.
  match {xs, ys} with
    {cons {xh, xt}, cons {yh, yt}} ->
      if == xh yh then f xt yt else false
  | {single x, single y} -> == x y
  | _ -> false
  end
);

list_lt = fix (
  \f: List -> List -> Bool. \xs: List. \ys: List.
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

main = \inp: Input.
  if == (length inp.1) (length inp.2) then   /*Filter out invalid inputs*/
    /* TODO */
  else 0;