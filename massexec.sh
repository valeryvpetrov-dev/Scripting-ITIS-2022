#!/bin/bash

function usage() {
	echo "massexec.sh [--path dirpath] [--mask mask] [--number number] command"
	exit 1
}

# Parse input args
while :; do
    case $1 in
        --path) path=$2 ;;
        --mask) mask=$2 ;;
        --number) number=$2 ;;
        *) 
			if (( $# == 1 )); then
				command=$1
				break
			else
				usage
			fi
		;;
    esac
    shift; shift
done

# Set defaults if arg was not passed
if [ -z "$path" ]; then
	path=$(pwd)
fi
if [ -z "$mask" ]; then
	mask="*"
fi
if [ -z "$number" ]; then
	number=$(nproc)
fi

echo "path=$path"
echo "mask=$mask"
echo "number=$number"
echo "command=$command"