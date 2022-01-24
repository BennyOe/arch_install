
<div align="center">
  <a href="https://github.com/BennyOe/arch_install/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/BennyOe/arch_install?color=important&style=flat-square" alt="License">
  </a>

  <img src="https://img.shields.io/github/repo-size/BennyOe/arch_install?style=flat-square" alt="Repo size">

  <a href="https://github.com/BennyOe/arch_install/issues">
    <img src="https://img.shields.io/github/issues/BennyOe/arch_install?color=ff0000&style=flat-square" alt="Open issues">
  </a>

  <a href="https://github.com/BennyOe/arch_install/pulse">
    <img src="https://img.shields.io/github/last-commit/BennyOe/arch_install?color=blueviolet&style=flat-square" alt="Last commit">
  </a>
</div>
<h1 align="center">WWCTWArch</h1>

![image](https://user-images.githubusercontent.com/45036971/115892305-52037380-a457-11eb-8ccf-3f60da59f79b.png)

![image](https://user-images.githubusercontent.com/45036971/115956284-4322cc80-a4fc-11eb-8642-418093973a5b.png)

---

# General

This script is for my specific fully configured Arch Installation with a heavily patched DWM, DWM-Blocks and all the apps I need. During the installation there are several options you can choose to customize the installation to your needs. The color scheme is Onedark.
To Install just boot from the latest Arch ISO http://archlinux.org and execute the first command below. The other scripts will execute automatically.

### Install Modes that are supported

| Mode           | UEFI | BIOS |
| -------------- | ---- | ---: |
| Linux only     | X    |    X |
| Dual-Boot      | X    |
| SDA Controller | X    |    X |
| Nvme Contoller | X    |

The patches applied to the Suckless programms can be found in the depending repositories below.

A big shout out to the wonderful people who are doing such great work to explain linux stuff to the masses.

Derek Taylor (Distrotube)
https://www.youtube.com/channel/UCVls1GmFKf6WlTraIb_IaJg

Luke Smith
https://www.youtube.com/channel/UC2eYFnH61tmytImy1mTYvhA

The Linux Cast
https://www.youtube.com/channel/UCylGUf9BvQooEFjgdNudoQg

### Repositories that are used for the installation

-   Suckless DWM https://github.com/BennyOe/dwm
-   DWM Blocks https://github.com/BennyOe/dwmblocks
-   Suckless Simple Terminal https://github.com/papitz/SimpleTerminal
-   Dotfiles https://github.com/BennyOe/.dotfiles
-   NVim https://github.com/papitz/nvim
-   Wallpaper https://github.com/BennyOe/wallpaper

---

# Installation

#### Dual Boot Installation (Optional)

-   Install Windows
-   Resize Windows partition for the Linux install
-   Install Arch with this script
-   DO NOT CREATE ADDITIONAL PARTITIONS BEFORE INSTALLING ARCH!!!

#### WLAN

if running a device with WLAN run these commands to connect to the internet

    iwctl device list
    iwctl station <DEVICE> scan
    iwctl station <DEVICE> get-networks
    iwctl station <DEVICE> connect <SSID>

#### Run the base install script

to fetch and execute the script run the command:

    curl -sL https://git.io/JOWEH | bash

#### Install XOrg, DWM & Applications

This script gets called automatically after the base install script. If you wish to execute manually, please run

    curl -sL https://git.io/JOBJn | bash

---

# Post installation

Enable the sudo command promt for a password run the commands

    su
    visudo
    uncomment the line %wheel ALL=(ALL) ALL
    comment the line %wheel ALL=(ALL) NOPASSWD: ALL

#### Intellij and java applications

to get java swing or java fx applications working in dwm add this line to your ```/etc/profile```

     export _JAVA_AWT_WM_NONREPARENTING=1

#### Autologin in lightdm

uncomment the following line in ```/etc/lightdm/lightdm.conf``` and add your user

    [Seat:*]
    autologin-user=<USERNAME>

execute the following commands

    groupadd -r autologin
    gpasswd -a <USENAME> autologin

to avoid race conditions uncomment the following line

      #logind-check-graphical=false

#### autorandr

1. Set the desired screen layout with arandr or xrandr
2. Save the config with `autorandr -s <PROFILENAME>`

#### pulse audio

disable switching to idle mode if audio is not used
comment out the following line in ```/etc/pulse/default.pa``` and restart

    # load-module module-suspend-on-idle

#### spotifyd

to set the password in your keyring execute the following command

    secret-tool store --label='name you choose' application rust-keyring service spotifyd username <your-username>
    
to setup the spotifyd daemon create ```~/.config/spotifyd/spotifyd.conf``` and add this config [https://spotifyd.github.io/spotifyd/config/File.html](config file)

#### Sync the systemclock

    systemctl enable systemd-timesyncd.service

#### Auto mount network drives

create a file where you store your username and password

    username=<USERNAME>
    password=<PASSWORD>

in /etc/fstab create entry

    # Local drive
     UUID=<UUID>                          /home/<USER>/<MOUNTPOINT>         ntfs-3g         umask=000,dmask=027,fmask=137,uid=1000,gid=1000,windows_names       0 0

    # Network mount
    //192.168.1**.**/<SHARE>              /home/<USER>/<MOUNTPOINT>         cifs            uid=1000,credentials=/home/<CREDENTIAL FILE>,iocharset=utf8,x-systemd.automount    0 0

mount with Label

    LABEL=<DEVICENAME>  <MOUNTPOINT>    <FSTYPE>    umask=000,dmask=027,fmask=137,uid=1000,gid=1000,windows_names       0 0

#### Power button

set the following line in ```/etc/systemd/logind.conf```

    HandlePowerKey=suspend

#### Keyring authentication at login

add the following two lines at ```/etc/pam.d/login```

    auth optional pam_gnome_keyring.so
    session optional pam_gnome_keyring.so auto_start

Login keyring needs to be the default keyring. Can be set via seahorse.

#### setting standard applications with thunar

    open settings manager
    set default apps
    set terminal emulator to /usr/local/bin/st
    on "others" filter "plain"
    for text/plain choose application
    use a custom command
    st -e nvim

#### setting up docker

    systemctl enable docker
    systemctl start docker
    sudo groupadd docker
    sudo usermod -aG docker $USER

#### Neo-Vim

run ```:PackerSync```to intall all Vim plugins etc

---

# Surface

On Surface devices run this command to install the Surface kernel

    curl -sL https://git.io/JO9G5 | bash

Set the resolution and scale of the device in the ```~/.dwm/autostart.sh```

    xrandr -s 2736x1824
    xrandr --output eDP1 --scale 0.7
    
#### adding Windows to grub if needed

get the UUID from the EFI partition with ```lsblk -o +UUID```
edit the ```/etc/grub.d/40_custom```

    menuentry "Windows 10" --class windows --class os {
    insmod ntfs
    search --no-floppy --set=root --fs-uuid $your_uuid_here$
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }

run ```sudo update-grub```

#### when booting takes over 1 minute

edit ```/etc/fstab``` and comment out the swap partition line

---

# Key Bindings

#### Basic controls

| Key                  |                 Action |
| -------------------- | ---------------------: |
| mod + space          |      Rofi App launcher |
| mod + return         |               terminal |
| mod + b              |              togglebar |
| mod + j              |       focus stack down |
| mod + k              |         focus stack up |
| mod + up             |  increase master count |
| mod + down           |  decrease master count |
| mod + l              |   increase master size |
| mod + h              |   decrease master size |
| mod + shift + j      |   move window stack up |
| mod + shift +k       | move window stack down |
| mod + shift + return |   toggle master window |
| mod + tab            |     cycle through tags |
| mod + q              |            kill window |

#### Layout manipulation

| Key                 |        Action |
| ------------------- | ------------: |
| mod + ctrl + comma  | cyclelayout - |
| mod + ctrl + period | cyclelayout + |

#### Switch to specific layouts

| Key                |                  Action |
| ------------------ | ----------------------: |
| mod + m            |       set master layout |
| mod + f            |              fullscreen |
| mod + space        |      toggle last layout |
| mod + shift +space |          togglefloating |
| mod + 0            |           view all tags |
| mod + shift + 0    | move window to all tags |

#### switching between monitors

| Key                |              Action |
| ------------------ | ------------------: |
| mod + comma        |  focus prev monitor |
| mod + period       |  focus next monitor |
| mod + ctrl + left  | tag to prev monitor |
| mod + ctrl + right | tag to next monitor |

#### Gaps

| Key             |         Action |
| --------------- | -------------: |
| mod + y         |  increase gaps |
| mod + shift + y | decreaase gaps |
| mod + ctrl y    |    toggle gaps |
| mod + alt + y   |   default gaps |

#### Scratchpads

| Key                 |            Action |
| ------------------- | ----------------: |
| mod + p             |     togglescratch |
| mod + minus         |   scratchpad show |
| mod + shift + minus |   scratchpad hide |
| mod + =             | scratchpad remove |

#### Tags

| Key                     |        Action |
| ----------------------- | ------------: |
| mod + backspace         | shutdown menu |
| mod + shift + backspace |      quit dwm |
| mod + shift + r         |    reload dwm |

#### Keyboard Layout

| Key            |                  Action |
| -------------- | ----------------------: |
| mod + ctrl + e |     switch to US layout |
| mod + ctrl + d | switch to german layout |

#### Apps

| Key             |                  Action |
| --------------- | ----------------------: |
| mod + c         |           brave browser |
| mod + x         |                  ranger |
| mod + e         |                  thunar |
| mod + ctrl + l  |         multilockscreen |
| mod + shift + c | discord signal whatsapp |
| mod + shift + t |              kill picom |
| mod + ctrl + t  |             start picom |
| mod + ctrl + m  |             pavucontrol |
| mod + shift + m |              mailspring |
| mod + shift + s |               flameshot |
| mod + ctrl + e  |        english keyboard |
| mod + ctrl + d  |         german keyboard |

---

# Installed Applications

### Base install

    iw wpa_supplicant dialog wpa_actiond sudo grub efibootmgr dosfstools os-prober mtools base linux linux-firmware
    base-devel vim networkmanager git man bash

### GUI install

    $graphicsdriver xorg xorg-xinit picom nitrogen rofi dunst yay nerd-fonts-jetbrains-mono pacman-contrib
    archlinux-contrib sysstat ttf-font-awesome dmenu network-manager-applet gnu-free-fonts zsh papirus-icon-theme
    gtk4 arc-gtk-theme lxappearance timeshift grub-customizer polkit polkit-gnome feh bluez bluez-utils blueman
    viewnior xcape multilockscreen libxft-bgra lsd pulseaudio pulseaudio-alsa pavucontrol pa-applet-git ponymix
    ranger redshift thunar numlockx zathura htop-vim-git neofetch nodejs npm python-pynvim xarchiver unzip ueberzug
    lightdm lightdm-mini-greeter zsh-theme-powerlevel10k-git neovim zsh oh-my-zsh zsh-autosuggestions
    zsh-syntax-highlighting vim-plug gotop gotop cifs-utils ntfs-3g xclip zathura-pdf-mupdf udisks thunar-volman
    pulseaudio-bluetooth lazygit pamixer gvfs xfce4-settings zip-3.0-9 bat ripgrep fd networkmanager-openconnect xdotool

##### Optional

    signal-desktop discord_arch_electron brave-bin flameshot autorandr mailspring whatsapp-for-linux xidlehook
    intellij-idea-ultimate-edition intellij-idea-ultimate-edition-jre jre-openjdk vlc spotify-tui playerctl spotifyd-full-git docker docker-compose

---

############

### TODO

############

-   dwm fake fullscreen fix
-   test nvme with bios
-   test dual with bios
-   ctags dwm
