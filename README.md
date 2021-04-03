# About DataSailr

DataSailr is an R package which enables row by row data manipulation. 

The data manipulation process is written in DataSailr script, which is designed specifically for data manipulation. The internal data manipulation engine is a library called libsailr, which is written in C/C++ and the processing speed is relatively fast. If you are interested in DataSailr's internal implementation, please also have a look at libsailr library.

This package is still in development. Please let me know if you find bugs or inconsistent behaviors. The documentation is not enough, so I am willing to explain it if you find something difficult.


## Description & Motivation

DataSailr package brings intuitive and fast row by row data manipulation to R. The data manipulation instruction for each row is written in DataSailr script. DataSailr script is an easy script designed especially for data manipulation. In vanilla R, dataframe is manipulated using column vector and vector operations. When summarizing dataframe, column wise calculation is intuitive and ideal, but when manipulating dataframe you need to see each record in the row direction. For example, when calculating body mass index (BMI) from body weight and height, calculation needs to be done for each row. Categorizing each person based on his/her BMI is also done for each row.

A famous R package, dplyr, has been improving the same kind of points. It enables data manipulation without thinking much about column vectors. Pipe operator, %>% in magrittr package, and dplyr functions realize intuitive data manipulation flow. The DataSailr package enables the same kind of thing with a single DataSailr code. The two packages do not compete, and I intend to implement DataSailr as it also can work with dplyr.


## How to install

### CRAN

DataSailr package is available on CRAN.

```
# Start R interpreter
install.packages("datasailr")
```


### Binaries

Binaries are provided at "https://datasailr.io/download"


### Install from source

For compilation, autotools, bison, flex and some other UNIX programs are required.

DataSailr_toolchain repository provides a way to create CRAN package, and to install it. CRAN package requires some rules. For example, std::cout is not used, but Rcpp::Rcout needs to be used. Also, DataSailr repository itself does not include libsailr and Onigmo. When including those libraries for CRAN package, additional copy right holders need to be listed in DESCRIPTION file. If you do not need these modifications, installing from DataSailr repository itself is also an acceptable way..


* Install from datasailr_toolchain repository

```
git clone https://github.com/niceume/datasailr_toolchain.git
cd datasailr_toolchain
./create_datasailr_pkg.sh
./create_packages.sh
```

* Install from datasailr repository

```
git clone <datasailr repository>
cd datasailr/src
./update_3rd_party_library.sh  # This downloads Onigmo library.
cd ..
autoconf  # Generate configure script.
cd ..

R CMD INSTALL datasailr --preclean --no-multiarch --build
```

## Testing

### Run tests

From R interpreter, please run the following code. 

```
install.packages("datasailr")
library(datasailr)
test_sail()
```

### Run tests manually

These test scripts can be run manually as follows. (RUnit package needs to be installed)


#### Test arithmetic operators

The following code creates new columns from iris datset as follows.

* 'Sepal.Area' column: Sepal.Length column multiplied by Sepal.Width column values
* 'Petal.Area' column: Petal.Length column multiplied by Petal.Width column values
* 'Sepal.Petal.Ratio' column: Sepal.Area column divided by Petal.Area column values
* 'exp' column: 2 to the 5th power (All the elements of this new column has the same value)
* 'exp2' column: 2 to the 5th power (All the elements of this new column has the same value)
* 'exp3' column: 2.2 to the 3rd power (All the elements of this new column has the same value)


