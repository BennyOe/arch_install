#!/bin/bash

hdd=""

function userInputs() {
 # load the german keyboard layout
    echo "loading german keyboard layout...\n"
    sleep 1
     sudo loadkeys de-latin1

    # the harddrive select
    fdisk -l
    echo "\n"
    echo "Select HDD to install Arch (/dev/sdX)"
    read hdd
}


# do all the pre installation setup
function preInstallation() {

    # check if the system is booted in EFI or BIOS mode
    echo "checking the system for bootmode\n"
    if [ -d "/sys/firmware/efi/efivars" ]; then
        echo " the system is in EFI Mode\n"
    else
        echo "the system is in BIOS Mode\n"
        echo "this script is for EFI install only...\n"
        sleep 1
        exit -1
    fi

    # check if the internet is working
    echo "checking the internet connection\n"
    sleep 1
    if ping -c 1 archlinux.org &>/dev/null; then 
        echo "Internet connection working...\n"
    else 
        echo "Internet connection not working\n"
         # Wlan or Ethernet
        echo "Do you use Wlan for the installation? [y]/n\n"
        read wlan

        if [ $wlan=="y"]; then
            iwctl device list
            echo "pick device\n"
            read device
            iwctl station $device scan
            iwctl station $device get-networks
            echo "pick SSID\n"
            read ssid
            echo "enter password\n"
            read pw
            iwctl --passphrase=$pw station $device connect $ssid
            while ! ping -c 1 archlinux.org &>/dev/null; 
            do 
                echo "connection unsuccessful...\n"
                echo "enter password\n"
                read pw
                iwctl --passphrase=$pw station $device connect $ssid
            done
                echo "Internet connection working...\n"
        else
        echo "please check your connection...\n"
        sleep 1
        exit -1
        fi
    fi

    # update the system clock
    echo "updating the system clock\n"
    sleep 1
    timedatectl set-ntp true
    timedatectl status
}

function formatDisk() {
    echo "Starting to partition the disk\n"
    fdisk $hdd
    # TODO sfdisk disk automation
    sleep 1
    echo "\n setting the filesystem\n"
    mkfs.fat -F32 "${hdd}1"
    mkswap "${hdd}2"
    mkfs.ext4 "${hdd}3"

    mount "${hdd}3" /mnt
    swapon "${hdd}2"
    read
}

function installArch() {
echo "beginning with Arch installation\n"
sleep 1
pacstrap /mnt base linux linux-firmware base-devel vim networkmanager

sleep 2
echo "is everything finished?\n"
read finish

#configure the system
echo "setting fstab\n"
genfstab -U /mnt >> /mnt/etc/fstab

echo "chrooting in installation\n"
sleep 2
arch-chroot /mnt

echo "setting time and date\n"
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

#localization
echo "uncomment the language you like to have\n"
read
vim /etc/locale.gen
locale-gen

echo "setting locale.conf\n"
touch /etc/locale.conf
printf "LANG=en_US.UTF-8" > /etc/locale.conf

echo "setting keyboard layout\n"
sleep 1
touch /etc/vconsole.conf
printf "KEYMAP=de-latin1" > /etc/vconsole.conf

# network configuration
echo "name your computer\n"
read computername
touch /etc/hostname
printf $computername > /etc/hostname

echo "setting the hosts file\n"
printf "127.0.0.1    localhost \n" >> /etc/hosts
printf "::1    localhost \n" >> /etc/hosts
printf "127.0.1.1    ${computername}.localdomain    ${computername}" >> /etc/hosts

mkinitcpio -P

# user management
echo "set your root password\n"
passwd

echo "set username\n"
read username
useradd -m $username
echo "set password for user ${username}\n"
passwd $username

# set the groups for the user
usermod -aG wheel,audio,video,optical,storage $username

echo "installing additional packets\n"
sleep 1
pacman -S --noconfirm sudo man

echo "uncomment the wheel line\n"
sleep 2
visudo

# bootloader
echo "setting up the bootloader\n"
sleep 2
pacman -S --noconfirm grub efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
mount "${hdd}1" /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# network
systemctl enable NetworkManager

# reboot
echo "rebooting the system. Please execute the gui.sh for XOrg and DWM\n"
echo "press a key to continue...\n"
read
exit
reboot
}

userInputs
preInstallation
formatDisk
installArch
