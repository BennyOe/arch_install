#!/bin/bash

############### Graphical Interface ###########
sudo pacman -S --noconfirm xf86-video-fbdev xorg xorg-xinit picom nitrogen git 

mkdir .applications
cd .applications

# yay install
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si --noconfirm

# Xinitrc
cp /etc/X11/xinit/xinitrc ~/.xinitrc

for i in {1..5}
   do
    sed '$d' ~/.xinitrc
done

printf "nitrogen --restore & \n picom & \n exec dwm" >> ~/.xinitrc

# start X at startup
printf "[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1" >> .bash_profile

# keyboard layout for x
touch /etc/X11/xorg.conf.d/00-keyboard.conf
printf "Section \"InputClass\"\n
        Identifier \"system-keyboard\"\n
        MatchIsKeyboard \"on\"\n
        Option \"XkbLayout\" \"de\"\n
        Option \"XkbModel\" \"pc105\"\n
        Option \"XkbOptions\" \"grp:alt_shift_toggle\"\n
EndSection" >> /etc/X11/xorg.conf.d/00-keyboard.conf

# dwm
cd ~/.applications
git clone https://github.com/BennyOe/dwm.git
cd dwm
sudo make clean install

# dwmblocks
cd ~/.applications
git clone https://github.com/BennyOe/dwmblocks.git
cd dwmblocks
sudo make clean install

#st
cd ~/.applications
git clone https://github.com/papitz/SimpleTerminal.git
cd SimpleTerminal
sudo make clean install

# install packages
yay -S --noconfirm libxft-bgra nerd-fonts-jetbrains-mono pacman contrib sysstat nerd-fonts-mononoki ttf-font-awesome