```
test_arithmetic <- function(){

  ##### Create new columns using datasailr (iris_result) #####

  data(iris)
  code = "
    Sepal.Area = Sepal.Length * Sepal.Width
    Petal.Area = Petal.Length * Petal.Width
 
    Sepal.Petal.Ratio = Sepal.Area / Petal.Area
 
    exp = 2 ^ 5
    exp2 = 2 ** 5 
    exp3 = 2.2 ^ 3 
  "

  iris_result = datasailr::sail(iris, code)


  ##### Create new columns using R's standard way (iris2) #####

  iris2 = iris;
  iris2[,"Sepal.Area"] = iris2[,"Sepal.Length"] * iris2[,"Sepal.Width"]
  iris2[,"Petal.Area"] = iris2[,"Petal.Length"] * iris2[,"Petal.Width"]
  iris2[,"Sepal.Petal.Ratio"] = iris2[,"Sepal.Area"] / iris2[,"Petal.Area"]
  
  n_rows = nrow(iris2)
  iris2$exp = rep(2 ^ 5, n_rows)
  iris2$exp2 = rep(2 ^ 5, n_rows)
  iris2$exp3 = rep(2.2 ^ 3, n_rows) 


  ##### Compare iris_result and iris2 #####

  RUnit::checkEqualsNumeric( iris_result[,"Sepal.Area"] , iris2[,"Sepal.Area"])
  RUnit::checkEqualsNumeric( iris_result[,"Petal.Area"] , iris2[,"Petal.Area"])
  RUnit::checkEqualsNumeric( iris_result[,"Sepal.Petal.Ratio"] , iris2[,"Sepal.Petal.Ratio"])
  RUnit::checkEqualsNumeric( iris_result[,"exp"] , iris2[,"exp"])
  RUnit::checkEqualsNumeric( iris_result[,"exp2"] , iris2[,"exp2"])
  RUnit::checkEqualsNumeric( iris_result[,"exp3"] , iris2[,"exp3"])
}

test_arithmetic()
```

#### Test if statements

The following code creates new columns from mtcars datset as follows.

* 'power' column : If the hp column value is larger than 145, "powerful" is assigned. Between 0 to 145, "low power" is assigned.
* 'efficient' column : If the mpg column value is larger than 20, "efficient" is assigned. Between 0 to 20 "inefficient" is assigned.
* 'description' column : Description for each car is created by concatnating name, power and efficient column values.

```
test_if <- function(){

  ##### Create new columns using datasailr (mtcars_result) #####

  data(mtcars)
  mtcars[,"name"] = rownames(mtcars)

  code = '
    power = ""
    if( hp > 145 ){
      power = "powerful"
    }else if( 145 >= hp && hp > 0){
      power = "low power"
    }else{
      print("hp variable has missing value")
    }

    efficient = ""
    if( mpg > 20){
      efficient = "efficient"
    }else if( 20 >= mpg && mpg > 0 ){
      efficient = "inefficient"
    }else{
      print("mpg variable has missing value")
    }

    description = name + " is " + power + " " + efficient + " car"
  '

  mtcars_result = datasailr::sail(mtcars, code)


  ##### Create new columns using R's standard way (mtcars2) #####

  mtcars2 = mtcars

  mtcars2$power = ifelse( mtcars2$hp > 145 , "powerful" , "low power" )
  mtcars2$efficient = ifelse( mtcars2$mpg > 20 , "efficient" , "inefficient" )
  mtcars2$description = paste(mtcars2$name, "is", mtcars2$power, mtcars2$efficient, "car" )


  ##### Compare mtcars_result and mtcars2 #####
  
  RUnit::checkEquals( mtcars_result[,"power"] , mtcars2[,"power"] )
  RUnit::checkEquals( mtcars_result[,"efficient"] ,   mtcars2[,"efficient"] )
  RUnit::checkEquals( mtcars_result[,"description"] , mtcars2[,"description"] )
}

test_if()
```

#### Test regular expressions

The following code creates new columns from mtcars datset as follows.

* 'power' column : If the hp column value is larger than 145, "powerful" is assigned. Between 0 to 145, "low power" is assigned.
* 'country' column : This column is created based on pattern matchig with automobile names, which are stored in name column.
    + Regular expression literal is re/pattern/ . In the following example, this regular expression is handled by variables, such as germany, usa, and japan.
    + Regular expression matching operator is =~
    + Regular expression matching is conducted in if-else statement. Based on matching results, country column values are assigned. 
* 'description' column : Description for each car is created by concatenating name, power and country column values.

