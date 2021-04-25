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
    xrandr --output eDP1 --scale 0.6
    
For autorandr:
1. Set the desired screen layout with arandr or xrandr
2. Save the config with `autorandr -s <PROFILENAME>`
    
-------------------

# Key Bindings

#### Basic controls
mod + space             Rofi App launcher
mod + return            terminal
mod + b                 togglebar
mod + j                 focus stack down
mod + k                 focus stack up
mod + up                increase master count
mod + down              decrease master count
mod + l                 increase master size
mod + h                 decrease master size
mod + shift + j         move window stack up
mod + shift +k          move window stack down
mod + shift + return    toggle master window
mod + tab               cycle through tags
mod + q                 kill window


#### Layout manipulation
MODKEY|ControlMask,           comma,  cyclelayout,
MODKEY|ControlMask,           period, cyclelayout,

#### Switch to specific layouts 
MODKEY,                       m,      setlayout,
MODKEY,                       f,      fullscreen,
MODKEY,                       space,  setlayout,
MODKEY|ShiftMask,             space,  togglefloating,
MODKEY,                       0,      view,
MODKEY|ShiftMask,             0,      tag,

#### switching between monitors 
MODKEY,                       comma,  focusmon,
MODKEY,                       period, focusmon,
MODKEY|ControlMask,           Left,   tagmon,
MODKEY|ControlMask,           Right,  tagmon,

#### Gaps
MODKEY,                       y,      incrgaps,
MODKEY|ShiftMask,             y,      incrgaps,
MODKEY|ControlMask,           y,      togglegaps,
MODKEY|Mod1Mask,              y,      defaultgaps,

#### Scratchpads
MODKEY,                       p,      togglescratch,
MODKEY,                       minus, scratchpad_show,
MODKEY|ShiftMask,             minus, scratchpad_hide,
MODKEY,                       equal,scratchpad_remove,

#### Tags
AGKEYS(                        1,
AGKEYS(                        2,
AGKEYS(                        3,
AGKEYS(                        4,
AGKEYS(                        5,
AGKEYS(                        6,
AGKEYS(                        7,
AGKEYS(                        8,
AGKEYS(                        9,
MODKEY,                       BackSpace,   spawn,
MODKEY|ShiftMask,             BackSpace,   quit,
MODKEY|ShiftMask,             r,           quit,

#### Apps
MODKEY,                       c,     spawn,
MODKEY,                       x,     spawn,
MODKEY,                       e,     spawn,
MODKEY|ControlMask,           l,     spawn,
MODKEY|ShiftMask,             c,     spawn,
MODKEY|ShiftMask,             t,     spawn,
MODKEY|ControlMask,           t,     spawn,
MODKEY|ControlMask,           m,     spawn,
MODKEY|ShiftMask,             m,     spawn,
MODKEY|ShiftMask,             s,     spawn,
MODKEY|ControlMask,           e,     spawn,
MODKEY|ControlMask,           d,     spawn,



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

- lightdm styling
- libinputgestures
- bluetooth
- Grub Styling and silencing
- promt for password when executing sudo app with rofi


