#!/bin/bash

declare -i step=1
declare -i zero_line_i=0
declare -a matrix
num_rows=4
num_columns=4
num_cells=$((num_rows*num_columns))

function init_matrix () {
	for ((i=0;i<$num_rows;i++)) do
		for ((j=0;j<$num_columns;j++)) do
			value=$(( i*num_columns + j ))
			matrix+=($value)
		done
	done
	shuffle_matrix
}

function shuffle_matrix () {
	for ((i=0;i<$num_cells;i++)) do
		i_rand=$(( $RANDOM % 16 ))
		value_i=${matrix[$i]}
		value_i_rand=${matrix[$i_rand]}
		matrix[$i]=$value_i_rand
		matrix[$i_rand]=$value_i
	done
	for ((i=0;i<$num_cells;i++)) do
		if [ "${matrix[$i]}" -eq 0 ]; then
			zero_line_i=$i
		fi
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

init_matrix
while :
do
	echo "Ход № ${step}"
	print_matrix
	read -p "Ваш ход (q - выход):" answer
	if [[ "$answer" =~ ^[0-9]+$ ]]; then
		answer_int=$(( $answer + 0 ))
		if ((1<=answer_int && answer_int<=15)); then
			zero_matrix_i=$(( zero_line_i / num_rows ))
			zero_matrix_j=$(( zero_line_i % num_columns ))
			echo "answer_int=$answer_int"
			echo "zero_matrix_i=$zero_matrix_i"
			echo "zero_matrix_j=$zero_matrix_j"

			zero_left_i=$(( zero_line_i - 1 ))
			zero_right_i=$(( zero_line_i + 1 ))
			zero_top_i=$(( zero_line_i - num_columns ))
			zero_bottom_i=$(( zero_line_i + num_columns ))

			# left side
			if (( zero_matrix_j > 0 )); then
				if (( ${matrix[$zero_left_i]} == answer_int )); then
					echo "left!"
				fi
			fi
			# right side
			if (( zero_matrix_j < $(( num_columns - 1 )) )); then
				if (( ${matrix[$zero_right_i]} == answer_int )); then
					echo "right!"
				fi
			fi
			# top side
			if (( zero_matrix_i > 0 )); then
				if (( ${matrix[$zero_top_i]} == answer_int )); then
					echo "top!"
				fi
			fi
			# bottom side
			if (( zero_matrix_i < $(( num_rows - 1 )) )); then
				if (( ${matrix[$zero_bottom_i]} == answer_int )); then
					echo "bottom!"
				fi
			fi
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