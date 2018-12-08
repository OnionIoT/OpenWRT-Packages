#!/bin/sh

storageDev=mmcblk0p1
swapSize=384 # 512 - 128 MB

# TODO: if OS has booted from overlay partition on mmcblk0 device, exit the script!

# TODO: if an ext4 partition 1 already exists, skip this step
#Format SD card
(
echo d # Delete all partitions
echo n # Add a new partition
echo p # Primary partition
echo   # Partition number (Accept default)
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
# echo y # confirm removal of partition signature
echo w # Write changes
) | fdisk /dev/mmcblk0

echo y | mkfs.ext4 /dev/$storageDev

# we need to create the startup scrpt before duplcating overlay
cat > /etc/init.d/swapon <<EOF
#!/bin/sh /etc/rc.common
# (C) 2018 Onion Corporation

START=89
SWAP_FILE="/overlay/swap.page"

boot() {
	if [ -e "\$SWAP_FILE" ]; then
		swapon \$SWAP_FILE
	fi
}
EOF
chmod +x /etc/init.d/swapon
/etc/init.d/swapon enable

# TODO: if there is already an overlay filesystem on the emmc:
#	* do not overwrite the /root directory 
# 	* do not overwrite changes to /etc/config/ files
#duplicate /overlay
mount /dev/$storageDev /mnt/ ; tar -C /overlay -cvf - . | tar -C /mnt/ -xf - ; umount /mnt/

# auto mount /overlay
block detect > /etc/config/fstab
uci set fstab.@mount[0].enabled='1'
uci set fstab.@mount[0].target='/overlay'
uci commit
/etc/init.d/fstab enable


# create swap file
mount /dev/$storageDev /mnt/
dd if=/dev/zero of=/mnt/swap.page bs=1M count=$swapSize
mkswap /mnt/swap.page


echo "> Done. Rebooting in 3 seconds..."
sleep 3
reboot
