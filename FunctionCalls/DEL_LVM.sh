#!/bin/bash

#dev/volumegroupname/LVMNAme   <PAth of mntpnt>        ext4    defaults        0 0


FUNC_ONLYLVREMOVE() {

	echo -e "####################################################################"
	echo -e "* * * * * PLEASE ENTER THE DETAILS ASKED BELOW VERY CAREFULLY (Case Sensitive) * * * * * "
	echo -e "Below is the list of LVM which are currently present in your system ->"
		lvs
	read -p "1. Enter the name of LVM from the above list which you want to remove -> " VAR_LVMREM_NAME_SHORT
	isInFile=$(cat /etc/fstab | grep -c $VAR_LVMREM_NAME_SHORT)

	if [ $isInFile -eq 0 ]
	then
		echo -e "The name which you have entered is not present under /etc/fstab entries"
		echo -e "PLEASE ENTER THE CORRECT LVM NAME (Case Sensitive)"
	else
		echo -e "---------------------------------------------------------------"
		echo -e "Below is the output of the /etc/fstab file for your LVM. It's in the format as:"
		echo "</dev/VOLUME_GROUP_NAME/LVM_NAME>	<MOUNTPOINT>	<PARTITION_TYPE>	<OPTIONS>	<DUMP> 	<PASS>"
			cat /etc/fstab | grep $VAR_LVMREM_NAME_SHORT
		echo -e "Enter the details asked below from this output"
		read -p "FULL PATH of the LVM (e.g. /dev/VOLUME_GROUP_NAME/LVM_NAME) -> " LVM_REM_FULLPATH
		read -p "FULL PATH of Mount Point -> " LVM_REM_MOUNTPT 

		echo -e "DELETING FSTAB ENTRY NOW FOR THE LVM MENTIONED"
		echo -e "Do you want to manually edit fstab file and remove the FS entry from the file yourself or want the script to do it manually ?"
		read -p "Enter \"m\" (without quotes), to edit the fstab file manually (More precise), and \"a\" to automatically remove the fstab entry using the script -> " VAR_LVMREM_FSTAB_CHOICE
			case $VAR_LVMREM_FSTAB_CHOICE in
				[mM])
					cp /etc/fstab /tmp
					mv /tmp/fstab /tmp/fstab_bkp_`date +%Y.%m.%d.%H.%M.%S`
					echo "!!! A Backup of fstab file has been created under /tmp dir for safety reasons !!!"
					vi /etc/fstab
					echo -e "Make sure you've modified the file properly and if not, Kindly press Ctrl/Cmd + C to cancel this script and re-run it."
				;;
				[aA])
					cp /etc/fstab /tmp
					mv /tmp/fstab /tmp/fstab_bkp_`date +%Y.%m.%d.%H.%M.%S`
					echo "!!! A Backup of fstab file has been created under /tmp dir for safety reasons !!!"
					grep -v "$LVM_REM_FULLPATH" fstab >> /etc/temp_fsbackup
					mv /etc/temp_fsbackup /etc/fstab
					echo -e "-----------------------------------------"
					echo -e "fstab file has been modified successfully"
					echo -e "-----------------------------------------"
				;;
			esac
	fi
		
	echo -e ""
	echo -e ""
	echo -e "Unmounting the LVM"
		umount $LVM_REM_MOUNTPT
	echo -e ""
	echo -e "Disabling the LVM"
		lvchange -an $LVM_REM_FULLPATH

}



###########################################################

FUNC_LVREMOVE_ANDVG() {
	

	FUNC_ONLYLVREMOVE 

		echo -e "-----------------------------------------"
		echo "TIME TO REMOVE THE VOLUME GROUP NOW"
		echo -e "-----------------------------------------"

		echo -e ""
		echo -e "Below is the list of Volume Groups present in your system ->"
		vgs
		echo -e ""
		echo -e "Please note down/copy the name of the Volume Group you want to remove (Case Sensitive)"
		echo -e ""
		read -p "ENTER THE NAME OF VOLUME GROUP YOU WANT TO REMOVE HERE -> " VAR_VGREMOVE_NAME
		vgremove $VAR_VGREMOVE_NAME
		echo -e ""
		echo -e "Below is the list of Volume Groups present in your system now after removal ->"
		vgs
		echo -e ""
		echo -e "!!! Operation Completed !!!"
	

}

FUNC_LVREMOVE_ANDVG_ANDPV() {
	FUNC_LVREMOVE_ANDVG

			echo -e "Below is the list of Physical Volumes present on your system currently ->"
			pvs
			echo -e ""
			echo -e "And below is the details information of the Physical Volumes configured currently on your system ->"
			pvdisplay

			echo -e "Please note down/copy the name of the Physical Volume you want to remove (Case Sensitive)"
			echo -e ""
			read -p "ENTER THE NAME OF PHYSICAL VOLUME (PV) YOU WANT TO REMOVE HERE -> " VAR_PVREMOVE_NAME
			pvremove -f $VAR_PVREMOVE_NAME
			echo -e ""
			echo -e "Below is the list of Physical Volumes present in your system now after removal ->"
			pvs
			echo -e ""
			echo -e "!!! Operation Completed !!!"

}


FUNC_LVREMOVE() {
	echo "SELECT FROM THE LIST OF OPTIONS BELOW WHAT YOU NEED TO PERFORM:"
	echo -e "a. Just remove the existing LVM. That's it !"
	echo -e "b. Remove Existing LVM and ALSO REMOVE THE VOLUME GROUP IN WHICH THE LVM EXISTS"
	echo -e "c. Remove Existing LVM, Remove the Volume group in which this LVM exists AND ALSO REMOVE THE PHYSICAL VOLUMES ATTACHED TO THE Volume Group"
	
	read -p "Enter your response (a/b/c) -> " VAR_LVREM_CHOICE

	case $VAR_LVREM_CHOICE in
		[aA])
			FUNC_ONLYLVREMOVE
			;;
		[bB])
			FUNC_LVREMOVE_ANDVG
			;;
		[cC])
			FUNC_LVREMOVE_ANDVG_ANDPV
			;;
	esac
}

FUNC_LVREMOVE