# fafSTACK  [W.I.P.]

A shell script that installs a so-called fafSTACK on linux
![warty-final-ubuntu](https://user-images.githubusercontent.com/5132359/53690402-25b5a600-3d6a-11e9-94cd-3ac2fc06cf9a.png)


# User-Guide

### 1st

download installfaf.sh anywhere. (go to that dirrectory in your terminal, EXAMPLE: `cd Downloads`)

### 2nd

make it executable : (terminal) `chmod +x installfaf.sh`

### 3rd 

run the script within a terminal : `./installfaf.sh`

you'll be asked in order :
- your steam account usename
- your steam account password
- your linux session password

### 4rth

at a certain point steam starts up and you'll need to enter the Steam Guard code
once steam is opened
1. right click on "Supreme Commander - Forged Alliance" in your games Library" -> "SET LAUCNH OPTIONS..." and enter the contents of "the contents of this file are to be pasted in the forged alliance properties launch options" situated in your home folder, just in case, here they are : `PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1, PROTON_USE_GALLIUM_NINE=1, PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1" %command%`
2. go into "Steam" -> "Setting" -> "Steam Play" -> "Enable Steam Play for all other titles" (Gallium-nine should be the proton version)

it will ask to restart.

when steam starts again use steam's icon in the notifications area to quit steam.

### 5th

then it's off and you can got to your pillates class and when you come back it should have just barely finished installing Forged Alliance + FAF on your linux system

Forged Alliance should be running, you can set a profile, then set your prefered resulution, then quit the game.

### 6th

use your trusty terminal :

```
cd ~/faf
./downlords-faf-client
```

then with faf running, log in and set your preferences under "Forged Alliance Forever":
![screenshot from 2019-03-03 04-27-31](https://user-images.githubusercontent.com/5132359/53690540-c0af7f80-3d6c-11e9-9e83-36a25ce7e1f3.png)

"Game Location" :
```
/home/USERNAME/.steam/steam/steamapps/common/Supreme Commander Forged Alliance
```
"Command line format for executable" :
```
/home/USERNAME/.steam/compatibilitytools.d/Proton/dist/bin/wine "%s"
```
"Execution Dirrectory" :
```
/home/USERNAME/.faforever/bin
```
where "USERNAME" is what you get when you type `echo $USER` into the terminal.

try two join to games and on the second run in your terminal :

```
chmod +x ~/.faforever/bin/ForgedAlliance.exe
```
### 7th

GL HF!

# Pre-requisites 

- a steam account with Forged Alliance activated on it (9420)
- a linux system (preferably debian-based such as ubuntu,  for further compatibility please contribute)
- no pre-existing java version (preferably)
- preferably an untouched /etc/environement file
- have at least a total of 11.7GB of free space on boot drive
- be willing to write to your boot drive
- be willing to have stuff put into both /etc/environement and .bashrc
