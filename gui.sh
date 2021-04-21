#!/bin/bash

# remove the script from .bashrc
sed -i '$d' ~/.bashrc


sudo pacman -Sy --noconfirm dialog

#################
#### Welcome ####
#################
bootstrapper_dialog --title "Welcome" --msgbox "Welcome to the GUI Installation.\n" 6 60
dialog --stdout --msgbox "Welcome to the GUI installation.\nThis script will install X and DWM" 0 0

##################
### User Input ###
##################

# app folder
appfolder=$(dialog --stdout --inputbox "Enter application folder" 0 0) || exit 1
clear
: ${appfolder:?"appfolder cannot be empty"}

appfolder=".$appfolder"

dialog --msgbox "Your Application Folder is ~/${appfolder}" 0 0

# Graphics Card selection
graphicsdriver=""
exec 3>&1
       selection=$(dialog \
         --title "Graphics driver" \
         --clear \
         --menu "Please select:" 0 0 4 \
         "1" "Free Graphics Driver" \
         "2" "NVIDIA" \
         "3" "AMD" \
         "4" "Virtual Machine" \
         2>&1 1>&3)
      case $selection in
        0 )
          clear
          echo "Program terminated."
          ;;
        1 )
            graphicsdriver="xf86-video-intel"
            echo "${graphicsdriver}"
          ;;
        2 )
            graphicsdriver="nvidia"
            echo "${graphicsdriver}"
          ;;  
        3 )
            graphicsdriver="xf86-video-amdgpu"
            echo "${graphicsdriver}"
          ;;
        4 )
            graphicsdriver="xf86-video-fbdev"
            echo "${graphicsdriver}"
          ;;
      esac



###########################
### Graphical Interface ###
###########################
clear
printf "installing graphical interface\n"
sleep 2
sudo pacman -S --noconfirm $graphicsdriver xorg xorg-xinit picom nitrogen rofi dunst

mkdir ~/$appfolder

###################
### Yay Install ###
###################
printf "installing yay package manager\n"
sleep 2
cd ~/$appfolder
git clone https://aur.archlinux.org/yay-git.git
cd ~/$appfolder/yay-git
makepkg -si --noconfirm

#####################
### Modifiy Files ###
#####################
# Xinitrc
clear
printf "Modifying .xinitrc"
sleep 2

# copy default xinitrc
cp /etc/X11/xinit/xinitrc ~/.xinitrcTMP

# delete last 5 lines of xinitrc
head -n -5 ~/.xinitrcTMP > ~/.xinitrcMOD ; mv ~/.xinitrcMOD ~/.xinitrc
rm ~/.xinitrcTMP

# setting xinitrc up
printf "exec dwm\n" >> ~/.xinitrc

# start X at startup
clear
printf "Modifying .bash_profile\n"
sleep 2
printf "[[ \$(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1\n" >> ~/.bash_profile

# keyboard layout for x
printf "setting german keyboard layout for X\n"
sleep 2

printf "Section \"InputClass\"\n
             Identifier \"system-keyboard\"\n
             MatchIsKeyboard \"on\"\n
             Option \"XkbLayout\" \"de\"\n
             Option \"XkbModel\" \"pc105\"\n
             Option \"XkbOptions\" \"grp:alt_shift_toggle\"\n
             EndSection" >> ~/00-keyboard.conf
             
sudo mv ~/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf

# picom
printf "Modifying picom.conf\n"
mkdir ~/.config
mkdir ~/.config/picom
cp /etc/xdg/picom.conf ~/.config/picom/
sed -i -e 's/#vsync = false/vsync = false/g' ~/.config/picom/picom.conf
sed -i -e 's/vsync = true/#vsync = true/g' ~/.config/picom/picom.conf
sleep 2

########################
### Install Suckless ###
########################
# dwm
clear
printf "installing DWM\n"
sleep 2
cd ~/$appfolder
git clone https://github.com/BennyOe/dwm.git
cd dwm
sudo make clean install
mkdir ~/.dwm/
touch ~/.dwm/autostart.sh
chmod +x ~/.dwm/autostart.sh

# dwmblocks
clear
printf "installing DWMBLOCKS\n"
sleep 2
cd ~/$appfolder
git clone https://github.com/BennyOe/dwmblocks.git
cd dwmblocks
sudo make clean install
printf "dwmblocks &\nnm-applet&\npa-applet&\npicom&\nnitrogen --restore&\n" >> ~/.dwm/autostart.sh

#st
clear
printf "installing Simple Terminal\n"
sleep 2
cd ~/$appfolder
git clone https://github.com/papitz/SimpleTerminal.git
cd SimpleTerminal
sudo make clean install

#########################
### Install Yay Stuff ###
#########################
# install packages
clear
printf "installing Yay Stuff...\n"
sleep 2
yay -S --noconfirm nerd-fonts-jetbrains-mono pacman-contrib archlinux-contrib sysstat ttf-font-awesome dmenu network-manager-applet gnu-free-fonts zsh papirus-icon-theme gtk4 arc-gtk-theme lxappearance
# removing libxft beforehand
clear
printf "removing libxft\n"
sudo pacman -Rs libxft -d -d --noconfirm 

printf "installing libxft-bgra\n"
yes | yay -S --noconfirm libxft-bgra


############################
### Installing Wallpaper ###
############################
clear
printf "installing wallpapers"
mkdir ~/Pictures
mkdir ~/Pictures/Wallpaper
git clone https://github.com/BennyOe/wallpaper.git ~/Pictures/Wallpaper
sleep 2
mkdir ~/.config/nitrogen
printf "[xin_0]\n
        file=$HOME/Pictures/Wallpaper/0257.jpg\n
        mode=5\n
        bgcolor=#0" >> ~/.config/nitrogen/bg-saved.cfg
nitrogen --set-centered $HOME/Pictures/Wallpaper/0257.jpg

############################
### Install apps script ####
############################

clear
printf "Installation finished successfully\n\n"
sleep 5

#https://git.io/JORTc

while true
do
 read -r -p "Would you like to install the default apps? [Y/n] " input < /dev/tty
 
 case $input in
     [yY][eE][sS]|[yY])
 curl -sL https://raw.githubusercontent.com/BennyOe/arch_install/main/test-apps | bash
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
printf "rebooting the system...\nplease press a key to continue..."
read < /dev/tty

reboot
