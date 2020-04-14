# HISTORY

## Version 0.8.3

* Memory leaks fixed at various points that are pointed out after CRAN submission. (Apr.5-13 2020)
* Check whether parsing succeded or not. Function stops if the Sailr script has a wrong syntax. (Apr.14 2020)


## Version 0.8.2

* CRAN release candidate (Mar. 12 2020)
    + Biarch: true in DESCRIPTION.
        + In windows environment, if you have configure.win file, cross-compilation is not executed. This Biarch option solves it.
        + (ref) https://community.rstudio.com/t/configure-win-and-cran-submission/24684/4?fbclid=IwAR3RIMNzABwyBicz6hSPG6m1hmurtEzLGPjgMTFsjXJVkHEqBdW6wYFPd-Q
    + Package C++ main file (data_sailr_cpp_main.cpp) is updated for minor warnings.
        + Rcpp vectors' size() function returns singed int. Chage my code to be compatible with it.
    + Pass R defined makefile variables to Onigmo and libsailr makefiles
        + Makevars.win is updated.

* Minor updates (Mar. 15 2020)
    + Typos are corrected in README.md
    + Also, the following files are updated to resolve CRAN submission problems.
    + library() functions are removed.
        + These are used especially in test functions.
    + Title and description in DESCRIPTION are updated.

* Minor updates (Mar. 18 2020)
    + DESCRIPTION file is updated
    + printf() functions are enclosed within IF_DEBUG() macro in src/data_sailr_cpp_main.cpp
        + Including stdout/stderr related functions is not allowed in CRAN package.
    + bin directory is renamed to exec

* Minor updates (Mar. 22 2020)
    + DESCRIPTION file is updated. (Encoding and SystemRequirements)
    + Example script is added to package document.

* Factor class vector in dataframe is supported. They are now dealt as CharactorVector. (Apr. 1 2020)
    + In this implementation, factor levels is supposed to be CharacterVector.


## Version 0.8.1

* Beta release

## Version 0.8

* First commit
* Thanksgiving Day Release (11/28/2019)
* Christmas Update (12/25/2019) to release to the public
* Updating to submit to CRAN (01/11/2020)
    + The variables updated by this package have character types, not factors.
    + New argument, rowname, is added to sail() function.
    + libsailr is updated.
* Change following the libsailr API update. (01/19/2020)
* cleanup script is updated (2/4/2020)
* Resolve warnings for submitting CRAN (2/5/2020)
* Resolve windows compilation failures. (avoid autotools dependency during installation) (2/8/2020)
* configure.ac updates to cope with autotools nonexistent system. (2/9/2020)
* Makevars.win is updated. To build onigmo, win32/Makefile.mingw is now used. 
    + This leads to successfully build on rhub windows environment. (3/8/2020)


## Version 0.0 (Birth)

* Package skeleton was created. (11/15/2018)
   + The original name was RCppCalc, which was intended only for arithmetic calculation.

