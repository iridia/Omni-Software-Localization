#!/bin/sh 

if [ $1 ]; then
	echo $1
	cd $1
fi

ojtest tests/*Test*.j
