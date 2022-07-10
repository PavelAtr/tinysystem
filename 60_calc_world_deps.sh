#!/bin/bash

WD=$(dirname $0)
cd $WD
export CWD=$(pwd)

. $CWD/Application.cfg

cat $CWD/_packages/$ABI/*/$APP_PATH/var/lib/packages/*.deps > deps_$ABI.txt
