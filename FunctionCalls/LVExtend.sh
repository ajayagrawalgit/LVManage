#!/bin/bash

echo -e "Below are the Volume Groups present in your Linux System ->"
vgs

read -p "Enter the name of Volume group in which the LVM is configured which you want to extend -> " LVM_VG_NAME
echo -e ""
echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo -e "BELOW ARE THE LVMs CURRENTLY CONFIGURED IN YOUR SYSTEM (Sepatared by White Space) ->"

ls /dev/"$LVM_VG_NAME"

read -p "Enter the NAME of LVM you need to extend -> " VAR_LV_Name
read -p "Enter the SIZE of LVM (IN GBs/GigaBytes) -> " VAR_LV_Size

lvextend -L +"$VAR_LV_Size"G $VAR_LV_Name -r

echo -e "---------------- !!! Operation Completed !!! ----------------"