```
test_regexp  <- function(){
  data(mtcars)
  mtcars[,"name"] = rownames(mtcars)

  ##### Create new columns using datasailr (mtcars_result) #####
  
  code = '
    germany = re/(^Merc|^Porsche|^Volvo)/
    usa = re/(^Hornet|^Cadillac|^Lincoln|^Chrysler|^Dodge|^AMC|^Camaro|^Chevrolet|^Pontiac|^Ford)/
    japan = re/(^Mazda|^Datsun|^Honda|^Toyota)/
    austoralia = re/(^Valiant)/
    france=re/(^Duster)/
    italy=re/(^Fiat|^Ferrari|^Maserati)/
    uk = re/(^Lotus)/

    power = ""
    if( hp > 145 ){
      power = "powerful"
    }else if( 145 >= hp && hp > 0){
      power = "low power"
    }else{
      print("hp variable has missing value")
      power = "unknown power"
    }

    country = ""
    if(name =~ germany){
      country = "Germany"
    }else if(name =~ usa){
      country = "USA"
    }else if(name =~ japan){
      country = "Japan"
    }else if(name =~ austoralia){
      country = "Austoralia"
    }else if(name =~ france){
      country = "France"
    }else if(name =~ italy){
      country = "Italy"
    }else if(name =~ uk){
      country = "UK"
    }else{
      country = "other country"
    }

    description = name + " is " +  power + " " + country + " made car."
  '

  mtcars_result = datasailr::sail(mtcars, code)


  ##### Create expected data frame manually (mtcars2) #####

  mtcars2 = mtcars

  mtcars2$power = ifelse( mtcars2$hp > 145 , "powerful" , "low power" )
  country_list = c( rep("Japan", 3), rep("USA", 2), "Austoralia", "France", rep("Germany", 7), rep("USA", 3),  "Italy", rep("Japan",3), rep("USA",4), "Italy", "Germany", "UK", "USA", rep("Italy",2), "Germany")
  mtcars2$country = country_list
  mtcars2$description = paste0(mtcars2$name , " is ", mtcars2$power, " ", mtcars2$country, " made car.")


  ##### Compare mtcars_result and mtcars2 #####

  RUnit::checkEquals( mtcars_result[,"power"] , mtcars2[,"power"])
  RUnit::checkEquals( mtcars_result[,"country"] , mtcars2[,"country"])
  RUnit::checkEquals( mtcars_result[,"description"] , mtcars2[,"description"])
}

test_regexp()
```

#### Test pushing new rows

The following code converts wide format data frame into long format.

* The original data frame, wide_df, have subj, t0, t1, t2 and t3 columns
* The result data frame has 'time' column.
    * For each subject, four rows are created for each time point, 0, 1, 2 and 3.

```
test_push_rows <- function(){

  ##### Prepare data frame in a wide format #####

  wide_df = data.frame(
    subj = c("Tom", "Mary", "Jack"),
    t0 = c( 50, 42, 80),
    t1 = c( 48, 42, 75),
    t2 = c( 46, 44, 72),
    t3 = c( 42, 42, 73)
  )

  ##### Convert it into long fortmat using datasailr. #####

  code = "
    subject = subj
    time = 0
    bw = t0
    push!()

    time = 1
    bw = t1 
    push!()

    time = 2
    bw = t2
    push!()

    time = 3
    bw = t3
  "

  long_df = datasailr::sail(wide_df , code = code, fullData=FALSE)

  ##### From long format data frame, subset rows with subject name is "Tom" #####

  tom_long_df = long_df[long_df$subject=="Tom", ]

  ##### Checking the result #####

  RUnit::checkEqualsNumeric( 4 * nrow(wide_df), nrow(long_df))
  RUnit::checkEqualsNumeric( tom_long_df$bw , c(50, 48, 46, 42))
}

test_push_rows()
```




## How to run DataSailr script

datasailr::sail() is the main function of this package. This function takes data.frame as the 1st argument and DataSailr script as the 2nd argument. (Note that the 1st argument is data.frame, so you can use this package with %>% operator (in magrittr package), and combine this with functions of dplyr.)

