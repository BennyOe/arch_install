#!/bin/bash

pacman -Sy --noconfirm dialog

#################
#### Welcome ####
#################

 # load the german keyboard layout
printf "loading german keyboard layout...\n"
sleep 1
loadkeys de-latin1

bootstrapper_dialog --title "Welcome" --msgbox "Welcome to the Arch installation.\n" 6 60
dialog --stdout --msgbox "Welcome to the Arch installation.\nThis script will install the base Arch system" 0 0
dialog --stdout --msgbox "!!!This script deletes the harddrive you select without further warning!!!" 0 0

####################
#### User Input ####
####################

# the harddrive select
devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1

# Dual Boot
dualboot=0
exec 3>&1
       selection=$(dialog \
         --title "Dual Boot" \
         --clear \
         --menu "Please select:" 0 0 4 \
         "1" "Only Linux" \
         "2" "Windows Dual Boot" \
         2>&1 1>&3)
      case $selection in
        0 )
          clear
          echo "Program terminated."
          ;;
        1 )
            dualboot=0
            echo "${dualboot}"
          ;;
        2 )
            dualboot=1
            echo "${dualboot}"
          ;;  
      esac

# hostname
hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
clear
: ${hostname:?"hostname cannot be empty"}

# admin
user=$(dialog --stdout --inputbox "Enter admin username" 0 0) || exit 1
clear
: ${user:?"user cannot be empty"}

# password
password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
clear
: ${password:?"password cannot be empty"}
password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
clear
[[ "$password" == "$password2" ]] || ( printf "Passwords did not match"; exit 1; )

clear

# check if the system is booted in EFI or BIOS mode
printf "checking the system for bootmode\n\n"
sleep 1
if [ -d "/sys/firmware/efi/efivars" ]; then
    printf "the system is in EFI Mode\n"
    sleep 2
else
    printf "the system is in BIOS Mode\n"
    printf "this script is for EFI install only...\n press a key to exit"
    read < /dev/tty
    exit -1
fi

clear
# check if the internet is working
printf "checking the internet connection\n\n"
sleep 1
if ping -c 1 archlinux.org &>/dev/null; then 
    printf "Internet connection working...\n"
    sleep 2
else 
    printf "Internet connection not working\n"
     # Wlan or Ethernet
    printf "Do you use Wlan for the installation? [y]/n\n"
    read wlan

    if [ $wlan=="y"]; then
        clear
        iwctl device list
        printf "pick device\n"
        read device
        iwctl station $device scan
        iwctl station $device get-networks
        printf "pick SSID\n"
        read ssid
        printf "enter password\n"
        read wlan_pw
        iwctl --passphrase=$wlan_pw station $device connect $ssid
        while ! ping -c 1 archlinux.org &>/dev/null; 
        do 
            printf "connection unsuccessful...\n"
            printf "enter password\n"
            read wlan_pw
            iwctl --passphrase=$pw station $device connect $ssid
        done
            printf "Internet connection working...\n"
    else
    printf "please check your connection...\n press a key to exit"
    read < /dev/tty
    exit -1
    fi
fi
clear

# update the system clock
clear
printf "updating the system clock\n"
sleep 2
timedatectl set-ntp true
timedatectl status


########################
#### Disk Partition ####
########################
clear
printf "Starting to partition the disk\n"
sleep 2

if [ $dualboot -eq 0 ]; then
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
swap_end=$(( $swap_size + 512 + 1 ))MiB

parted --script "${device}" -- mklabel gpt \
  mkpart ESP fat32 1Mib 512MiB \
  set 1 boot on \
  mkpart primary linux-swap 512MiB ${swap_end} \
  mkpart primary ext4 ${swap_end} 100%

part_boot="${device}1"
part_swap="${device}2"
part_root="${device}3"

mkfs.vfat -F32 "${part_boot}"
mkswap "${part_swap}"
mkfs.ext4 "${part_root}"

swapon "${part_swap}"

