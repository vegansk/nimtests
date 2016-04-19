import json, lib, fp.option, future

# Override the default implementation for int
# proc toJson(v: int): JsonNode =
#   %*{
#     "type": "int",
#     "value": v
#   }
# proc fromJson(t = int, v: JsonNode): int =
#   assert v["type"].getStr == "int"
#   v["value"].getNum.int

echo 1.toJson

type
  Data = object
    v: int
    o: Option[string]

proc toJson[T](o: Option[T]): JsonNode =
  o.map((v: T) => v.toJson).getOrElse(() => newJNull())

proc fromJson[T](t: typedesc[Option[T]], v: JsonNode): Option[T] =
  if v == newJNull():
    T.none
  else:
    fromJson(T, v).some

# Override the default implementation for Data object
# proc toJson(v: Data): JsonNode =
#   result = newJObject()
#   result["type"] = "Data".newJString
#   result["value"] = v.v.toJson
# proc fromJson(t = Data, v: JsonNode): Data =
#   assert v["type"] == %"Data"
#   result.v = int.fromJson(v["value"])

let x = Data(v: 1, o: "hello".some)

echo x.toJson

echo Data.fromJson(x.toJson)

echo Option[int].fromJson(1.some.toJson)
