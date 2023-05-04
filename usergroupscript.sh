#!/bin/bash
# Author: Hunter Harkness
# ITEC3328 - Middle GA State University

# Ensure script is only ran by root
if [ $(id -u) != 0 ]; then echo "This script must be run as root."; exit; fi

# Functions
help()
{
echo "Usage : usergroupscript [-g|h|u]"
echo
echo "Options:"
echo
echo "-g                Initialize group creation portion of script. Create groups."
echo "-h                Display help page."
echo "-u                Initialize user creation portion of script. Create user/pass and add to groups."
echo
}

groupcreate()
{
read -p "Group Name: " groupname
while true; do
        read -p "Set custom Group ID (GID)? (y/n): " yn
        case $yn in
                [Yy]* ) # yes
                        read -p "Group ID (GID): " groupid
                        break;;
                [Nn]* ) #no
                        break;;
                 * ) # invalid response
                        echo "Invalid response, try again." ;;
        esac
done
groupadd `if [[ -n $groupid ]]; then echo "-g $groupid"; fi` $groupname
echo "Group created successfully."
}

usercreate() {
read -p "Username:" username
echo "Password:"; read -s password
while true; do
        read -p "Set Custom User ID (UID)?: (y/n)" yn
        case $yn in
                [Yy]* ) # yes
                        read -p "Custom UID: " userid
                        break;;
                [Nn]* ) #no
                        break;;
                * ) # invalid response
                        echo "Invalid response, try again.";;
        esac
done
while true; do
        read -p "Set Custom Primary Group?: (y/n)" yn
        case $yn in
                [Yy]* ) # yes
                        read -p "Custom Primary Group Name:" primarygroup
                        break;;
                [Nn]* ) # no
                        break;;
                * ) # invalid response
                        echo "Invalid response, try again.";;
        esac
done
while true; do
        read -p "Set Secondary Group(s)?: (y/n):" yn
        case $yn in
                [Yy]* ) # yes
                        read -p "Secondary Group(s): (group1,group2...)" secondarygroup
                        break;;
                [Nn]* ) # no
                        break;;
                * ) # invalid response
                        echo "Invalid response, try again.";;
        esac
done
useradd -p $password `if [[ -n "$userid" ]]; then echo "-u $userid"; fi` `if [[ -n "$primarygroup" ]]; then echo "-g $primarygroup"; fi` `if [[ -n "$secondarygroup" ]]; then echo "-G $secondarygroup"; fi` $username
echo "User added successfully."
}

noargs=true
while getopts ":ghu" option; do
        case $option in
                [g] ) # group creation
                        groupcreate
                        exit;;
                [h] ) # display Help
                        help
                        exit;;
                [u] ) # user creation
                        usercreate
                        exit;;
                [\?] ) # invalid option
                        echo "Invalid option. Use -h option for help."
                        exit;;
        esac
        noargs=false
done

#if no arguments specified, display help
[[ $noargs == true ]] && { echo "No option specified.";help; exit; }