```
library(datasailr)

datasailr::sail( df, '
<DataSailr script>
'
)
```


## Quick introduction

In this quick introduction, built-in R dataframe called mtcars is going to be used. The mtcars datafram has automobile information in 1970's. The detail of this dataframe is described here. (https://www.rdocumentation.org/packages/datasets/versions/3.6.1/topics/mtcars)

* Built-in dataframe, mtcars.

```
data(mtcars)
head(mtcars,2)
```

(OUTPUT)

|              | mpg | cyl | disp | hp  | drat |   wt  | qsec  |vs  | am |gear |carb
---------------|-----|-----|------|-----|------|-------|-------|----|----|-----|-----
|Mazda RX4     | 21  | 6   | 160  | 110 | 3.9  | 2.620 | 16.46 | 0  | 1  | 4   | 4
|Mazda RX4 Wag | 21  | 6   | 160  | 110 | 3.9  | 2.875 | 17.02 | 0  | 1  | 4   | 4


### Code example

Before executing the following code, install DataSailr package (and magrittr package.) Installation instruction is mentioned later in this README (Binary package is the easiest way to try, until this package becomes available on CRAN).

* (Example)

```
library(datasailr)
library(magrittr)

mtcars %>% datasailr::sail('
if( hp > 145 ){  power = "high" }
else if( 145 >= hp && hp > 0){ power = "low" }
else{  print("hp variable has missing value")}

germany = re/(^Merc|^Porsche|^Volvo)/
usa = re/(^Hornet|^Cadillac|^Lincoln|^Chrysler|^Dodge|^AMC|^Camaro|^Chevrolet|^Pontiac|^Ford)/
japan = re/(^Mazda|^Datsun|^Honda|^Toyota)/

if ( _rowname_ =~ germany ) { country = "Germany" ; type = rexp_matched(1); }
else if( _rowname_ =~ usa ) { country = "USA"  ; type = rexp_matched(1);  }
else if( _rowname_ =~ japan ) { country = "Japan"  ; type = rexp_matched(1); }
else { country = "Other" }
') %>% head(10)
```


* (OUTPUT)

	
|   | power | country | type
----|-------|---------|-----
| 1 | low   | Japan   | Mazda	
| 2 | low   | Japan   | Mazda	
| 3 | low   | Japan   | Datsun	
| 4 | low   | USA     | Hornet	
| 5 | high  | USA     | Hornet	
| 6 | low   | Other   |
| 7 | high  | Other   |
| 8 | low   | Germany | Merc	
| 9 | low   | Germany | Merc	
| 10 | low  | Germany | Merc


### Example code explanation

* library(datasailr)
    + Make DataSailr package available.
* library(magrittr)
    + This is not required by DataSailr. In the above code, %>% , pipe operator, is used, and it's defined in magrittr package.
