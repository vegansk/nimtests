import json, lib

# Override the default implementation for int
proc toJson(v: int): JsonNode =
  %*{
    "type": "int",
    "value": v
  }
proc fromJson(t = int, v: JsonNode): int =
  assert v["type"].getStr == "int"
  v["value"].getNum.int

echo 1.toJson

type
  Data = object
    v: int

# Override the default implementation for Data object
proc toJson(v: Data): JsonNode =
  result = newJObject()
  result["type"] = "Data".newJString
  result["value"] = v.v.toJson

proc fromJson(t = Data, v: JsonNode): Data =
  assert v["type"] == %"Data"
  result.v = int.fromJson(v["value"])

let x = Data(v: 1)

echo x.toJson

echo Data.fromJson(x.toJson)
