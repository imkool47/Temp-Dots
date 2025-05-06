#!/bin/bash
clear
aur_helper="$(cat ~/.config/imkool/settings/aur.sh)"
figlet -f smslant "Cleanup"
echo
$aur_helper -Scc
