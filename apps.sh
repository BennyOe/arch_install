#!/bin/bash

#### TODO ####


#################
#### Welcome ####
#################
bootstrapper_dialog --title "Welcome" --msgbox "Welcome to the Apps Installation.\n" 6 60

##################
### User Input ###
##################

# app folder
appfolder=$(dialog --stdout --inputbox "Enter additional apps" 0 0) || exit 1
clear

echo $appfolder
