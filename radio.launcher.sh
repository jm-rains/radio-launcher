#!/bin/bash
#
# ****  Radio Launcher  ****
#
# A simple script to open PyRadio in a separate shell window.
#
# ***********************
# Justin M. Rains
# jmrains@protonmail.com
# github.com/jm-rains
#
# radio.launcher.sh
# v. 22.05.1
# 10 May 2022
# ***********************
#
# DEPENDENCIES: gnome-terminal
#               wmctrl
#               awk
#               pyradio
#
#
# This script launches PyRadio in its own simple window. It
# directs gnome-terminal to open a new window (stripped of the
# menu bar and sized appropriately), and then launch PyRadio,
# suppressing all feedback output.
#
# The script initially checks to determine if PyRadio is already
# running. If it is, the script brings the PyRadio window to the
# fore. When mapped to a hotkey, this feature ensures that
# PyRadio is always at the ready.
#
# This script can be adapted for other terminal
# emulators, such as the mate-terminal. Functionality will
# differ according to the terminal used, as well as the
# desktop environment.
#
#  --------------------------------------------------------------
#
# Symbolically link this script to a directory included in PATH.
#
# In my setup, linked as follows:
# $ sudo ln -s $HOME/.scripts/radio.launcher.sh
# > $HOME/.local/bin/radio
#
# ---------------------------------------------------------------
#
# OPTIONAL (but recommended)
#
# Set a keyboard shortcut via your desktop settings to run the
# script. On my systems, <super>-<r> fires this script.
#
#################################################################

# [ Part 0 ] Choose a terminal profile
#            To use default, delete '--profile=$Profile' from
#            launch command in Part III.

Profile="Radio"

# ***************************************************************

# [ Part I ] Set dimensions of radio window

# 0 - Set adjuster variables. These accommodate the headers,
#     borders, enumeration, etc. Adjust as necessary.

Height_Addition=4
Width_Addition=7

# 1 - Set a minimum window width. If stations entries are shorter
#     than a reasonable width, this value will be used to set the
#     window's width. Adjust as desired.

Min_Width=60

# 2 - Point to the user's stations list
Stations_List="/$HOME/.config/pyradio/stations.csv"

# 3 - Count the lines in the stations list
Stations_List_Lines=$(wc -l $Stations_List)

# 4 - Strip the superfluous output (leave numbers only)
Stations_Total="$( cut -d ' ' -f 1 <<< "$Stations_List_Lines" )"

# 5 - Do maths to get the desired height
Window_Height="$((Stations_Total + Height_Addition))"

# 6 - Get the length of the longest entry in the stations list
Max_Entry_Width=$(awk -F "\"*,\"*" '{print $1}' $Stations_List \
	        | awk '{ if ( length > L ) { L=length} } \
                END{ print L}')

# 7 - Do maths to get the probable desired width
Window_Width="$((Max_Entry_Width + Width_Addition))"

# 8 - Substitute min width if calculated width is too narrow
if ((Window_Width <  Min_Width))
then Window_Width=$Min_Width
     fi

# 9 - Finally, make a window dimension variable for Part III
Window_Size="${Window_Width}x${Window_Height}"

# ***************************************************************

# [ Part II ] Test to determine whether PyRadio is running
if pgrep -x pyradio &>/dev/null

# if already running, bring into current desktop
# and throw the radio window in front
then wmctrl -a PyRadio

# if not running, proceed to launch
else

# ***************************************************************

# [ Part III ] Launch a new terminal with PyRadio

# launch with normal attributes; title the terminal window
# to enable subsequent executions of the script to check
# for an already running instance of PyRadio
    gnome-terminal --profile=$Profile --title="PyRadio" \
		   --hide-menubar --geometry=$Window_Size \
		   -- pyradio &>/dev/null

fi

# [END] #########################################################

# A NOTE ABOUT PYRADIO & THIS SCRIPT ****************************
#
# PyRadio is an outstanding project. It is one of the first
# things I install on any new machine, and I use it almost every
# day, throughout the day. It is available here:
#
# https://github.com/coderholic/pyradio
#
# My only relationship to PyRadio is that of an enthusiastic
# user. This script has no claim to any of PyRadio's
# awesomeness and is merely an enhanced launcher therefor.
# Note that this script can (and has been) adapted to launch
# other ncurse-based terminal applications, such as calcurse.
#
# ***************************************************************
