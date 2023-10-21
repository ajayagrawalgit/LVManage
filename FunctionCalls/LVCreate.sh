#!/bin/bash

	echo -e "------ Creating a new LVM ------"
	echo -e "Please specify if you want to:"
	echo -e "a. Create a new LVM in an existing Volume Group ?"
	echo -e "b. Create a new Volume Group and then create a new LVM inside it."
	read -p  "Enter your Choice (a,b) -> " VAR_LVMCREATECHOICE

		case $VAR_LVMCREATECHOICE in
		[aA])
			echo "------ Creating a new LVM in Existing Volume Group ------"
			echo "Please make a note of the following parameters as these are the details you'll need for this process."
			echo "- Name of Volume Group in which you want to create your new LVM."
			echo "- Name you want to give your LVM."
			echo "- Size of the LVM you want to create *IN MB* (MegaBytes) - (1GB = 1024 MB)."
			echo "- Type of Filesystem which you want to format your newly created LVM as (e.g. ext4, ext, xfs etc)."
			echo "- Mountpoint (Path where you want to mount your new LVM)."
			
			echo "Below are the list of Volume groups currently available on the Filesystem"
			vgs

			echo "Below are the list of disks present on your Linux System:"
			fdisk -l | grep sd

			read -p "Enter the NAME you want to give your LVM -> " VAR_NEWLVMNAME
			read -p "Enter the SIZE *IN MB* you want to make your LVM of -> " VAR_NEWLVMSIZE
			read -p "Enter the VOLUME GROUP NAME (from the list printed above) you want to ADD your NEW LVM to -> " VAR_VOLGRPNAME
			read -p "Enter the FILESYSTEM TYPE you want to format your LVM as -> " VAR_LVMFSTYPE
			read -p "Enter the Mountpoint (Complete Path) where you want to mount your LVM -> " VAR_LVMMOUNTPT

			#Command to create a new LVM
			echo "Creating a new LVM"
			#echo "lvcreate -n $VAR_NEWLVMNAME -L $VAR_NEWLVMSIZE"M" $VAR_VOLGRPNAME"
			lvcreate -n $VAR_NEWLVMNAME -L $VAR_NEWLVMSIZE"M" $VAR_VOLGRPNAME

			echo "Formating the newly created LVM to $VAR_LVMFSTYPE FileSystem"
			#echo "mkfs.$VAR_LVMFSTYPE /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME"
			mkfs.$VAR_LVMFSTYPE /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME

			echo "Mounting $VAR_NEWLVMNAME to fstab now to make it available permanently to your linux machine"
			#echo "mount /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME $VAR_LVMMOUNTPT"
			mount /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME $VAR_LVMMOUNTPT

			echo "/dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME   $VAR_LVMMOUNTPT        $VAR_LVMFSTYPE    defaults        0 0" >> /etc/fstab

			echo "- - - - - - - - - - THE LVM HAS BEEN CREATED SUCCESSFULLY - - - - - - - - - -"
			;;

		[bB])
			read -p "Enter 1 if you want to create ENTIRELY NEW Volume Group or else Enter 2 if you want to Extend/Add your storage to an EXISTING Volume Group" VAR_VGCHOICE


			case $VAR_VGCHOICE in
				1)
					echo "---------- CREATING AN ENTIRELY NEW VOLUME GROUP ----------"
					echo "Below is the list of storages which are currently present on your linux system"
					fdisk -l | grep sd
					echo "Kindly take a note of full disk paths from the list printed above to create a Physical Volume first and then add them all to the Volume Group"
					read -p "Enter the number of disks you want to add in Volume Group -> " VAR_DISKNOVG
						for (( i = 0; i < $VAR_DISKNOVG; i++ )); do
							read -p "Enter the full path of disk no. $i" VAR_PVDISKNAME
							VAR_PVDISKCONCAT+="$VAR_PVDISKNAME "
						done
					VAR_PVDISKCONCAT=${VAR_PVDISKCONCAT::-1}
					pvcreate $VAR_PVDISKCONCAT
					echo "!!! Physical Volumes are created successfully !!!"
					echo "Below are the details of all the Physical VOlumes currently present on your Linux Machine"
					pvs

					echo ""
					echo "ADDING THE PHYSICAL VOLUMES TO A NEW VOLUME GROUP NOW"
					read -p "Enter the name you want to give your new Volume Group -> " VAR_NEWVGNAME
					vgcreate $VAR_NEWVGNAME $VAR_PVDISKCONCAT

