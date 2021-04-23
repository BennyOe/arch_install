# General
This is a install script for Arch Linux with Suckless DWM as window manager.

# Installation
This script is meant to be for my specific fully configured Arch Installation with DWM DWM-Blocks and all the apps I need. The color scheme is Onedark. The Keyboard layout and the timezone is set to german. To Install just boot from the latest Arch ISO http://archlinux.org and execute the first command below. The other scripts will execute automatically.

### Repositories that are used for the installation
- Suckless DWM https://github.com/BennyOe/dwm
- DWM Clocks https://github.com/BennyOe/dwmblocks
- Suckless Simple Terminal https://github.com/papitz/SimpleTerminal
- Dotfiles https://github.com/BennyOe/.dotfiles
- Wallpaper https://github.com/BennyOe/wallpaper

#### Install Arch Linux
curl -sL https://git.io/JOWEH | bash

#### Install XOrg and DWM
curl -sL https://git.io/JOBJn | bash

#### Install additional apps
curl -sL https://git.io/JORTc | bash

## Dual Boot Installation
- Install Windows 
- Resize Windows partition for the Linux install
- Install Arch with this script
- DO NOT CREATE ADDITIONAL PARTITIONS BEFORE INSTALLING ARCH!!!

# Key Bindings

# Installed Applications 
### Base install
iw wpa_supplicant dialog wpa_actiond sudo grub efibootmgr dosfstools os-prober mtools base linux linux-firmware base-devel vim networkmanager git man bash

### GUI install
$graphicsdriver xorg xorg-xinit picom nitrogen rofi dunst yay nerd-fonts-jetbrains-mono pacman-contrib archlinux-contrib sysstat ttf-font-awesome dmenu network-manager-applet gnu-free-fonts zsh papirus-icon-theme gtk4 arc-gtk-theme lxappearance libxft-bgra

### App install
lsd pulseaudio pulseaudio-alsa pavucontrol pa-applet-git ponymix ranger redshift thunar numlockx zathura htop-vim-git neofetch nodejs npm python-pynvim xarchiver unzip lightdm lightdm-mini-greeter zsh-theme-powerlevel10k-git neovim-nightly-bin zsh oh-my-zsh zsh-autosuggestions zsh-syntax-highlighting vim-plug
##### Optional
signal-desktop discord_arch_electron brave-bin flameshot autorandr mailspring whatsapp-for-linux xidlehook intellij-idea-ultimate-edition vlc spotify-tui





############
### TODO ###
############

- lightdm styling
- polkit
- libinputgestures
- bluetooth

############
### Push ###
############


