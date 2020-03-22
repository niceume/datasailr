%File datasailr-package.Rd

\name{datasailr-package}
\alias{datasailr-package}
\docType{package}
\title{
  DataSailr enables intuitive row by row data manipulation
}
\description{
  DataSailr package enables intuitive row by row data manipulation. The process can be written in Sailr lang, a language designed for data manipulation. A library called libsailr is used as its internal processing engine. Libsailr is written in C/c++, so the data manipulation speed is relatively fast. 
}
\details{
  The core engine of this package is libsailr. Libsailr takes Sailr script and does arithmetic calculations and string/character manipulations. This R package wraps libsair, and passes values of each row to the libsailr library. The results of 
  datasailr::sail() is the main function of this package. This function takes data.frame as the 1st argument and Sailr script as the 2nd argument. (Note that the 1st argument is data.frame, so you can use this package with %>% operator (in magrittr package), and combine this with functions of dplyr.)
}
\author{
Toshi Umehara, toshi@niceume.com.
Maintainer: Toshi Umehara <toshi@niceume.com>
}
\references{
  This optional section can contain literature or other references for background information.
}
\keyword{ package }
\seealso{
  \code{\link{sail}}.
  http://libsailr.github.io
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

datasailr::sail(mtcars, code_example, fullData = TRUE)
}

