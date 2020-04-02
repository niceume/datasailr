%File datasailr-package.Rd

\name{datasailr-package}
\alias{datasailr-package}
\docType{package}
\title{
  Fast Row by Row Data Processing Tool, Using 'Sailr' Language
}
\description{
  A fast row by row data processing tool. You can write data manipulation code in 'Sailr' language which is specially intended for the data manipulation. The package uses 'libsailr' (C/C++ library) for its 'Sailr' code parsing and its execution.
}
\details{
  The main function, datasailr::sail(), takes dataframe as its 1st argument and 'Sailr' script as its 2nd argument, and returns the processing results as dataframe. This package works with 'libsailr' library, which conducts arithmetic calculations and string/character manipulations following 'Sailr' script. This 'DataSailr' package passes both 'Sailr' script and values of each row of dataframe to the 'libsailr', and 'libsailr' processes those values of each row. The processing results are stored and are returned as dataframe. 
}
\author{
Toshi Umehara, toshi@niceume.com.
Maintainer: Toshi Umehara <toshi@niceume.com>
}
\keyword{ package }
\seealso{
  \code{\link{sail}}.
}
\examples{
library(datasailr)
data(mtcars)

code_example = 'powerful = .
  if( 145 >= hp && hp > 0 ){
    powerful = 0
  }else if( hp > 145 ){
    powerful = 1
  }else{
    powerful = 2
  }

  germany = re/(^Merc|^Porsche|^Volvo)/
  japan = re/(^Mazda|^Honda|^Toyota)/

  if ( _rowname_ =~  germany ) { 
      country = "Germany" 
  }else if( _rowname_ =~ japan ){
      country = "Japan"
  }else {
      country = "Other"
  }
  company = rexp_matched(1)
'

sail(mtcars, code_example, fullData = TRUE)
}

