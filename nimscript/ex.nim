try:
  echo "Try block"
  raise newException(Exception, "Test")
except:
  echo "Except block"
  
