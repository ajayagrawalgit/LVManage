#!/bin/bash

echo "What Operation you need to Perform ?"
echo "1. Create a new LVM."
echo "2. Extend the size of an Existing LVM."
echo "3. Reduce the size of an Existing LVM."
echo "4. Rename an Existing LVM."
echo "5. Delete an Existing LVM."

read -p "Please enter your choice (1,2,3,4,5) -> " VAR_FUNCHOICE

case $VAR_FUNCHOICE in
	1)
		sudo ./FunctionCalls/LVCreate.sh
	;;

	5)
		sudo ./FunctionCalls/DEL_LVM.sh
	;;


	2)
		sudo ./FunctionCalls/LVExtend.sh
	;;

	3)
		sudo ./FunctionCalls/LVReduce.sh
	;;

	4)
		sudo ./FunctionCalls/LVRename.sh
	;;


esac
