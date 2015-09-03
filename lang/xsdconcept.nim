import xmltree

type
  XsdType[T: typedesc] = object
  XsdAware = concept c
    genXsd(c) is XmlNode

proc genXsd(v: XsdType[int]): XmlNode = <>int()
proc genXsd(v: XsdType[string]): XmlNode = <>string()

echo XsdType[int] is XsdAware
echo XsdType[string] is XsdAware
echo XsdType[float] is XsdAware

proc genXsd[T](): XmlNode = XsdType[T]().genXsd()

echo genXsd[int]()
echo genXsd[string]()
