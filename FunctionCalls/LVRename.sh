#!/bin/bash

echo -e "FileSystem details below -> "
df -hP

read -p "Enter the MOUNTPOINT from the above results of the LVM which you want to RENAME -> " VAR_MNTPT_LVM

VAR_FS_DET=$(df -h | grep $VAR_MNTPT_LVM | awk '{print $1}')
#umount $VAR_MNTPT_LVM

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

		echo -e "Below is the list of Volume Groups present on your machine ->"
		vgs
		read -p "Enter the Volume Group (VG) in which the LVM is cofigured which you want to rename -> " VAR_LV_RENAME
		echo -e "Below is the list of Logical Volumes configured under $VAR_LV_RENAME VG -> "
			ls /dev/"$VAR_LV_RENAME	"
		read -p "Enter the name of the LVM you want to rename -> " VAR_RENAME_LVMNAME
		read -p "Now Enter the NEW NAME for $VAR_RENAME_LVMNAME here -> " VAR_NEWLVMNAME
			lvrename -v $VAR_LV_RENAME $VAR_RENAME_LVMNAME $VAR_NEWLVMNAME -t

		echo -e "################################################################################"
		echo -e "##################################### NOTE #####################################"
		echo -e "################################################################################"
		echo -e "NOW WE NEED TO MODIFY FSTAB FILE TO MAKE THE RENAME CHANGES PERMANENT"
		echo -e "We recommend you to do it MANUALLY using vi editor, but you have an option to automatically edit the fstab file with the new name of the LVM you have given now."
		echo -e "Enter \"y\" if you want to do it AUTOMATICALLY"
		echo -e "Enter \"n\" to edit the fstab file MANUALLY"
		read -p "Enter your choice here -> " VAR_FSTABEDIT_CHOICE

		case $VAR_FSTABEDIT_CHOICE in
			[yY])
				sed -i 's//RENAMEDLVM/g' fstab
			;;
			[nN])
				echo -e "Unmountine the existing LVM now to make the changes in fstab entries"
				umount /dev/"$VAR_LV_RENAME"/"$VAR_RENAME_LVMNAME"
				echo -e "Opening Vi Editor now . . ."
				vi /etc/fstab
				echo -e "Vi Editor has been closed ow. PLease make sure you have made all the changes correctly."
			;;
		esac
		echo -e "Mounting the Renamed LVM now"
		mount $VAR_MNTPT_LVM
	;;
esac

