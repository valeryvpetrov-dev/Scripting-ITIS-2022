#!/bin/bash

declare -i step=0
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
		i_rand=$(( $RANDOM % num_cells ))
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
			if (( num == 0 )); then
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

function check_win () {
	for ((i=0;i<$(( num_cells - 1 ));i++)) do
		if (( ${matrix[$i]} != $(( i + 1 )) )); then
			break
		fi
	done
	if (( i == $(( num_cells - 1 )) )); then
		echo "Вы собрали головоломку за $step ходов."
		print_matrix
		exit 0
	fi
}

init_matrix
while :
do
	check_win
	step+=1
	echo "Ход № ${step}"
	print_matrix
	read -p "Ваш ход (q - выход):" answer
	if [[ "$answer" =~ ^[0-9]+$ ]]; then
		answer_int=$(( $answer + 0 ))
		# TODO input validarion
		if ((1<=answer_int && answer_int<=15)); then
			zero_matrix_i=$(( zero_line_i / num_rows ))
			zero_matrix_j=$(( zero_line_i % num_columns ))

			zero_left_i=$(( zero_line_i - 1 ))
			zero_right_i=$(( zero_line_i + 1 ))
			zero_top_i=$(( zero_line_i - num_columns ))
			zero_bottom_i=$(( zero_line_i + num_columns ))

			availables=(-1 -1 -1 -1)
			# left side
			if (( zero_matrix_j > 0 )); then
				if (( ${matrix[$zero_left_i]} == answer_int )); then
					matrix[$zero_line_i]=$answer_int
					matrix[$zero_left_i]=0
					zero_line_i=$zero_left_i
					continue
				else
					availables[0]=${matrix[$zero_left_i]}
				fi
			fi
			# right side
			if (( zero_matrix_j < $(( num_columns - 1 )) )); then
				if (( ${matrix[$zero_right_i]} == answer_int )); then
					matrix[$zero_line_i]=$answer_int
					matrix[$zero_right_i]=0
					zero_line_i=$zero_right_i
					continue
				else
					availables[1]=${matrix[$zero_right_i]}
				fi
			fi
			# top side
			if (( zero_matrix_i > 0 )); then
				if (( ${matrix[$zero_top_i]} == answer_int )); then
					matrix[$zero_line_i]=$answer_int
					matrix[$zero_top_i]=0
					zero_line_i=$zero_top_i
					continue
				else
					availables[2]=${matrix[$zero_top_i]}
				fi
			fi
			# bottom side
			if (( zero_matrix_i < $(( num_rows - 1 )) )); then
				if (( ${matrix[$zero_bottom_i]} == answer_int )); then
					matrix[$zero_line_i]=$answer_int
					matrix[$zero_bottom_i]=0
					zero_line_i=$zero_bottom_i
					continue
				else
					availables[3]=${matrix[$zero_bottom_i]}
				fi
			fi
			echo "Неверный ход!"
			echo "Невозможно костяшку $answer_int передвинуть на пустую ячейку."
			availables_len=${#availables[@]}
			echo -n "Можно выбрать: "
			for (( i=0; i<$availables_len; i++ )); do
				available=${availables[$i]}
				if (( available != -1 )); then
					if (( i == $(( availables_len - 1)) )); then
						echo "$available"
					else
						echo -n "$available, "
					fi
				fi
			done
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
done