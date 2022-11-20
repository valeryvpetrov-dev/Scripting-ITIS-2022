#!/bin/bash

declare -i step=1

while :
do
	echo "Ход № ${step}"
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