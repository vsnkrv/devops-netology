array=(192.168.0.1 173.194.222.113 87.250.250.242)
a=5
while (($a > 0))
do
	for i in ${array[@]}
	do
		nc -zvw3 $i 80 2>>log
		if (($? != 0))
		then
			echo $i > error
			exit
		fi
	done
	let "a -= 1"
done
