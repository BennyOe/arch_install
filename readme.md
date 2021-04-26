# General
This is a install script for Arch Linux with Suckless DWM as window manager.

![image](https://user-images.githubusercontent.com/45036971/115892305-52037380-a457-11eb-8ccf-3f60da59f79b.png)

![image](https://user-images.githubusercontent.com/45036971/115956284-4322cc80-a4fc-11eb-8642-418093973a5b.png)



# General
This script is meant to be for my specific fully configured Arch Installation with DWM DWM-Blocks and all the apps I need. The color scheme is Onedark. The Keyboard layout and the timezone is set to german. To Install just boot from the latest Arch ISO http://archlinux.org and execute the first command below. The other scripts will execute automatically.

The patches applied in the Suckless programms can be found in the depending repositories below.

### Repositories that are used for the installation
- Suckless DWM https://github.com/BennyOe/dwm
- DWM Blocks https://github.com/BennyOe/dwmblocks
- Suckless Simple Terminal https://github.com/papitz/SimpleTerminal
- Dotfiles https://github.com/BennyOe/.dotfiles
- Wallpaper https://github.com/BennyOe/wallpaper

-----------------

# Installation

#### Dual Boot Installation (Optional)
- Install Windows 
- Resize Windows partition for the Linux install
- Install Arch with this script
- DO NOT CREATE ADDITIONAL PARTITIONS BEFORE INSTALLING ARCH!!!

#### WLAN
if running a device with WLAN run these commands to connect to the internet

    iwctl device list
    iwctl station <device> scan
    iwctl station <device> get-networks
    iwctl station <device> connect <SSID>

#### Run the base install script
to fetch and execute the script run the command:
    
    curl -sL https://git.io/JOWEH | bash

#### Install XOrg, DWM & Applications
This script gets called automatically after the base install script. 

    curl -sL https://git.io/JOBJn | bash
    
# Post installation
To change that the sudo command promt for a password run the commands

    su
    visudo
    uncomment the line %wheel ALL=(ALL) ALL
    comment the line %wheel ALL=(ALL) NOPASSWD: ALL
    
## Surface

On Surface devices run this command to install the Surface kernel

    curl -sL https://git.io/JO9G5 | bash
    
Set the resolution and scale of the device in the ~/.dwm/autostart.sh

    xrandr -s 2736x1824 
    xrandr --output eDP1 --scale 0.7
    
For autorandr:
1. Set the desired screen layout with arandr or xrandr
2. Save the config with `autorandr -s <PROFILENAME>`
    
-------------------

# Key Bindings

#### Basic controls

 Key                        | Action       
 -------------------------  | -------------:
mod + space                 |       Rofi App launcher
mod + return                |       terminal      
mod + b                     |       togglebar
mod + j                     |       focus stack down
mod + k                     |       focus stack up
mod + up                    |       increase master count
mod + down                  |       decrease master count
mod + l                     |       increase master size
mod + h                     |       decrease master size
mod + shift + j             |       move window stack up
mod + shift +k              |       move window stack down
mod + shift + return        |       toggle master window
mod + tab                   |       cycle through tags
mod + q                     |       kill window


#### Layout manipulation

Key                        | Action       
 ------------------------- | -------------:
mod + ctrl + comma         |        cyclelayout -
mod + ctrl + period        |        cyclelayout +

#### Switch to specific layouts 

Key                        | Action       
 ------------------------- | -------------:
mod + m                    |         set master layout
mod + f                    |         fullscreen
mod + space                |         toggle last layout
mod + shift +space         |         togglefloating
mod + 0                    |         view all tags
mod + shift + 0            |         move window to all tags

#### switching between monitors 

Key                        | Action       
 ------------------------- | -------------:
mod + comma                |        focus prev monitor
mod + period               |        focus next monitor 
mod + ctrl + left          |        tag to prev monitor
mod + ctrl + right         |        tag to next monitor

#### Gaps

Key                        | Action       
 ------------------------- | -------------:
mod + y                    |        increase gaps
mod + shift + y            |        decreaase gaps
mod + ctrl y               |        toggle gaps
mod + alt + y              |        default gaps

#### Scratchpads

Key                        | Action       
 ------------------------- | -------------:
mod + p                    |       togglescratch
mod + minus                |       scratchpad show
mod + shift + minus        |       scratchpad hide
mod + =                    |       scratchpad remove

#### Tags

Key                        | Action       
 ------------------------- | -------------:
mod + backspace            |        shutdown menu
mod + shift + backspace    |        quit dwm
mod + shift + r            |        reload dwm

#### Apps

Key                        | Action       
 ------------------------- | -------------:
mod + c                    |        brave browser
mod + x                    |        ranger
mod + e                    |        thunar
mod + ctrl + l             |        multilockscreen
mod + shift + c            |        discord signal whatsapp
mod + shift + t            |        kill picom
mod + ctrl + t             |        start picom
mod + ctrl + m             |        pavucontrol
mod + shift + m            |        mailspring
mod + shift + s            |        flameshot
mod + ctrl + e             |        english keyboard
mod + ctrl + d             |        german keyboard



------------------

# Installed Applications 
### Base install
    iw wpa_supplicant dialog wpa_actiond sudo grub efibootmgr dosfstools os-prober mtools base linux linux-firmware 
    base-devel vim networkmanager git man bash

### GUI install
    $graphicsdriver xorg xorg-xinit picom nitrogen rofi dunst yay nerd-fonts-jetbrains-mono pacman-contrib 
    archlinux-contrib sysstat ttf-font-awesome dmenu network-manager-applet gnu-free-fonts zsh papirus-icon-theme 
    gtk4 arc-gtk-theme lxappearance libxft-bgra lsd pulseaudio pulseaudio-alsa pavucontrol pa-applet-git ponymix 
    ranger redshift thunar numlockx zathura htop-vim-git neofetch nodejs npm python-pynvim xarchiver unzip lightdm 
    lightdm-mini-greeter zsh-theme-powerlevel10k-git neovim-nightly-bin zsh oh-my-zsh zsh-autosuggestions 
    zsh-syntax-highlighting vim-plug
    
##### Optional
    signal-desktop discord_arch_electron brave-bin flameshot autorandr mailspring whatsapp-for-linux xidlehook 
    intellij-idea-ultimate-edition vlc spotify-tui


############
### TODO ###
############
- fake fullscreen fixen
