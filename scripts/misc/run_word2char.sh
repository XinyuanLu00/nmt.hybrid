#!/bin/bash

# Author: Thang Luong

if [[ $# -gt 7 || $# -lt 7 ]]
then
    echo "`basename $0` trainPrefix devPrefix testPrefix src tgt ngram outDir"
    exit
fi

trainPrefix=$1
devPrefix=$2
testPrefix=$3
src=$4
tgt=$5
n=$6
outDir=$7

VERBOSE=1
function execute_check {
  file=$1 
  cmd=$2
  
  if [[ -f $file || -d $file ]]; then
    echo ""
    echo "! File/directory $file exists. Skip."
  else
    echo ""
    if [ $VERBOSE -eq 1 ]; then
      echo "# Executing: $cmd"
    fi
    
    eval $cmd
  fi
}

execute_check "" "mkdir -p $outDir"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

devBase=`basename $devPrefix`
execute_check "$devPrefix.${n}gram.$src" "python $SCRIPT_DIR/word2char.py $n $devPrefix.$src $devPrefix.${n}gram.$src"
execute_check "$devPrefix.${n}gram.$tgt" "python $SCRIPT_DIR/word2char.py $n $devPrefix.$tgt $devPrefix.${n}gram.$tgt"

testBase=`basename $testPrefix`
execute_check "$testPrefix.${n}gram.$src" "python $SCRIPT_DIR/word2char.py $n $testPrefix.$src $testPrefix.${n}gram.$src"
execute_check "$testPrefix.${n}gram.$tgt" "python $SCRIPT_DIR/word2char.py $n $testPrefix.$tgt $testPrefix.${n}gram.$tgt"

trainBase=`basename $trainPrefix`
execute_check "$trainPrefix.${n}gram.$src" "python $SCRIPT_DIR/word2char.py $n $trainPrefix.$src $trainPrefix.${n}gram.$src"
execute_check "$trainPrefix.${n}gram.$tgt" "python $SCRIPT_DIR/word2char.py $n $trainPrefix.$tgt $trainPrefix.${n}gram.$tgt"


