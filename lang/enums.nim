{.pragma: doc.}

type
  SecurityCategoryEt {.pure, doc: {"a": "sdf"}.} = enum 
    ORDN, 
    PREF,
    UNDEF

echo SecurityCategoryEt.ORDN
