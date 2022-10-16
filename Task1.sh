RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

declare -i step=1
declare -i secret=0
declare -i hit=0
declare -i miss=0
declare -i total=0
declare -a prev_secrets

while :
do
	echo "Step: ${step}"
	read -p "Please enter number from 0 to 9 (q - quit): " guess
	case "${guess}" in
	    [0-9])
			# Generate current secret
			secret=$(( ${RANDOM} % 10 ))
			# Check hit or miss
			if [[ "${guess}" == "${secret}" ]]
			    then
			    	hit+=1
			        echo -n "Hit! "
			        secret_string="${GREEN}${secret}${RESET}"
			    else
			    	miss+=1
			        echo -n "Miss! "
			        secret_string="${RED}${secret}${RESET}"
			fi
			echo "My number: ${secret}"

			# Calculate statistics
			total=$(( hit + miss ))
			let hit_percent=hit*100/total
			let miss_percent=100-hit_percent
			echo "Hit: ${hit_percent}%" "Miss: ${miss_percent}%"

			# Print previous secrects
			prev_secrets+=(${secret_string})
			if [ "$step" -gt "10" ]; 
			    then
			        numbers_count=10
			    else
			        numbers_count=step
			fi
			echo -e "Numbers: ${prev_secrets[@]: -${numbers_count}}"
	    ;;
	    q)
			echo "Bye!"
			exit 0
	    ;;
	    *)
	        echo "Invalid input. Please repeat"
	    ;;
	esac
	step+=1
done