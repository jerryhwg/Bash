#!/bin/bash

echo "Please provide a username?"
read u
echo

grep -q $u /etc/passwd # -q: silent, do not write anything to standard output
	if [ $? -eq 0 ]
	then
		echo ERROR -- User $u already exist
		echo Please choose another username
		echo
		exit 0
	fi

echo "Please provide user description?"
read d
echo

echo "Do you want to specify user ID (y/n)?"
read yn
echo

	if [ $yn == y ]
 	then
	echo "Please enter UID?"
	read uid
		grep -q $uid /etc/passwd
		if [ $? -eq 0 ]
		then
			echo ERROR -- UserID $uid already exist
			echo
			exit 0
		else
			sudo useradd $u -c "$d" -u $uid
			echo
			echo $u account has been created
		fi

	elif [ $yn == n ]
	then
		echo No worries we will assign a UID
		sudo useradd $u -c "$d"
		echo
		echo $u account has been created
	fi 
