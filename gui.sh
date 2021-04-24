#!/bin/bash

###########################
### Internet Connection ###
###########################
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

    if [ $wlan=="y" ]; then
        clear
        nmtui
        while ! ping -c 1 archlinux.org &>/dev/null; 
        do 
            printf "connection unsuccessful...\n"
            nmtui
        done
            printf "Internet connection working...\n"
    else
    printf "please check your connection...\n press a key to exit"
    read < /dev/tty
    exit -1
    fi
fi
clear

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

##################
#### User Apps ###
##################

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

yay -S --noconfirm lightdm lightdm-mini-greeter lightdm-gtk-greeter

if [ $graphicsdriver!="xf86-video-fbdev" ]; then
systemctl enable lightdm
fi

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

# sudo promt for password
su
visudo
:%s/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g
:wq

clear
printf "Installation finished successfully\n"
printf "rebooting the system.\n"
printf "press a key to continue...\n"
read < /dev/tty
reboot
