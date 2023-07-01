#!/bin/bash

get_user_input() {
    show_keyboard_layout_dialog
    select_installation_disk
    select_dual_boot_option
    get_hostname
    get_admin_username
    get_admin_password
}

show_keyboard_layout_dialog() {
    lang=$(dialog --title 'Keyboard Layout' --stdout --default-item '1' --menu 'Select:' 0 0 0 1 'English' 2 'German')

    # load the keyboard layout
    if [ $lang == 2 ]; then 
        printf "loading german keyboard layout...\n"
        sleep 1
        loadkeys de-latin1
    fi
}

select_installation_disk() {
    devicelist=$(lsblk -dplnx size -o name,size | grep -Ev "boot|rpmb|loop" | tac)
    device=$(dialog --stdout --menu "Select installation disk" 0 0 0 ${devicelist}) || exit 1
}

select_dual_boot_option() {
    dualboot=0
    exec 3>&1
    selection=$(dialog \
        --title "Dual Boot" \
        --clear \
        --menu "Please select:" 0 0 4 \
        "1" "Only Linux" \
        "2" "Windows Dual Boot (only with EFI)" \
        2>&1 1>&3)
    case $selection in
        0 )
            clear
            echo "Program terminated."
            ;;
        1 )
            dualboot=0
            echo "${dualboot}"
            ;;
        2 )
            dualboot=1
            echo "${dualboot}"
            ;;
    esac
}

get_hostname() {
    hostname=$(dialog --stdout --inputbox "Enter hostname" 0 0) || exit 1
    clear
    : ${hostname:?"hostname cannot be empty"}
}

get_admin_username() {
    user=$(dialog --stdout --inputbox "Enter admin username" 0 0) || exit 1
    clear
    : ${user:?"user cannot be empty"}
}

get_admin_password() {
    password=$(dialog --stdout --passwordbox "Enter admin password" 0 0) || exit 1
    clear
    : ${password:?"password cannot be empty"}
    password2=$(dialog --stdout --passwordbox "Enter admin password again" 0 0) || exit 1
    clear
    [[ "$password" == "$password2" ]] || ( printf "Passwords did not match"; exit 1; )
    clear
}

get_user_input
