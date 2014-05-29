#!/bin/bash

#takes accession number, digital media number, and extension as variables to mount a disk image and run a virus check


#checks to see if disk is mounted or not
check_mount () {
mountpoint -q /mnt/disk && echo "mounted" || "not mounted"
}	

get_info () {
#gets disk image info from user, validates info
	read -p "Please enter the accession number" accession
	until [ -d /mnt/transferfiles/${accession} ]; do
		read -p "Invalid. Please enter the accesion number." accession
	done 

	read -p "Please enter the digital media number" digital_media
	until [ -d /mnt/transferfiles/${accession}/${accession}_${digital_media} ]; do
		read -p "Invalid. Please enter the digital media number." digital_media
	done

	read -p  "Please enter the file extension, exclude the preceding period" extension
	until [ -e /mnt/transferfiles/${accession}/${accession}_${digital_media}/${accession}_${digital_media}.${extension} ]; do
		read -p "Invalid. Please enter the file extension, including the preceding period" extension
	done
}

get_info
sudo mount -o ro,loop,nodev,noexec,nosuid,noatime /mnt/transferfiles/${accession}/${accession}_${digital_media}/${accession}_${digital_media}.${extension} /mnt/disk

check_mount

sudo clamscan -r /mnt/iso > "/mnt/transferfiles/${accession}/${accession}_${digital_media}/${accession}_${digital_media}_scan.txt"

sudo umount /mnt/disk
check_mount
