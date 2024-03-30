#!/bin/ksh

USAGE="usage: which [-a] name ..."
SHOW_ALL=false
while getopts ":a" opt; do
	case ${opt} in
		a)
			SHOW_ALL=true
			;;
		?)
	        >&2 echo "which: unknown option -- ${OPTARG}"
            >&2 echo $USAGE
            exit 1
			;;
	esac
done

ARGS=$#
TOTAL_NOT_FOUND=0
EXIT_CODE=0
FOUND=false
DEF_PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin"

function find_in_path {
		if [ -f $1 ] && [ -x $1 ]; then
			echo $1
            return 1
		fi
        return 0
}

shift $(( $OPTIND - 1 ))

if [ $# -eq 0 ]; then
	>&2 echo $USAGE
    exit 1
fi


if [ ${#PATH} -eq 0 ]; then
	PATH=$DEF_PATH
	# echo $PATH
fi

while [ $# -ne 0 ]; do
	IFS=':'
	MATCH=$(echo $1 | cut -c 1-1)
	if [ $MATCH = "/" ]; then
        find_in_path $1 
        if [ $? -eq 1 ]; then
			FOUND=true
        fi
	else
		for path in $PATH; do
			if [ ${#path} -eq 0 ]; then
				path=.
				echo $path
			fi
			tmp=$path/$1
            find_in_path $tmp
			if [ $? -eq 1 ]; then
				FOUND=true
				if [ $SHOW_ALL = false ]; then
					break
				fi
			fi
		done
	fi
	if [ $FOUND = false ]; then
	    >&2 echo "which: $1: Command not found."
		TOTAL_NOT_FOUND=$(( $TOTAL_NOT_FOUND + 1 ))
		RETURN_CODE=1
	fi
	
	FOUND=false
	shift
done
if [ $ARGS -eq $TOTAL_NOT_FOUND ]; then
	exit 2
fi
exit $RETURN_CODE

