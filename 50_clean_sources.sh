#!/bin/bash


WD=$(dirname $0)
cd $WD/sources
CWD=$(pwd)

ls -1 | while read src
do
    if [ -d $src ]
    then
        echo $src
	cd $src
	rm -r _build
	rm -r bin.v2
	rm -r __build
	make clean
	cd src && make clean
	cd $CWD
    fi
done