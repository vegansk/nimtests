import xmltree, xmlparser, streams, strtabs
const data = """
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
    <SOAP-ENV:Header/>
    <SOAP-ENV:Body>
        <SOAP-ENV:Fault>
            <faultcode>SOAP-ENV:Client</faultcode>
            <faultstring xml:lang="en">Validation error</faultstring>
            <detail>
                <spring-ws:ValidationError xmlns:spring-ws="http://springframework.org/spring-ws">cvc-datatype-valid.1.2.1: 'ISSUER_ID_T' is not a valid value for 'integer'.</spring-ws:ValidationError>
                <spring-ws:ValidationError xmlns:spring-ws="http://springframework.org/spring-ws">cvc-type.3.1.3: The value 'ISSUER_ID_T' of element 'v2:issuer_id' is not valid.</spring-ws:ValidationError>
            </detail>
        </SOAP-ENV:Fault>
    </SOAP-ENV:Body>
</SOAP-ENV:Envelope>
"""

when isMainModule:
  let xml = data.newStringStream.parseXml
  echo xml.len
  echo xml[0].attrs