#Same LVCREATE OF 1) Copy Paste
			
					echo "Please make a note of the following parameters as these are the details you'll need for this process."
					echo "- Name of Volume Group in which you want to create your new LVM."
					echo "- Name you want to give your LVM."
					echo "- Size of the LVM you want to create *IN MB* (MegaBytes) - (1GB = 1024 MB)."
					echo "- Type of Filesystem which you want to format your newly created LVM as (e.g. ext4, ext, xfs etc)."
					echo "- Mountpoint (Path where you want to mount your new LVM)."
					
					echo "Below are the list of Volume groups currently available on the Filesystem"
					vgs

					echo "Below are the list of disks present on your Linux System:"
					fdisk -l | grep sd

					read -p "Enter the NAME you want to give your LVM -> " VAR_NEWLVMNAME
					read -p "Enter the SIZE *IN MB* you want to make your LVM of -> " VAR_NEWLVMSIZE
					read -p "Enter the VOLUME GROUP NAME (from the list printed above) you want to ADD your NEW LVM to -> " VAR_VOLGRPNAME
					read -p "Enter the FILESYSTEM TYPE you want to format your LVM as -> " VAR_LVMFSTYPE
					read -p "Enter the Mountpoint (Complete Path) where you want to mount your LVM -> " VAR_LVMMOUNTPT

					#Command to create a new LVM
					echo "Creating a new LVM"
					#echo "lvcreate -n $VAR_NEWLVMNAME -L $VAR_NEWLVMSIZE"M" $VAR_VOLGRPNAME"
					lvcreate -n $VAR_NEWLVMNAME -L $VAR_NEWLVMSIZE"M" $VAR_VOLGRPNAME

					echo "Formating the newly created LVM to $VAR_LVMFSTYPE FileSystem"
					#echo "mkfs.$VAR_LVMFSTYPE /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME"
					mkfs.$VAR_LVMFSTYPE /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME

					echo "Mounting $VAR_NEWLVMNAME to fstab now to make it available permanently to your linux machine"
					#echo "mount /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME $VAR_LVMMOUNTPT"
					mount /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME $VAR_LVMMOUNTPT

					echo "/dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME   $VAR_LVMMOUNTPT        $VAR_LVMFSTYPE    defaults        0 0" >> /etc/fstab

					echo "- - - - - - - - - - THE LVM HAS BEEN CREATED SUCCESSFULLY - - - - - - - - - -"
					;;


				2)
					echo -e ""
					echo -e "--------------------------------------"
					echo -e "EXTENDING THE EXISTING VOLUME GROUP"
					echo -e "--------------------------------------"
					echo -e ""

					echo -e "Below are the Physical Volumes present in your Linux Machine Currently ->"
					pvscan

					echo -e "Please note down/copy the name of Physical Volumes (PVs) you want to add to your EXISTING Volume Group in order to extend it"


					echo -e "& Below is the list of storages which are currently present on your linux system"
					fdisk -l | grep sd
					echo "Kindly take a note of full disk paths from the list printed above to add them to your EXISTING Volume Group in order to extend it"
						pvs
					read -p "Enter the number of disks you want to add in Volume Group for the extension -> " VAR_DISKNOVG
						for (( i = 0; i < $VAR_DISKNOVG; i++ )); do
							read -p "Enter the full path of disk no. $i -> " VAR_PVDISKNAME
							VAR_PVDISKCONCAT+="$VAR_PVDISKNAME "
						done
					VAR_PVDISKCONCAT=${VAR_PVDISKCONCAT::-1}

					echo -e "Below is the list of Volume Groups present in your system currently ->"
						vgs
					read -p "Enter the name of the Volume group you want to Extend -> " VAR_VGNAMETOEXTEND

					vgextend $VAR_VGNAMETOEXTEND $VAR_PVDISKCONCAT
					echo "!!! VOLUME FROUP EXTENDED SUCCESSFULLY !!!"
					echo -e "Below is the list of Volume Groups present in your system currently after extending them ->"
						vgs

#Same LVCREATE OF 1) Copy Paste
					echo -e ""
					echo -e "------------------------------------------------"
					echo -e "CREATING A NEW LVM NOW"
					echo -e "------------------------------------------------"
					echo -e ""

					echo "Please make a note of the following parameters as these are the details you'll need for this process."
					echo "- Name of Volume Group in which you want to create your new LVM."
					echo "- Name you want to give your LVM."
					echo "- Size of the LVM you want to create *IN MB* (MegaBytes) - (1GB = 1024 MB)."
					echo "- Type of Filesystem which you want to format your newly created LVM as (e.g. ext4, ext, xfs etc)."
					echo "- Mountpoint (Path where you want to mount your new LVM)."
					
					echo "Below are the list of Volume groups currently available on the Filesystem"
					vgs

					echo "Below are the list of disks present on your Linux System:"
					fdisk -l | grep sd

					read -p "Enter the NAME you want to give your LVM -> " VAR_NEWLVMNAME
					read -p "Enter the SIZE *IN MB* you want to make your LVM of -> " VAR_NEWLVMSIZE
					read -p "Enter the VOLUME GROUP NAME (from the list printed above) you want to ADD your NEW LVM to -> " VAR_VOLGRPNAME
					read -p "Enter the FILESYSTEM TYPE you want to format your LVM as -> " VAR_LVMFSTYPE
					read -p "Enter the Mountpoint (Complete Path) where you want to mount your LVM -> " VAR_LVMMOUNTPT

					#Command to create a new LVM
					echo "Creating a new LVM"
					#echo "lvcreate -n $VAR_NEWLVMNAME -L $VAR_NEWLVMSIZE"M" $VAR_VOLGRPNAME"
					lvcreate -n $VAR_NEWLVMNAME -L $VAR_NEWLVMSIZE"M" $VAR_VOLGRPNAME

					echo "Formating the newly created LVM to $VAR_LVMFSTYPE FileSystem"
					#echo "mkfs.$VAR_LVMFSTYPE /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME"
					mkfs.$VAR_LVMFSTYPE /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME

					echo "Mounting $VAR_NEWLVMNAME to fstab now to make it available permanently to your linux machine"
					#echo "mount /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME $VAR_LVMMOUNTPT"
					mount /dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME $VAR_LVMMOUNTPT

					echo "/dev/$VAR_VOLGRPNAME/$VAR_NEWLVMNAME   $VAR_LVMMOUNTPT        $VAR_LVMFSTYPE    defaults        0 0" >> /etc/fstab

					echo "- - - - - - - - - - THE LVM HAS BEEN CREATED SUCCESSFULLY - - - - - - - - - -"
				;;

			esac
	;;
esac