* mtcars %>% datasailr::sail(' .... 
    + The 1st argument of datasailr::sail is dataframe. In this case, %>% passes dataframe to the 1st argument.
    + The 2nd argument of datasailr::sail is DataSailr code.
* if( hp > 145 ){ ....
    + if-else statement. 
* power = "high" 
    + assign "high" to power column.
* germany = re/(^Merc|^Porsche|^Volvo)/
    + Regular expression literal is re/pattern/ .
* if ( \_rowname\_ =~ germany ){ ....
    + string =~ regular expression executes regular expression matching.
    + \_rowname\_ column is one of automatic variables. This holds the row names of the original R dataframe.
* rexp_matched(1)
    + Calling function of rexp_matched()
    + Extract the 1st matching group from the last regular expression matching.



## Grammar of Sailr/DataSailr script

Before describing grammar details, I need to mention that DataSailr script and Sailr script are essentially the same script. DataSailr script, script for DataSailr, is just an extended version of Sailr script(, script of libsailr). DataSailr and Sailr have the same grammar, and DataSailr just has additional built-in functions, such as push!() and discard!(). What is mentioned about Sailr script can be completely applied to DataSailr script.


Sailr script is especially intended for use of data manipulation. From the programming language view, the functionality is not enough and is not a general-purpose programming language, but you can write instructions and manipulate data in an intuitive way. For SAS(*) software users, the grammar of Sailr script is relatively easy to understand. Differences are mentioned later in this README.


(*) SAS is the world's largest privately held software company. SAS provides SAS software which is used by professional data analysts.


### Variables & Assignment operation [IMPORTANT]

* Variables in Sailr script and variables in statistics

In general-purpose programming language, variables usually mean identifiers to point to some memory or some objects. However in statistics, dataset column names are usually called variables. Sailr script follows the statistics way because it is designed not for general-purpose programming language, but is designed for processing dataset. Variables in codes correspond to the column with the same name. 

(e.g.) The following code print the value of column X.

```
print(X)
```

(e.g.) The following code assign the value of column X to column Y.

```
Y = X
```


### Types

Sailr script can deal with the following types.

1. Int
2. Double
    + Int and Double are interchangeable when needed.
3. String
    + String literal 
4. Boolean 
    + Only available within if-else conditions
5. Regular expression
    + Currently regular expressions are accepted only in literal. There is no such way to dynamically generate regular expression object.


R can handle vectors, list, S4 class objects, and so on. Among those R objects, dataframe usually consists of only vectors. The following list shows which data types are supported by Sailr. Supporting vectors of numbers and strings is enough in most of the cases of data analysis. 

* logical vector : Sailr imports TRUE as 1, and FALSE as 0.
* integer vector : Sailr deals with it as integer.
* numeric vector : Sailr deals with it as double.
* complex vector : Not supported
* character vector : Sailr deals with it as string.
* factor : Sailr deals with it as string.
    + Precisely, factor is a type called S3 class. S3 class is an R type with "class" attribute and some additional attributes (such as levels) required by the class. Internally factor is just an integer vector with these attributes. Attribute of "levels" is assumed to be CharacterVector in the current implementation.
* list : not supported.
* S3 class objects : As mentioned in factor, the base type of S3 is a basic R type. If the basic R type is supported by Sailr, the S3 type can be dealt from Sailr. However, Sailr's interpretation is not as the user's intention, but follows the internal data type. (i.e.) Factor is recognized as an integer vector.
* S4 class objects : Not supported
    + S4 objects are not supported. Those objects need to be converted to Sailr types beforehand. Moreover, S4 objects are only stored in list, and list will not be supported in any case.


| Column of R data.frame |  Sailr    | 
-------------------------|-----------------
| Integer Vector         | Int           |
| Double (Real) Vector   | Double        | 
| Character Vector       | String        |
| Boolean Vector         | Int (0/1)     |
| Factor                 | String        |
| List (No plan)         | No plan to be supported |


### Arithmetic operators


* Supported

The following operators can be applied to numbers (int + double).

Only plus (+) operator can deal with strings. It can concatenate strings. 

```
+    add
-    subtract
*    multiply
/    divide
**   power
^    power
=~   regular expression matching (  )
```

* Not supported

The following operators are not supported in Sailr

```
++  // Increment operator
--  // Decrement operator
+=
-=
*=
/=
```


### if-else statement

The following syntax is accepted. The former one is more familiar to programmers, though the latter is easier to read and may be better for data scientists.

```
if(bmi >= 40){
    weight_level = .
}else if( bmi >= 35 ){ 
    weight_level = .
}else if( bmi >= 30 ){
    weight_level = 3 
}else if( bmi >= 25 ){
    weight_level = 2
}else if( bmi >= 20 ){
    weight_level = 1
}else{
    weight_level = .
}
```

```
if(bmi >= 40){ weight_level = . } 
else if( bmi >= 35 ){ weight_level = . } 
else if( bmi >= 30 ){ weight_level = 3 } 
else if( bmi >= 25 ){ weight_level = 2 }
else if( bmi >= 20 ){ weight_level = 1 }
else { weight_level = . }
```


### Built-in functions

The following is the list of built-in functions.

```
print( str1, str2 ... )
num_to_str( num ) 
str_strip( str )
str_lstrip( str ) 
str_rstrip( str )
str_concat( str1, str2 ... ) // numbers are also accepted as input.
str_repeat( str , num )
str_subset( str, num, num )  // index starts from one. UTF8 compatible.
str_to_num( str )
rexp_matched( num )  // back reference
date_ymd( year, month, day )  // convert a combination of year, month and day into numbers that is a day from Jan 1st 1970.
date_ym_weekday_nth( year, month, weekday, nth )  // weekday should be "Sun", "Mon" ... 
date_add_n_years( unix_date, years )
date_add_n_months( unix_date, months )
date_add_n_days( unix_date, days )
date_format( unix_date, str_format )  // This format should follow C++'s std::chrono::format. "%m/%d/%y" or "%Y-%m-%d" is popular.
```

Currently, users cannot implement functions of Sailr script by themselves. 

If you want to implement your own function, you need to modify libsailr or libsailr's external function mechanism.

The libsailr C API is not mature. The interface for users is not organized. Please feel free to contact the author if you want your own function.



### Support for special numbers

#### Missing value support

For numbers (integer or double), single dot (.) represents missing value in code. Internally missing value is defined as -nan in C (which is generated by sqrt(-1)). See libsailr's node.c file and new_node_nan_double () function. ) Any calculation with this value always results in -nan.

For string, empty string ("") represents missing string.



#### Missing value (-nan) for if-condition

Note that in vanilla R, calculation with missing value returns missing value, and missing values act like TRUE in logical vector. In vanilla R, filtering of vectors and dataframes is done using logical vectors. If missing values are treated like TRUE, unintended elements or rows that have missing values are extracted. For example, you are calculating BMI (body mass index) from body weight and height. One person has a missing for body weight. His/her BMI will be calculated as missing value. You would like to categorize this person as "unknown BMI" category, then missingness should be checked first and these people should be categorized first. Otherwise, missing values in logical vector works like TRUE, so these people are categorized into some BMI categories, such as "high BMI" or "low BMI".

In Sailr, on the other hand, comparison operators with missing values return false except that missing is compared with missing.

```
library(datasailr)

col1 = c(1.7, 1.5 , 1.5 , 1.65 ,  1.5)
col2 = c(50 , 60  , 80  , NA   ,  100)
df = data.frame(height = col1, bw = col2)

code ='
bmi = bw / (height ^ 2)

if(bmi >= 40){ overweight = 5 } 
else if( bmi >= 35 ){ overweight = 4 } 
else if( bmi >= 30 ){ overweight = 3 } 
else if( bmi >= 25 ){ overweight = 2 }
else if( bmi >= 20 ){ overweight = 1 }
else if( bmi >= 0  ){ overweight = 0 }
else { overweight = . }
'

new_df = datasailr::sail( df, code , fullData = T);
new_df
```

* (OUTPUT)

```
  height  bw      bmi overweight
1   1.70  50 17.30104          0
2   1.50  60 26.66667          2
3   1.50  80 35.55556          4
4   1.65  NA       NA        NaN
5   1.50 100 44.44444          5
```


#### Infinite numbers

Infinite numbers are also supported. Internally this is implemented as Inf in C. The behavior is same as C.

(ref.) NAN and infinity in C Standard ( https://www.gnu.org/software/libc/manual/html_node/Infinity-and-NaN.html )
(ref.) This support seems to require at least C99. ( https://stackoverflow.com/questions/6235847/how-to-generate-nan-infinity-and-infinity-in-ansi-c )

```
x = 10
y = 0
z = -10

a = x / y /* INF */
b = z / y /* -INF */
c = (-1) ** (-1/2) /* sqrt(-1) => -nan */

print("a is ", a , "\n")
print("b is ", b , "\n")
print("c is ", c , "\n")

if( a >= 0 ){
  print("a is zero or more than zero. \n")
}else if( a < 0){
  print("a is less than zero. \n")
}else{
  print("a is not a number. \n")
}

if( b >= 0 ){
  print("b is zero or more than zero. \n")
}else if( b < 0){
  print("b is less than zero. \n")
}else{
  print("b is not a number. \n")
}

if( c >= 0 ){
  print("c is zero or more than zero. \n")
}else if(c < 0){
  print("c is less than zero. \n")
}else if(c == .){
  print("c is not a number. \n")
}
```

* OUTPUT

```
a is inf
b is -inf
c is -nan
a is zero or more than zero. 
b is less than zero. 
c is not a number. 
```


### UTF8 support and encodings

UTF8 encoding is strongly encouraged. The recommended way is to have dataframe as UTF8, and also have your code as UTF8. ASCII or latin1 is compatible with UTF8, so they must also work properly. (Your terminal encoding also need to be UTF8 for properly printing out UTF8 strings.)
 
In Sailr (libsailr), strings are stored just as a sequence of bytes. So even if you use other encodings, just copying and concatenating strings must work fine. Problems must happen when your source code and dataframe do not have the same encoding. Encoding of source code affects the string objects that are generated during parsing phase (=string objects that are generated before running code), dataframe encoding affects the string that are accessed via variables. 

For functions that process strings, UFF8-CPP library is used internally. ( UTF8-CPP:UTF-8 with C++ in a Portable Way https://github.com/nemtrif/utfcpp )

```
greeting = "Hello World"  // Only ascii string
str_len(greeting)  // 11
str_subset(1,5)  // Hello


greeting_jp = "こんにちは! 世界"  // Mixture of single byte string and multi byte strings.
str_len(greeting_jp)     // 8
str_subset(1,5)    // こんにちは
str_subset(8,9)    // 世界

```

### Regular expression support

Currently, the regular expression objects are not generated during run time but only in parsing phase. In other words, regular expressions can be generated only in regular expression literal. Regular expression syntax is re/pattern/ , which start with re/ and end with /. 

The regular expression engine used internally is Onigmo ( https://github.com/k-takata/Onigmo ). The source code must be written in UTF8, because regular expression object is programmed to assume UTF8 for its input (in libsailr).

As the following code shows, backreference (outside of the pattern) can be used via regexp_matched() function.

```
germany = re/(^Merc|^Porsche|^Volvo)/

if ( _rowname_ =~ germany ) {
    country = "Germany" ;
    type = rexp_matched(1);
}
```


### Date support

In Sailr(libsair), there are no specific types for dates, and dates are stored as just integers in Sailr. The number represents the day from Jan 1st 1970, which is the same as UNIX date. (Be careful that SAS software also store date information as numbers, but their starting date is 1/1/1960. https://support.sas.com/resources/papers/proceedings12/244-2012.pdf )

Internally for date calculation, date library is used ( "date.h" is a header-only library which builds upon <chrono>. https://github.com/HowardHinnant/date ).

```
date_ymd( year, month, day )
date_ym_weekday_nth( year, month, weekday, nth )  // weekday should be "Sun", "Mon" ... 
date_add_n_years( unix_date, years )
date_add_n_months( unix_date, months )
date_add_n_days( unix_date, days )
date_format( unix_date, str_format )  // This format should follow C++'s std::chrono::format. "%m/%d/%y" or "%Y-%m-%d" is popular.
```

### DataSailr specific functions

As already mentioned, DataSailr script is an extended version of Sailr script, and DataSailr has additional built-in functions to Sailr. Functions of Sailr script only conduct calculation within each row because that is what libsailr does. However, there are cases where users need to discard rows or output multiple rows from one row. DataSailr implements additional these functions using libsailr's external function mechanism. Currently, push!() and discard!() functions are provided using this mechanism. These functions can change the number of rows of input dataset, unlike libsailr's original built-in functions.


* push!() function

push!() function changes dataframe structure, for which reason it is not (cannot be) implemented as a libsailr internal function. What push!() function does is to push the current variable values onto the result dataframe. Even after push!() function is executed, the script execution continues on the same input row. This results in creating multiple rows from one input row.

As the following example shows, it is useful to convert wide format dataframe into long format.

```
wide_df = data.frame(
  subj = c("Tom", "Mary", "Jack"),
  t0 = c( 50, 42, 80),
  t1 = c( 48, 42, 75),
  t2 = c( 46, 44, 72),
  t3 = c( 42, 42, 73)
)

code = "
  OriRowNum = _n_
  subj = subj

  time = 0
  bw = t0
  push!()

  time = 1
  bw = t1 
  push!()

  time = 2
  bw = t2
  push!()

  time = 3
  bw = t3
"

wide_df

datasailr::sail(wide_df , code = code)
```


```
> wide_df

  subj t0 t1 t2 t3
1  Tom 50 48 46 42
2 Mary 42 42 44 42
3 Jack 80 75 72 73

> datasailr::sail(wide_df , code = code)

   subj OriRowNum time bw
1  Tom          1    0 50
2  Tom          1    1 48
3  Tom          1    2 46
4  Tom          1    3 42
5  Mary         2    0 42
6  Mary         2    1 42
7  Mary         2    2 44
8  Mary         2    3 42
9  Jack         3    0 80
10 Jack         3    1 75
11 Jack         3    2 72
12 Jack         3    3 73
```


* discard!() function

discard!() function drops the current row from the result dataframe. A common usage of this function is to filter out specific rows using if condition.

```
data(mtcars)

datasailr::sail(mtcars, code='
n = _n_
cyl = cyl
if(cyl != 4){
  discard!(); // Filter out rows that do not have 4 for cyl. i.e. Keep rows with 4 for cyl.
}
')
```


## For SAS software users

List of major differences between DataSailr and DATA Step in SAS software.

1. DataSailr if-else statements use curly brackets { }. SAS software uses if-then-else style.
2. DataSailr if-else curly brackets can hold multiple statements. SAS software needs to use do statement for multiple statements. i.e. if-then-do-end style. 
3. OUTPUT statement is not supported in DataSailr yet.
4. RETAIN statement is not supported and there is no plan to support it in the future.
5. The default character encoding of DataSailr is UTF8. 
6. Not only semicolon but also new line means the end of each statement in DataSailr. In SAS software, semicolons are always required.
7. (CAUTION) Date starts from Jan. 1st 1970, which is same as UNIX date. SAS software also stores date as number that is a day from 1/1/1960. Meaning NEVER DIRECTLY USE SAS NUMBER FOR DATES in DataSailr(libsailr).
8. Column name does not have label (In SAS software, dataset column can have a description called label.)



## For dplyr users

DataSailr does not compete with dplyr. DataSailr focuses on row by row manipulation, and dplyr has more functionalities about the whole dataframe manipulation (e.g. arrange(), select(), group_by() & summarize()).

DataSailr's special feature is that you can write multiple row level manipulations in one code, though dplyr enables it with a chain of functions.


|                        |     DataSailr                  |     dplyr            |
-------------------------|--------------------------------|------------------------ 
| How to manipulate data | Apply a single DataSailr code  | Apply multiple functions using (%>%) |
| Create new column      | assign value to new variable   | mutate()             |
| Keep some columns      | (Not implemented yet)          | select()             |
| Keep some rows         | discard!() drops rows          | filter()             |
| Summarize columns      | No use for this purpose        | summarize()          |
| Sort rows              | No use for this purpose        | arrange()            |
| Regular expression     | Built-in                       | Partially available with another R package |
| Available functions    | Can call only DataSailr functions  | Can call R functions |
| Convert wide to long format | push!() function          | (not dplyr but reshape2 package) |
| Convert long to wide format | (Not implemented yet)     | (not dplyr but reshape2 package) |



## For developers

### Architecture summary

The core engine of this package is libsailr. Libsailr takes Sailr script and does arithmetic calculations and string/character manipulations. This R package wraps libsair, and passes values of each row to the libsailr library. The results of each row will be returned as each row of new dataframe.

DataSailr internals are described in the official website.

## Contact

Your feedback is welcome. 

Maintainer: Toshi Umehara <toshi@niceume.com>


