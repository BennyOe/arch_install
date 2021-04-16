#!/bin/bash

#### TODO ####
# script kann nur als sudo ausgeführt werden. Dann ist der home path aber falsch



sudo pacman -Sy --noconfirm dialog

#################
#### Welcome ####
#################
bootstrapper_dialog --title "Welcome" --msgbox "Welcome to the GUI Installation.\n" 6 60

##################
### User Input ###
##################

# app folder
appfolder=$(dialog --stdout --inputbox "Enter application folder" 0 0) || exit 1
clear
: ${appfolder:?"appfolder cannot be empty"}

appfolder=".$appfolder"


###########################
### Graphical Interface ###
###########################
printf "installing graphical interface\n"
sleep 2
sudo pacman -S --noconfirm xf86-video-fbdev xorg xorg-xinit picom nitrogen

mkdir ~/$appfolder
cd ~/$appfolder

###################
### Yay Install ###
###################
printf "installing yay package manager\n"
sleep 2
git clone https://aur.archlinux.org/yay-git.git
cd /home/$user/$appfolder/yay-git
makepkg -si --noconfirm

#####################
### Modifiy Files ###
#####################
# Xinitrc
clear
printf "Modifying .xinitrc\”"
sleep 2

# copy default xinitrc
cp /etc/X11/xinit/xinitrc /home/$user/.xinitrcTMP

# delete last 5 lines of xinitrc
head -n -5 ~/.xinitrcTMP > ~/.xinitrc
rm ~/.xinitrcTMP

# setting xinitrc up
printf "nitrogen --restore & \npicom & \nexec dwm\n" >> ~/.xinitrc

# start X at startup
clear
printf "Modifying .bash_profile\n"
sleep 2
printf "[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1\n" >> ~/.bash_profile

# keyboard layout for x
clear
printf "setting german keyboard layout for X\n"
sleep 2

sudo printf "Section \"InputClass\"\n
             Identifier \"system-keyboard\"\n
             MatchIsKeyboard \"on\"\n
             Option \"XkbLayout\" \"de\"\n
             Option \"XkbModel\" \"pc105\"\n
             Option \"XkbOptions\" \"grp:alt_shift_toggle\"\n
             EndSection" >> /etc/X11/xorg.conf.d/00-keyboard.conf

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
touch autostart.sh
chmod +x ~/.dwm/autostart.sh

# dwmblocks
clear
printf "installing DWMBLOCKS\n"
sleep 2
cd ~/$appfolder
git clone https://github.com/BennyOe/dwmblocks.git
cd dwmblocks
sudo make clean install
printf "dwmblocks &\nnm-applet&\n" >> ~/.dwm/autostart/autostart.sh

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
# removing libxft beforehand
sudo pacman -R libxft -d -d --noconfirm 
sleep 2
yay -S --noconfirm nerd-fonts-jetbrains-mono pacman-contrib archlinux-contrib sysstat nerd-fonts-mononoki ttf-font-awesome dmenu network-manager-applet gnu-free-fonts
yay -S libxft-bgra
