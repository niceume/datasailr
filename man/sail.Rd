%File sail.Rd

\name{sail}
\alias{sail}
\title{run Sailr script for dataset }
\description{
  dataSailr::sail() is the main function of this package. This function takes data.frame as the 1st argument and Sailr script as the 2nd argument. (Note that the 1st argument is data.frame, so you can use this package with %>% operator (in magrittr package), and combine this with functions of dplyr.
}
\usage{
  sail( df, code, fullData = FALSE)
}
\arguments{
  \item{df}{ data.frame to be processed.}
  \item{code}{ Sailr script that instructs Silar engine to manipulate values and strings.}
  \item{fullData}{ When fullData is set False (default value), only the columsn corresponding to left-hand-side(LHS) variables in sailr scripts are returned. (e.g. In Sailr script, bmi = weight / height / height , the variable bmi is the LHS. ) If set True, all the columns are returned. This option is intended to minimize the memory usage.}
}

