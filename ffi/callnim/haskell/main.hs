{-# LANGUAGE ForeignFunctionInterface #-}
module Main where

import Foreign.C.String
import Foreign.Marshal.Alloc

foreign import ccall "test_func" testFunc :: CString -> IO CString
foreign import ccall "NimMain" nimMain :: IO ()

main = do
  nimMain
  s <- newCString "Hello from Haskell"
  testFunc s >>= peekCString >>= putStrLn
  free s
