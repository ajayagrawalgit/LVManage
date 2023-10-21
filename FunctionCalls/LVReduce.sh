#!/bin/bash


echo -e "FileSystem details below -> "
df -hP

read -p "Enter the MOUNTPOINT from the above results of the LVM which you want to reduce -> " VAR_MNTPT_LVM

VAR_FS_DET=$(df -h | grep $VAR_MNTPT_LVM | awk '{print $1}')
umount $VAR_MNTPT_LVM

echo -e "Now checking the Filesystem if it has any errors ->"
echo $VAR_FS_DET
e2fsck $VAR_FS_DET

echo -e ""
echo -e ""
echo -e "##############################################"
echo -e "-------------------- NOTE --------------------"
echo -e "##############################################"
echo -e "If you see any keywords like \"CORRUPT\" or \"ERROR\" in the above output, We recommend you to stop here by pressing Ctrl+Z or Ctrl+C"
echo -e "Try remounting the Filesystem or Restarting your system to resolve these errors/warnings and then try running this utility again"
echo -e ""
echo -e "If you still want to continoue, Enter \"y\" or else Enter \"n\" to gently abort the progress"
read -p "Enter your choice here -> " VAR_LVRED_CHOICE

case $VAR_LVRED_CHOICE in
	[yY])
		echo -e "PROGRESSING WITH THE FURTHER STEPS"

		echo -e "Below are the Volume Groups present in your Linux System ->"
		vgs
		
		read -p "Enter the name of Volume group in which the LVM is configured which you want to reduce -> " LVM_VG_NAME
		echo -e ""
		echo -e "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
		echo -e "BELOW ARE THE LVMs CURRENTLY CONFIGURED IN YOUR SYSTEM (Sepatared by White Space) ->"
		ls /dev/"$LVM_VG_NAME"

		read -p "Enter the NAME of LVM you need to Reduce size for -> " VAR_LV_Name
		read -p "Enter the amount of space you need to REDUCE from $VAR_LV_Name (IN GBs/GigaBytes) -> " VAR_LV_Size
		echo -e ""
		echo -e "REDUCING THE SIZE OF $VAR_LV_Name now"
		lvreduce -L -"$VAR_LV_Size"G $VAR_FS_DET -r

		echo -e "Mounting the FileSystem back ->"
		mount $VAR_FS_DET
		echo -e "$VAR_FS_DET has been Mounted. Please check from the results below ->"
		df -hP
	;;

	[nN])
		echo -e "--- Mounting $VAR_MNTPT_LVM back now ---"
		mount $VAR_MNTPT_LVM
		echo -e "$VAR_MNTPT_LVM has been mounted"
	;;

	*)
		echo -e "########################"
		echo -e "!!! INVALID CHOICE !!!"
		echo -e "RE-RUN THE SCRIPT"
		echo -e "########################"
	;;

esac

echo -e "---------------- !!! Operation Completed !!! ----------------"