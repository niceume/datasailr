test_sail = function(){
  library(RUnit)
  # Test suit definition & Run tests.
  testSuite <- defineTestSuite( name = paste0( pkg, " Unit Tests") , 
             dir = system.file("unit_tests", package = pkg ), 
             testFileRegexp = "^test_.+\\.[rR]$",
             testFuncRegexp = "^test_.+")
  Sys.setenv("R_TESTS"="")
  tests <- runTestSuite(testSuite)
  printTextProtocol(tests)  
}
