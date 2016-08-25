type
  Item[K,V] = object
    k: K
    v: V

proc p(t: typedesc[Item]) =
  echo "Ok"

echo compiles(p(Item[int, int]))
