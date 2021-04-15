#!/bin/bash

hdd=""



function userInputs() {

    # the harddrive select
    fdisk -l
    echo "Select HDD to install Arch (/dev/sdX)"
    read hdd
}


# do all the pre installation setup
function preInstallation() {

    # load the german keyboard layout
     sudo loadkeys de-latin1

    # check if the system is booted in EFI or BIOS mode
    echo "checking the system for bootmode"
    if [ -d "/sys/firmware/efi/efivars" ]; then
        echo " the system is in EFI Mode"
    else
        echo "the system is in BIOS Mode"
    fi

    # check if the internet is working
    echo "checking the internet connection"
    if ping -c 1 archlinux.org &>/dev/null; then 
        echo "Internet connection working..."
    else 
        echo "Internet connection not working"
         # Wlan or Ethernet
        echo "Do you use Wlan for the installation? [y]/n"
        read wlan

        if [ $wlan=="y"]; then
            iwctl device list
            echo "pick device"
            read device
            iwctl station $device scan
            iwctl station $device get-networks
            echo "pick SSID"
            read ssid
            echo "enter password"
            read pw
            iwctl --passphrase=$pw station $device connect $ssid
            while ! ping -c 1 archlinux.org &>/dev/null; 
            do 
                echo "connection unsuccessful..."
                echo "enter password"
                read pw
                iwctl --passphrase=$pw station $device connect $ssid
            done
                echo "Internet connection working..."
        else
        echo "please check your connection..."
        exit -1
        fi
    fi

    # update the system clock
    echo "updating the system clock"
    timedatectl set-ntp true
    timedatectl status
}

function formatDisk() {
    echo "Starting to partition the disk"
    fdisk $hdd
    # TODO sfdisk disk automation
    mkfs.fat -F32 "${hdd}1"
    mkswap "${hdd}2"
    mkfs.ext4 "${hdd}3"

    mount "${hdd}3 /mnt"
    swapon "${hdd}2"
}

function installArch() {
echo "Arch installation"
pacstrap /mnt base linux linux-firmware base-devel vim networkmanager

#configure the system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

#localization
echo "uncomment the language you like to have"
vim /etc/locale.gen
locale-gen
touch /etc/locale.conf
printf "LANG=en_US.UTF-8" > /etc/locale.conf

touch /etc/vconsole.conf
printf "KEYMAP=de-latin1" > /etc/vconsole.conf

# network configuration
echo "name our computer"
read computername
touch /etc/hostname
printf $computername > /etc/hostname

printf "127.0.0.1    localhost \n" >> /etc/hosts
printf "::1    localhost \n" >> /etc/hosts
printf "127.0.1.1    ${computername}.localdomain    ${computername}" >> /etc/hosts

mkinitcpio -P

# user management
echo "set your root password"
passwd

echo "set username"
read username
useradd -m $username
echo "set password for user ${username}"
passwd $username

# set the groups for the user
usermod -aG wheel,audio,video,optical,storage $username

pacman -S --noconfirm sudo man

echo "uncomment the wheel line"
visudo

# bootloader
pacman -S --noconfirm grub efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
mount "${hdd}1" /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# network
systemctl enable NetworkManager

# reboot
exit
reboot
}

userInputs
preInstallation
formatDisk
installArch