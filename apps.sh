#!/bin/bash

#################
#### Welcome ####
#################
bootstrapper_dialog --title "Welcome" --msgbox "Welcome to the Apps Installation.\n" 6 60
dialog --stdout --msgbox "Welcome to the Apps installation.\nThis script will install additional Applications" 0 0

##################
### User Input ###
##################
# app folder
appfolder=$(dialog --stdout --inputbox "Enter additional apps" 0 0) || exit 1

clear
printf "Installing user apps\n"
sleep 2

yay -S --noconfirm $appfolder

##################
## Standard Apps #
##################
clear
printf "Installing default apps\n"
sleep 2
yay -S --noconfirm pulseaudio pulseaudio-alsa pavucontrol pa-applet-git ponymix signal-desktop discord_arch_electron brave-bin ranger redshift flameshot autorandr mailspring whatsapp-for-linux thunar xidlehook numlockx intellij-idea-ultimate-edition zathura htop vlc neofetch nodejs npm python-pynvim

##################
## Lightdm #######
##################
clear
printf "Installing lightdm\n"
sleep 2

yay -S --noconfirm lightdm lightdm-mini-greeter

##################
###### ZSH #######
##################
clear
printf "Installing zsh\n"
sleep 2

# oh my zsh
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# powerlevel 10k
yay -S --noconfirm zsh-theme-powerlevel10k-git
echo 'source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# lsd
sudo pacman -S --noconfirm lsd

# zsh autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# changing shell to zsh
sudo chsh -s $(which zsh) $(users)

# setting zsh profile
cp ~/.bash_profile ~/.zprofile

##################
###### VIM #######
##################
clear
printf "Installing vim\n"
sleep 2

yay -S --noconfirm neovim-nightly-bin

#Vim-Plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

##################
##### Spotify ####
##################
clear
printf "Installing spotify-tui\n"
sleep 2

yay -S --noconfirm spotifyd spotify-tui

##################
#### Dot Files ###
##################
clear
printf "Installing dot files\n"
sleep 2

git clone https://github.com/BennyOe/.dotfiles ~/.dotfiles

##################
#### Symlinks ####
##################
chmod +x ~/.dotfiles/setsymlinks.sh
source ~/.dotfiles/symlinks.sh


clear
printf "Installation finished successfully\n"
printf "rebooting the system.\n"
printf "press a key to continue...\n"
read < /dev/tty
reboot
