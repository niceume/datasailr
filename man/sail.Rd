%File sail.Rd

\name{sail}
\alias{sail}
\title{Run 'Sailr' script and manipulate dataframe }
\description{
  datasailr::sail() is the main function of this 'DataSailr' package. This function takes data.frame as the 1st argument and 'Sailr' script as the 2nd argument. 
}
\usage{
  sail( df, code, fullData = TRUE , rowname = "_rowname_")
}
\arguments{
  \item{df}{ data.frame to be processed.}
  \item{code}{ 'Sailr' script that instructs how to manipulate values and strings.}
  \item{fullData}{ When fullData is set FALSE, only the columns corresponding to left-hand-side(LHS) variables in Sailr scripts are returned. (e.g. In Sailr script, bmi = weight / height / height , the variable bmi is the LHS.) If set TRUE, all the columns are returned. }
  \item{rowname}{ Dataframe's row names are accessed via the variable name specified by this option. The default variable name is _rowname_, meaning that _rowname_ represents dataframe's row names in 'Sailr' script, though this does not allow assignment. Even if you assign some value to this variable, they are not reflected in the row names of the resultant dataframe. }
}
\examples{
library(datasailr)
data(iris)

iris_code = '
iris_type = .
if ( Species == "setosa" ) { 
    iris_type = 1 
}else if( Species == "versicolor" ) { 
    iris_type = 2
}else if(Species == "virginica" ) { 
    iris_type = 3 
}
'
sail(iris, iris_code, fullData = TRUE)
}

