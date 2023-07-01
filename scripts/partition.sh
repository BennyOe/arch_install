#!/bin/bash

# Partition script
partition_script() {
  if [[ "$1" == "--auto" && "$2" == "--dualboot" ]]; then
    parted -s "${device}" \
      mklabel gpt \
      mkpart ESP fat32 1MiB 513MiB \
      set 1 boot on \
      mkpart primary ext4 513MiB 100% \
      mkpart primary ntfs 100% 100%

    mkfs.fat -F32 "${device}1"
    mkfs.ext4 "${device}2"
    mkfs.ntfs "${device}3"
  elif [[ "$1" == "--auto" ]]; then
    parted -s "${device}" \
      mklabel gpt \
      mkpart ESP fat32 1MiB 513MiB \
      set 1 boot on \
      mkpart primary ext4 513MiB 100%

    mkfs.fat -F32 "${device}1"
    mkfs.ext4 "${device}2"
  elif [[ "$1" == "--dualboot" ]]; then
    parted -s "${device}" \
      mklabel gpt \
      mkpart ESP fat32 1MiB 513MiB \
      set 1 boot on \
      mkpart primary ntfs 513MiB 100%

    mkfs.fat -F32 "${device}1"
    mkfs.ntfs "${device}2"
  else
    parted -s "${device}" \
      mklabel gpt \
      mkpart ESP fat32 1MiB 513MiB \
      set 1 boot on \
      mkpart primary ext4 513MiB 100%

    mkfs.fat -F32 "${device}1"
    mkfs.ext4 "${device}2"
  fi

  if [[ "$1" == "--dualboot" ]]; then
    mount "${device}2" /mnt
    mkdir -p /mnt/boot/efi
    mount "${device}1" /mnt/boot/efi
  else
    mount "${device}1" /mnt
  fi
}
