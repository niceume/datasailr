# autoconf setting 

AC_PREREQ([2.69])
AC_INIT([datasailr], 0.8.3, toshi@niceume.com)
AC_CONFIG_SRCDIR([src/Makevars.in])

# Check R_HOME
echo "R_HOME is set to ${R_HOME}"
if test -z "${R_HOME}"; then
  echo "could not determine R_HOME"
  exit 1
fi

# R headers
r_include_path=`"${R_HOME}/bin/Rscript" -e 'cat(R.home("include"))'`
add_r_include_path="-I${r_include_path} "

# C++
CXX11=`"${R_HOME}/bin/R" CMD config CXX11`
  if test -z "$CXX11"; then
  AC_MSG_ERROR([No C++11 compiler is available])
fi
# CXX11STD=`"${R_HOME}/bin/R" CMD config CXX11STD`
# CXX="${CXX11} ${CXX11STD}"
# CXXFLAGS=`"${R_HOME}/bin/R" CMD config CXX11FLAGS`
AC_LANG(C++)
AC_REQUIRE_CPP
AC_PROG_CXX

# C
CC=`"${R_HOME}/bin/R" CMD config CC`
CPICFLAGS=`"${R_HOME}/bin/R" CMD config CPICFLAGS`
CFLAGS=`"${R_HOME}/bin/R" CMD config CFLAGS`
CPPFLAGS=`"${R_HOME}/bin/R" CMD config CPPFLAGS`
AC_LANG(C)
AC_REQUIRE_CPP
AC_PROG_CC

# Make
MAKE=`"${R_HOME}/bin/R" CMD config MAKE`

# compile Attributes for rcpp
sh ./exec/compileAttr.sh

# set default values

[onigmo_include_path=""]
[onigmo_lib_path=""]
[add_onigmo_include_path=""]
[add_onigmo_lib_path=""]
[which_onigmo="PACKAGE"]  # "PACKAGE", "SYTEM", "USER"

# To pass the following options to R CMD, --configure-args.
# --configure-args='--with-user-onigmo=/ABSOLUTE/PATH/TO/ONIGMO/BUILD/DIR/'
# allow for override
AC_ARG_WITH([user-onigmo],
            AC_HELP_STRING([--with-user-onigmo=/ABSOLUTE/PATH/TO/ONIGMO/BUILD/DIR/],
                           [absolute path to the directory where include and lib directories exist.]),
            [
             onigmo_include_path="${with_user_onigmo}/include"
             onigmo_lib_path="${with_user_onigmo}/lib"
			 which_onigmo="USER"
            ],
            [])

AC_ARG_WITH([system-onigmo],
            AC_HELP_STRING([--with-system-onigmo],
                           [use onigmo library on the user's system]),
            [
			 which_onigmo="SYSTEM"
            ],
            [])

# I would like to find path for for include and lib of onigmo.
# set those pathes to onigmo_include_dir and onigmo_lib_dir


AS_IF( [test "$which_onigmo" = "USER"],
  [
  echo "onigmo library is looked up in the location specified. (--with-user-onigmo=PREFIX is specified for configure script)"
  echo "the onigmo library should be configured with option of CFLAGS=-fPIC"
  if test -f "${onigmo_include_path}/onigmo.h" ; then
    echo "onigmo.h header: ${onigmo_include_path}"
  else
    AC_MSG_ERROR("${onigmo_incude_path}/onigmo.h is not found.")
  fi
  if test -f "${onigmo_lib_path}/libonigmo.a" ; then
    echo "onigmo library: ${onigmo_lib_path}"
  else
    AC_MSG_ERROR("${onigmo_lib_path}/libonigmo.a is not found.")
  fi
  add_onigmo_include_path="ONIG_INCLUDE_DIR=${onigmo_include_path}"
  add_onigmo_lib_path="-L${onigmo_lib_path}"],
  [test "$which_onigmo" = "SYSTEM"],
  [
  echo "onigmo library is looked up from system libraries. (--with-system-onigmo is specified for configure script)"
  AC_CHECK_HEADERS([onigmo.h], [], [AC_MSG_ERROR(["onigmo.h is not installed on user's system."])])
  AC_SEARCH_LIBS([onig_init], [onigmo], [], [AC_MSG_ERROR(["onigmo library is not installed on user's system."])] )
  echo "The system already has onigmo header and library."],
  [test "$which_onigmo" = "PACKAGE" ],
  [
  echo "onigmo library is looked up in package by default (-with-***-onigmo if not specified for configure script)"
  current_path=`pwd`
  if test -f "${current_path}/src/Onigmo/autogen.sh" ; then
	eval "cd ${current_path}/src/Onigmo/; ./autogen.sh; cd  ${current_path};"
    echo "${current_path}/src/Onigmo/autogen.sh is successfully executed."
  fi
  if test -f "${current_path}/src/Onigmo/m4/lt_obsolete.m4"; then
    echo "lt_obsolete.m4 is converted to lt~obsolete.m4"
    eval "mv ${current_path}/src/Onigmo/m4/lt_obsolete.m4 ${current_path}/src/Onigmo/m4/lt~obsolete.m4"
  fi
  if test -f "${current_path}/src/Onigmo/configure" ; then
	eval "mkdir -p ${current_path}/src/Onigmo/build"
    eval 'cd ${current_path}/src/Onigmo/; ./configure --prefix=${current_path}/src/Onigmo/build CC="${CC}" CFLAGS="${CPICFLAGS} ${CFLAGS} ${CPPFLAGS}" CXX="${CXX}" ARLIB="${AR}" ARDLL="${CC}" RANLIB="${RANLIB}" RC="${RESCOMP}"; cd  ${current_path};'
    echo "${current_path}/src/Onigmo/configure is successfully executed."
    eval '${MAKE} --directory ${current_path}/src/Onigmo/'
    eval "${MAKE} install --directory ${current_path}/src/Onigmo/"
    echo "${MAKE} is successfully executed."
    eval "rm ${current_path}/src/Onigmo/build/lib/libonigmo.so"
	echo "dynamic library of onigmo is deleted"
  else
    AC_MSG_ERROR("${current_path}/src/Onigmo/configure is not found in this package.")
  fi
  add_onigmo_include_path="ONIG_INCLUDE_DIR=${current_path}/src/Onigmo/build/include"  # Relative path from sailr directory
  add_onigmo_lib_path="-L${current_path}/src/Onigmo/build/lib"
  ],
  [ AC_MSG_ERROR(["Which onigmo library to use, PACKAGE, SYSTEM or USER? "])])

# Export the following shell variables as substitute variales.
AC_SUBST([add_onigmo_include_path])
AC_SUBST([add_onigmo_lib_path])
AC_SUBST([add_r_include_path])

# create and report output
AC_CONFIG_FILES([src/Makevars])

AC_OUTPUT

# Finish message
echo
echo "Final src/Makevars"
echo
