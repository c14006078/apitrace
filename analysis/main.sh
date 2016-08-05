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
#	HISTORY:
#		2016/8/5 First release: Dump the calls with binary file and bin.
#

###  FUNCTION  #####################################################
#																																	 #
#	NOTICE: FUNCTION should put before the calls										 #
#																																	 #
####################################################################

#	fexist(): check the file exist or not
fexist()
{
	CHECK=$1
	if [ -f $CHECK ];then
			echo "$CHECK exist"
	else
		echo "$CHECK is not existed, maybe you should input the absolution path"
		exit 0
	fi
}

#	decho(): debug variable name and variable value
decho()
{
	echo "$1 = ${!1}"
}

# err_exit(): show error and exit
err_exit()
{
	ERR=$1
	echo "Error: on $1"
	exit 0
}

# get_bin(): get the only bin file on select directory
get_bin()
{
	T_DIR_B=$1
	ls $T_DIR_B | grep -E '*.bin'
}

# dir_size(): output the directory size
dir_size()
{
	T_DIR_U=$1
	du -h $T_DIR | awk '{print $1}'
}

# analy_inst(): stat the instruction species
analy_inst()
{
	INST_CALLS=$1
	echo "$1 instruction stat"
	sort -k 2 $INST_CALLS | awk '{print $2}' | uniq -c | sort -k 1
}

# dump_bin(): dump binary filea
#		FIXME: Make sure the condition OR correct
dump_bin()
{
	if [ "-n "${APITRACE+x}"" -o "-n "${OUT_DIR+x}"" -o "-n "${FILE+x}"" ];then
		mkdir -p $2
		cd $2
		$APITRACE dump --blobs $1 | grep blob > $OUT_DIR/$FILE.calls.txt
		analy_inst $OUT_DIR/$FILE.calls.txt
		cd -
	else
		err_exit dump_bin
	fi
}

# tnow(): return the time now
tnow()
{
	date +%s
}

# interval(): count the time 
interval()
{
	time=$((end - start))
	echo "$1 take $time s"
}

############################################################################


###  Variable Define  ###
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

if [ -n "${APITRACE_DIR+x}" ];then
	decho APITRACE_DIR
else
	APITRACE_DIR=$PWD
	decho APITRACE_DIR
fi

APITRACE_BUILD=$APITRACE_DIR/build
APITRACE=$APITRACE_BUILD/apitrace
OUT_DIR=$LOCAL_PATH/${1}
TRACE_FILES=
BIN_DIRS=
BIN_FILES=
ORG_SIZE=


# Create Dir: -p will disable the error directory is already existed
#		TODO: `file` can detect exist or not
mkdir -p $OUT_DIR

#	Check the input trace file exit or not
#
#		FIXME: Bad substitution occur on ${!1} when we use the `sh` to execute it, but we success when using `bash`
FILE_INDEX=2
while [ $FILE_INDEX -le $NARG ]
do
	FILE_PATH=$PWD/${!FILE_INDEX}
	FILE=$(basename ${FILE_PATH})
	decho FILE
	fexist $FILE_PATH
	BIN_DIR=$OUT_DIR/${FILE}_bin
	start=$(tnow)
	dump_bin $FILE_PATH $BIN_DIR
	end=$(tnow)
	interval "dump_bin $FILE"
	TRACE_FILES="$TRACE_FILES $FILE"
	SIZE=$(dir_size $BIN_DIR)
	ORG_SIZE="$ORG_SIZE $SIZE"
	BIN_FILES="$BIN_FILES $(get_bin $BIN_DIR)"
	FILE_INDEX=$(($FILE_INDEX + 1))
	decho FILE_INDEX
done
decho TRACE_FILES
decho ORG_SIZE

# Analysis the input trace file

md5sum $BIN_FILES | sort -k 1 > bin2md5.txt
