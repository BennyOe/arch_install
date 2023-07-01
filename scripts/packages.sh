#!/bin/bash

# Package installation script
install_packages() {
  case $1 in
    1)
      arch_chroot su - ${user} <<EOF
      yay -S --noconfirm i3-gaps i3status dmenu rofi
EOF
      ;;
    2)
      arch_chroot su - ${user} <<EOF
      yay -S --noconfirm awesome dmenu rofi
EOF
      ;;
    *)
      ;;
  esac
}
