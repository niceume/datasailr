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
  The core engine of this package is libsailr. Libsailr takes Sailr script and does arithmetic calculations and string/character manipulations. This R package wraps libsair, and passes values of each row to the libsailr library. The results of 
  datasailr::sail() is the main function of this package. This function takes data.frame as the 1st argument and Sailr script as the 2nd argument.
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

