import json, lib

# Override the default implementation for int
proc toJson(v: int): JsonNode =
  %*{
    "type": "int",
    "value": v
  }

echo 1.toJson

type
  Data = object
    v: int

# Override the default implementation for Data object
proc toJson(v: Data): JsonNode =
  result = newJObject()
  result["type"] = "Data".newJString
  result["value"] = v.v.toJson

let x = Data(v: 1)

echo x.toJson
