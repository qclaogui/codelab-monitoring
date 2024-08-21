#!/usr/bin/env bash

# Taken from https://gist.github.com/soniah/c11633551c6dd84dab66cad20453cfa8
# remove all blank lines in go 'imports' statements, as goimports doesn't do it.


# The BSD version of the sed command in MacOS doesn't work with this script.
# Please install gnu-sed via `brew install gnu-sed`.
# The gsed command becomes available then.
SED="sed"
if command -v gsed &> /dev/null ; then
  SED="gsed"
fi

if [ $# != 1 ] ; then
  echo "usage: $0 <filename>"
  exit 1
fi

${SED} -i '
  /^import/,/)/ {
    /^$/ d
  }
' $1
