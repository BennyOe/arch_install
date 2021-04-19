#!/bin/bash

#### TODO ####
# bluetooth
# autostart numlockx on

#################
#### Welcome ####
#################
bootstrapper_dialog --title "Welcome" --msgbox "Welcome to the Apps Installation.\n" 6 60

##################
### User Input ###
##################

# app folder
appfolder=$(dialog --stdout --inputbox "Enter additional apps" 0 0) || exit 1
clear

yay -S --noconfirm $appfolder

##################
## Standard Apps #
##################

yay -S --noconfirm pulseaudio pulseaudio-alsa pavucontrol pa-applet-git ponymix signal-desktop discord_arch_electron brave-bin ranger redshift flameshot autorandr mailspring whatsapp-for-linux thunar xidlehook numlockx intellij-idea-ultimate-edition zathura htop vlc neofetch

##################
## Lightdm #######
##################

yay -S --noconfirm lightdm lightdm-mini-greeter

##################
###### ZSH #######
##################

# oh my zsh
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# powerlevel 10k
yay -S --noconfirm zsh-theme-powerlevel10k-git
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# lsd
pacman -S --noconfirm lsd

# zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

##################
###### VIM #######
##################
yay -S --noconfirm neovim-nightly-bin

##################
##### Spotify ####
##################
yay -S --noconfirm spotifyd spotify-tui