else
startSector=$(parted /dev/sda <<< 'unit MiB print' | awk 'FNR==14 {print $3}')
startSector=${startSector::-3}
startSector=$((startSector + 1))

endSector=$(parted /dev/sda <<< 'unit MiB print' | awk 'FNR==15 {print $2}')
endSector=${endSector::-3}
endSector=$((endSector - 1))


clear
printf "Starting to partition the disk\n"
sleep 2
swap_size=$(free --mebi | awk '/Mem:/ {print $2}')
swap_end=$(( $swap_size + ${startSector} ))MiB

parted --script /dev/sda -- mkpart primary linux-swap ${startSector}MiB ${swap_end} \
  mkpart primary ext4 ${swap_end} ${endSector}MiB

part_boot="${device}1"
part_swap="${device}5"
part_root="${device}6"


mkswap "${part_swap}"
mkfs.ext4 "${part_root}"

swapon "${part_swap}"
fi
######################
#### Install Arch ####
######################

mount ${part_root} /mnt
#mkdir /mnt/boot/EFI
#mount ${part_boot} /mnt/boot/EFI

clear
printf "\n\n beginning with Arch installation"
sleep 5

pacstrap /mnt base linux linux-firmware base-devel vim networkmanager git man bash

#configure the system
printf "setting fstab\n"
genfstab -U /mnt >> /mnt/etc/fstab

clear
printf "\n Arch is installed.\n\n"
sleep 5

###############################
#### Configure base system ####
###############################
printf "\n\n Configure base system \n\n"
sleep 5

arch-chroot /mnt /bin/bash <<EOF
echo "Setting and generating locale"
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

export LANG=en_US.UTF-8
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "Setting time zone"
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

printf "setting keyboard layout\n"
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf
echo "Setting hostname"
echo $hostname > /etc/hostname
sed -i "/localhost/s/$/ $hostname/" /etc/hosts
echo "Installing wifi packages"
pacman --noconfirm -S iw wpa_supplicant dialog wpa_actiond sudo
echo "Generating initramfs"
sed -i 's/^HOOKS.*/HOOKS="base udev autodetect modconf block filesystems keyboard fsck"/' /etc/mkinitcpio.conf
echo "Setting root password"
echo "root:${password}" | chpasswd
printf "setting the hosts file\n"
echo "127.0.0.1    localhost \n" >> /etc/hosts
echo "::1    localhost \n" >> /etc/hosts
echo "127.0.1.1    ${hostname}.localdomain    ${hostname}" >> /etc/hosts
systemctl enable NetworkManager
mkinitcpio -p linux
EOF


#########################
#### User Management ####
#########################
clear
echo "user setup"
sleep 5
arch-chroot /mnt useradd -m -G wheel,uucp,video,audio,storage,games,input "$user"
echo "$user:$password" | chpasswd --root /mnt
echo "root:$password" | chpasswd --root /mnt
arch-chroot /mnt visudo << EOF
:%s/^# %wheel ALL=(ALL) NO/%wheel ALL=(ALL) NO/g
:wq
EOF

#############################
#### Install boot loader ####
#############################
clear
echo "Installing Grub boot loader"
sleep 5
arch-chroot /mnt /bin/bash <<EOF
    mkdir /boot/EFI
    mount $part_boot /boot/EFI
    pacman -S --noconfirm grub efibootmgr dosfstools os-prober mtools
    grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
    grub-mkconfig -o /boot/grub/grub.cfg
EOF

clear
printf "Installation finished successfully\n\n"
sleep 5

while true
do
 read -r -p "Would you like to install the window manager? [Y/n] " input < /dev/tty
 
 case $input in
     [yY][eE][sS]|[yY])
 printf "curl -sL https://git.io/JOBJn | bash" >> /mnt/home/$user/.bashrc
 echo "setup the GUI install script"
sleep 2
 break
 ;;
     [nN][oO]|[nN])
 break
        ;;
     *)
 echo "Invalid input..."
 ;;
 esac
done

# reboot
clear
printf "rebooting the system...\n"
printf "press a key to continue...\n"
read < /dev/tty
reboot
