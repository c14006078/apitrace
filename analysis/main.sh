#!/bin/sh
#
# PROGRAM:
#			Analysis the apitrace trace file and reduce the repeat binary file ( include pointer arrary and texture )
#
#	Authr:
#			kensome
#
#	Usage:
#			sh main.sh [output_dir] [file1.trace file2.trace ...]
#
#	Dependence:
#
#

NARG=$#

# Check the argument input, argument start after main.sh
# 	WARNING: you should execute it by sh because of exit(), sh will create a new thread to do it
#			TODO: More Robust Error Detection
echo "argument number is $NARG"
if [ $NARG -lt 2 ];then
	echo "argument number is $NARG"
	echo "Error Input: sh main.sh [output_dir] [file1.trace file2.trace ...]"
	exit 0
fi

LOCAL_PATH=$PWD
APITRACE_DIR=$PWD/build
OUT_DIR=${1}
TRACE_FILE=

# Create Dir: -p will disable the error directory is already existed
#		TODO: `file` can detect exist or not
mkdir -p $OUT_DIR

##FUNCTION##

#	fexist(): check the file exist or not
fexist()
{
	if [ -f $1 ];then
			echo "$1 exist"
	else
		echo "$1 is not existed, maybe you should input the absolution path"
		exit 0
	fi
}

#	decho(): debug variable name and variable value
decho()
{
	echo "$1 = ${!1}"
}

#	Check the input trace file exit or not
#
#		FIXME: Bad substitution occur on ${!1} when we use the `sh` to execute it, but we success when using `bash`
FILE_INDEX=2
while [ $FILE_INDEX -lt $NARG ]
do
	FILE=$PWD/${!FILE_INDEX}
	decho FILE
	fexist $FILE
	TRACE_FILE="$TRACE_FILE $FILE"
	FILE_INDEX=$(($FILE_INDEX + 1))
	decho FILE_INDEX
done
decho TRACE_FILE

# Analysis the input trace file


##FUNCTION##

#	fexist(): check the file exist or not
fexist()
{
	if [ -f $1 ];then
			echo "$1 exist"
	else
		echo "$1 is not existed, maybe you should input the absolution path"
		exit 0
	fi
}

#	decho(): debug variable name and variable value
decho()
{
	echo "$1 = ${!1}"
}
