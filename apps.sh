#!/bin/bash

#################
#### Welcome ####
#################
bootstrapper_dialog --title "Welcome" --msgbox "Welcome to the Apps Installation.\n" 6 60
dialog --stdout --msgbox "Welcome to the Apps installation.\nThis script will install additional Applications" 0 0

##################
### User Input ###
##################
optionalApps=()
cmd=(dialog --separate-output --checklist "Select apps to install:" 22 76 16)
options=(1 "signal-desktop" on    # any option can be set to default to "on"
         2 "discord_arch_electron" on
         3 "brave-bin" on
         4 "flameshot" on
         5 "autorandr" on
         6 "mailspring" on
         7 "whatsapp-for-linux" on
         8 "xidlehook" on
         9 "intellij-idea-ultimate-edition" on
         10 "vlc" on  
         11 "spotify-tui" on
         )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            optionalApps+=(signal-desktop)
            ;;
        2)
            optionalApps+=(discord_arch_electron)
            ;;
        3)
            optionalApps+=(brave-bin)
            ;;
        4)
            optionalApps+=(flameshot)
            ;;
        5)
            optionalApps+=(autorandr)
            ;;
        6)
            optionalApps+=(mailspring)
            ;;
        7)
            optionalApps+=(whatsapp-for-linux)
            ;;
        8)
            optionalApps+=(xidlehook)
            ;;
        9)
            optionalApps+=(intellij-idea-ultimate-edition)
            ;;
        10)
            optionalApps+=(vlc)
            ;;
        11)
            optionalApps+=(spotifyd spotify-tui)
            ;;
    esac
done

# user apps
userApps=$(dialog --stdout --inputbox "Enter additional apps (space seperated)" 0 0) || exit 1

clear
printf "Installing user apps\n"
sleep 2


yay -S --noconfirm ${optionalApps[*]}
yay -S --noconfirm ${userApps[*]}

##################
## Standard Apps #
##################
essentialApps=(pulseaudio pulseaudio-alsa pavucontrol pa-applet-git ponymix ranger redshift thunar numlockx zathura htop-vim-git neofetch nodejs npm python-pynvim xarchiver unzip)
clear
printf "Installing default apps\n"
sleep 2
yay -S --noconfirm  ${essentialApps[*]}

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
#### Dot Files ###
##################
clear
printf "Installing dot files\n"
sleep 2

git clone https://github.com/BennyOe/.dotfiles ~/.dotfiles
sleep 1
##################
#### Symlinks ####
##################
chmod +x ~/.dotfiles/setsymlinks.sh
source ~/.dotfiles/setsymlinks.sh


clear
printf "Installation finished successfully\n"
printf "rebooting the system.\n"
printf "press a key to continue...\n"
read < /dev/tty
reboot
