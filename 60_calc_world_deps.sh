#!/bin/bash

WD=$(dirname $0)
cd $WD
export CWD=$(pwd)

. $CWD/Application.cfg

for ABI in $ABIs
do
    cat $CWD/_packages/$ABI/*/$APP_PATH/var/lib/packages/*.deps > deps_$ABI.txt
done