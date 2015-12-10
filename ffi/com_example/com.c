#define _WIN32_DCOM
#define COBJMACROS
#include <ole2.h>
#include <stdio.h>
#include <wbemidl.h>

int init_com() {
  HRESULT hr = CoInitializeEx(0, COINIT_MULTITHREADED); 
  if (FAILED(hr)) {
    return (int)hr;
  }

  hr =  CoInitializeSecurity(NULL,                      // Security descriptor    
                             -1,                        // COM negotiates authentication service
                             NULL,                      // Authentication services
                             NULL,                      // Reserved
                             RPC_C_AUTHN_LEVEL_DEFAULT, // Default authentication level for proxies
                             RPC_C_IMP_LEVEL_IMPERSONATE, // Default Impersonation level for proxies
                             NULL,                        // Authentication info
                             EOAC_NONE,                   // Additional capabilities of the client or server
                             NULL);                       // Reserved
  if (FAILED(hr)) {
    CoUninitialize();
    return (int)hr;
  }

  return 0;
}

#ifdef __MINGW32__
/* MinGW has a bug: absent CLSID_WbemLocator in libwbemuuid.a */
const CLSID CLSID_WbemLocator = {0x4590F811, 0x1D3A, 0x11D0, {0x89, 0x1F, 0, 0xAA, 0, 0x4B, 0x2E, 0x24}};
#endif

#define RETURN(s) { result = (s); \
    goto end; }

int get_system_drive_serial(wchar_t* buff, int buff_len) {
  int result = 0;

  IWbemLocator *pLoc = 0;
  IWbemServices *pSvc = 0;
  IEnumWbemClassObject* pEnumerator = 0;
  IWbemClassObject *pclsObj = 0;
  ULONG uReturn = 0;
  VARIANT vtProp;

  wchar_t *test = L"XXX-XXX";
  int len = wcslen(test) + 1;

  HRESULT hr = CoCreateInstance(&CLSID_WbemLocator, 0, 
                                CLSCTX_INPROC_SERVER, &IID_IWbemLocator, (LPVOID *) &pLoc);
 
  if (FAILED(hr))
    RETURN((int)hr);
  hr = IWbemLocator_ConnectServer(pLoc,
                                  L"ROOT\\CIMV2",  //namespace
                                  NULL,       // User name 
                                  NULL,       // User password
                                  0,         // Locale 
                                  NULL,     // Security flags
                                  0,         // Authority 
                                  0,        // Context object 
                                  &pSvc);   // IWbemServices proxy

  if (FAILED(hr))
    RETURN((int)hr);

  hr = CoSetProxyBlanket(pSvc,
                         RPC_C_AUTHN_WINNT,
                         RPC_C_AUTHZ_NONE,
                         NULL,
                         RPC_C_AUTHN_LEVEL_CALL,
                         RPC_C_IMP_LEVEL_IMPERSONATE,
                         NULL,
                         EOAC_NONE
                         );
  
  if (FAILED(hr))
    RETURN((int)hr);

  hr = IWbemServices_ExecQuery(pSvc,
                               L"WQL", 
                               L"SELECT * FROM Win32_OperatingSystem",
                               WBEM_FLAG_FORWARD_ONLY | WBEM_FLAG_RETURN_IMMEDIATELY, 
                               NULL,
                               &pEnumerator);

  if (FAILED(hr))
    RETURN((int)hr);

  while(pEnumerator) {
    hr = IEnumWbemClassObject_Next(pEnumerator, WBEM_INFINITE, 1,
                           &pclsObj, &uReturn);

    if(0 == uReturn) {
      RETURN(-1);
    }

    // Get the value of the Name property
    hr = IWbemClassObject_Get(pclsObj, L"SerialNumber", 0, &vtProp, 0, 0);
    len = wcslen(vtProp.bstrVal) + 1;
    if(buff_len < len)
      RETURN(-len);

    wcscpy(buff, vtProp.bstrVal);

    break;
  }
  
 end:
  VariantClear(&vtProp);
  if(pclsObj)
    IUnknown_Release(pclsObj);
  if(pEnumerator)
    IUnknown_Release(pEnumerator);
  if(pSvc)
    IUnknown_Release(pSvc);
  if(pLoc)
    IUnknown_Release(pLoc);
  return result;
}
