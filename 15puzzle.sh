#!/bin/bash

function init_matrix () {
	for ((i=0;i<$num_rows;i++)) do
		for ((j=0;j<$num_columns;j++)) do
			value=$(( i*num_columns + j ))
			matrix+=($value)
		done
	done
}

function print_matrix () {
	echo "+-------------------+"
	for ((i=0;i<$num_rows;i++)) do
		for ((j=0;j<$num_columns;j++)) do
			num=${matrix[$(( i*num_columns + j ))]}
			if [ $num -eq 0 ]; then
				num_repr="  "
			elif (( 0<=num && num<=9 )); then
				num_repr="${num} "
			else
				num_repr="${num}"
			fi
			echo -n "| ${num_repr} "
			if (( j==$(( num_rows - 1 )) )); then
				echo "|"
			fi
		done
		if (( 0<=i && i<$(( num_rows - 1 )) )); then
			echo "|-------------------|"
		fi
	done
	echo "+-------------------+"
}

declare -i step=1
declare -a matrix
num_rows=4
num_columns=4
nums_len=$((num_rows*num_columns))
init_matrix

while :
do
	echo "Ход № ${step}"
	print_matrix
	read -p "Ваш ход (q - выход):" answer
	if [[ "$answer" =~ ^[0-9]+$ ]]; then
		if ((1<=answer && answer<=15)); then
			echo "Ход - ${answer}"
		else
			echo "Неверный ход! Можно ввести число от 1 до 15."
		fi
	else
		if [[ "$answer" == "q" ]]; then
			echo "Пока!"
			exit 0
		else
			echo "Неверный ход! Можно ввести число от 1 до 15."
		fi
	fi
	step+=1
done