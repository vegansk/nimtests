# DO NOT USE parsecsv MODULE!!! 
import parsecsv, streams

let s = newFileStream("test.csv", fmRead)

var csv: CsvParser
open(csv, s, "test.csv", '|', '\\', 0.char)
while csv.readRow:
  echo "******ROW******"
  for v in csv.row:
    echo "F = ", v
csv.close
