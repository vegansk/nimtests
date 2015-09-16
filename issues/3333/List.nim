{.experimental.}

type
  ListNodeKind = enum 
    lnkNil, lnkCons
  List*[T] = ref object
    ## List ADT
    case kind: ListNodeKind
    of lnkNil:
      discard
    of lnkCons:
      value: T
      next: List[T] not nil
