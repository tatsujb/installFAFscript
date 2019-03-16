# faf.sh 2.0

## (first succesfull run! ubuntu 18.04.2 [11/03/2019] )
contributions welcome!

A shell script that installs and configures [FA](https://store.steampowered.com/app/9420/Supreme_Commander_Forged_Alliance/ "Supreme Commander Forged Alliace") + [FAF](https://faforever.com "Forged Alliace Forever") multiplayer client on linux
[![how to install on ubuntu](https://user-images.githubusercontent.com/5132359/53690402-25b5a600-3d6a-11e9-94cd-3ac2fc06cf9a.png)](https://www.youtube.com/watch?v=c5K7QmK-Xas)

### Run successes (by distro) :

Version | Distro | distro+DE |  | Comment
--- | --- | --- | --- | ---
18.04.2, 18.10 | [![how to install on ubuntu](https://img.apk.cafe/img:bz00eXFremMmbD00MjQmaD1wbmcmZj1HbGk5MCZpPTA)](https://www.youtube.com/watch?v=c5K7QmK-Xas) | ubuntu (gnome3) | :heavy_check_mark: | base of script
19.1 | ![linuxmint](https://user-images.githubusercontent.com/5132359/54205373-7ea5dc80-44d6-11e9-851e-940f3742c1d4.png) | Mint (Cinnamon) | :heavy_check_mark: | likely closest behavior to stock ubuntu. nothing needed to change from base, worked out-of-the-box.
18.04.2, 18.10 | ![kubuntu](https://user-images.githubusercontent.com/5132359/54205501-c75d9580-44d6-11e9-91fa-ee67fff0e3f8.png) | Kubuntu (Plasma) | :heavy_check_mark: | two adaptations were made for kubuntu to work: detecting plasma + ubuntu = (kubuntu if case). Also gnome-terminal was traded out in favor of konsole.
12.4 | ![zorin](https://user-images.githubusercontent.com/5132359/54295562-92734080-45b3-11e9-95ed-627f2931ec94.png) | Zorin (zorin) | :heavy_check_mark:  | debconf-set-selections for steam is for some reason borked on zorin, trying to auto-accept the eula will result in the opposite. You'll have two eula accepting manual steps added to your process. really minor.
5.0 | ![elementary-s](https://user-images.githubusercontent.com/5132359/54205279-59b16980-44d6-11e9-9f65-5c191eb33645.png) | Elementary (Pantheon) | :heavy_check_mark: | used xterm instead of gnome-terminal. Also I didn't know how to shut down steam, there was no tray icon, I used htop 
9.8 | ![debian](https://user-images.githubusercontent.com/5132359/54201700-99745300-44ce-11e9-8435-dc65f98a2147.png) | Debian (gnome3) | :heavy_multiplication_x: | Comming along nicely, I won't be using sudo but instead forcing the user to run as root. the script will therfore deduce which folder is the user's home folder simply based on size of /home's chirldren and cd to that. I know this is iffy but it's the best I've got.
29 | ![Fedora](https://user-images.githubusercontent.com/5132359/54399527-2978ef00-46bf-11e9-8418-0031c7e991f7.png) | Fedora (gnome3) | :heavy_multiplication_x: | 
18.0.4 | ![manjaro](https://user-images.githubusercontent.com/5132359/54216185-76a36800-44e9-11e9-9e32-52d6a4071643.png) | Manjaro (Plasma) | :heavy_multiplication_x: | 
18.10 | ![centos](https://user-images.githubusercontent.com/5132359/54216744-88393f80-44ea-11e9-8536-9fbd56ad3913.png) | CenT OS (gnome3) | :heavy_multiplication_x: | 
10.14 | ![apple](https://user-images.githubusercontent.com/5132359/54368435-6d92d200-4674-11e9-922f-9aebabfd7ca2.png) | Apple (Aqua) | :heavy_multiplication_x: | 


#### What does faf.sh do?

faf.sh sets up, on your non-windows PC, a set of software and environment settings and folder names and configs allowing you to enjoy the delights of playing [Forged Alliace Forever](https://faforever.com "Forged Alliace Forever") as you would under windows.

such a setup includes (at minimum) :

 - [Supreme Commander Forged Alliance]("https://store.steampowered.com/app/9420/Supreme_Commander_Forged_Alliance/")
 - (FAF) JAVA client
 - Java 10
 - Gallium-Proton /or/ Proton /or/ Wine (to run the windows game)
 
In the case of this script, we will have recourse to some supplementary items in order to automate our task :

 - curl (fetches installers from git)
 - steamCMD (downloads the game) 
 - steam (installs it)
 - pv (progress indicators)
 
 Dependencies :
 
 - lib32gcc1 (steamCMD)
 - libd3dadapter9-mesa:i386 libd3dadapter9-mesa (Gallium-Proton)

# User-Guide

(read entirely before running)

### warmup 

Do not run script as root! (Debian being an exception)

Ideally run on a fresh system with nothing (such as steam) currently open, although the script has been known to work in those cases.

### 1st

click on installfaf.sh above, then click on "RAW", then type <kbd>Ctrl</kbd> + <kbd>S</kbd>, (you can place anywhere, in home folder is comfortable to work with), then <kbd>Enter</kbd> to save file.

### 2nd

make it executable : (terminal) `chmod +x installfaf.sh`

### 3rd 

run the script within a terminal : `./installfaf.sh` 

you'll be asked in order :
- your steam account usename
- your steam account password
- your linux session password
- if you want Gallium Nine or not

### 4rth

(be fast here)
at a certain point steam starts up and you'll need to enter Steam Guard.

1. right click on "Supreme Commander - Forged Alliance" in your games Library" -> "SET LAUNCH OPTIONS..." and enter the contents of "the contents of this file are to be pasted in the forged alliance properties launch options" situated in your home folder, just in case, here they are (gallium-nine example) : `PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1, PROTON_USE_GALLIUM_NINE=1, PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1" %command%`
(vanilla proton example) : `PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1 %command%`
2. go into "Steam" -> "Setting" -> "Steam Play" -> "Enable Steam Play for all other titles" (Gallium-nine should already be preselected in the drop-down. obv. if you chose normal proton, it will be proton 3.16-8 Beta)

it will ask to restart.

when steam starts don't login just close both login windows, this will allow the rest of the script to continue. (if you accidentally logged in at this step, that's fine, just use the tray area icon to close steam, when steam is closed the script will continue)

### 5th

Then it downloads Forged Alliance. this will take a while.
Once it's done steam starts again in order to finalize installation (non root hard drive installation is not supported. (E.G.: to a secondary storage HHD, for now I only support installing to SDA.)) and then start Forged Alliance.

accept terms.

Forged Alliance should start, you can set a profile, then set your prefered resolution, then quit the game. (use steam's notification-area icon to close steam once again, to allow the script to continue)

### 6th

FAF is running, log in and set your preferences under "Forged Alliance Forever":
![faf settings](https://user-images.githubusercontent.com/5132359/54316944-2cea7880-45e2-11e9-9e93-65b597d81363.png)


"Game Location" :
```
/home/USERNAME/.steam/steam/steamapps/common/Supreme Commander Forged Alliance
```
"Command line format for executable" :
```
/home/USERNAME/faf/run "%s"
```


where "USERNAME" is what you get when you type `echo $USER` into the terminal.



### 7th

the script is now done.

after you close FAF / your terminal, to run FAF again you'll have to :

```
source ~/.bashrc
cd ~/faf
./downlords-faf-client
```
the first time, and just :
```
cd ~/faf
./downlords-faf-client
```
everytime you want to run FAF after that.

if certain types of game modes don't run it may be because you need to : 

```
chmod +x -R ~/.faforever/bin/ForgedAlliance.exe
```
but normally this shouldn't be needed.

Working on creating a launcher as part of the script, help wanted!

GL HF!

## Not working ?

Feedback will help me fix things. This script creates a very minimal log file called "faf_sh-\*.log" in your home. Paste it's contents as part of an issue/bug report. your first and foremost issue is probably the linux distro flavor, you can check what release is supported as of now [here](https://github.com/tatsujb/installFAFscript#run-successes-by-distro- "distro compatibility"), but a couplesyntax edits should make my script work for you.

### known issues :

- "game already running" preventing steam restart after enabling proton; or preventing install finislazion after download : 

this happens mostly when you're running this script for the second time (reinstalling) without a reboot.

If removing everything, rebooting and reinstalling is too much of a hassle (because of how much bandwitdth it takes to download forged alliance, I have a solution for you as well :

 - first reboot
 - then log into steam and switch proton back to 3.16-8 Beta
 - accept steam restart
 - run forged alliance, create the profile, set resolution then exit it and steam 
 - in a terminal, type :
   ```
cd ~/.steam/steam/steamapps/common/Supreme\ Commander\ Forged\ Alliance
rm Maps
rm Mods
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods
cd ~/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser
rm -rf My\ Documents
mkdir My\ Documents
cd My\ Documents
ln -s ~/My\ Games/ My\ Games
cd ~/faf
./downlords-faf-client
   ```
   - you should now be able to resume at [step 6](https://github.com/tatsujb/installFAFscript#6th "step 6 of script install process")

# Pre-requisites 

- a steam account with Forged Alliance activated on it [(9420)](https://store.steampowered.com/app/9420/Supreme_Commander_Forged_Alliance/ "Supreme Commander Forged Alliace") (no steam does not need to be preinstalled, it does not need to not be preinstalled either, both work)
- a linux system (preferably debian-based such as ubuntu,  for further compatibility please contribute) 
- have at least a total of 11.7GB of free space on boot drive
- be willing to write to your boot drive
- be willing to have stuff put into .bashrc

## Axes of improvements

```diff
- Most Importantly I want to figure out a way to set steam's "proton for all games" flag to true in and set Forged Alliance's launch options in my script rather than have the user do it himself via GUI.
```
- W.I.P. refactoring... I lazily copy pasted the script for the distro's if cases, this made it over 1700 lines long... there should be a better way but I'm short on time. it works that's the main factor.
- W.I.P. fix script failing to launch FAF games if FA was already installed.
- W.I.P. maybe remove as much as possible .bashrc modifications and default to using the run file steam creates, current version does this, if you want bashrc edits it's only one edit ago : https://github.com/tatsujb/installFAFscript/blob/5d5ffec3c47aa05a09b02429e13b4532311a9d67/faf.sh
- W.I.P. make this script more posix-compliant
- W.I.P. ~~create if-cases for differing linux distros~~ implement different linux distro (including mac) I rely on you the reader for this.
- W.I.P. uninstall builtin
- W.I.P. create FAF launcher 
- get rid of behaviors that the user may not be comfortable with; case in point and first offender: giving a shell script sudo priveledges in it's entirety. if the user is warned first hand that he needs curl, steamCMD, steam, lib32gcc1, libd3dadapter9-mesa:i386, libd3dadapter9-mesa beforehand or given an apt install command that opens up ready to run in a seperate terminal (that terminal's outcome being on an "if") so that the user sees firsthand what he's allowing sudo for and what sudo priveledges have been constrained to, then the script can come off less bad practice. Also there should be an opt out of steam username and password entering, in which case at the begining, the script should be able to detect if the condition of Forged Alliance being installed (easy) and first-run have been met (bit of a pickle, it's not as easy as having a config file. although, this requires some testing, perhaps FAF requires nothing more than FA physical files, reg entries and peripheral runtime libraries may be unused by FAF to run it's FA).
- finish Java 10 workarounds.
- add support for custom install location. this one is a nightmare. and not facillitated by paths in FAF client settings not resolving reliably.
- figure out a proper fix to the current lack of path-resolving for FAF's setting "Command line format for executable" then the current workaround: Currently I'm forced to copy Proton Gallium nine's folder to a new folder and point to that new folder instead because the new folder's path doesn't contain dots, numbers or spaces which "Command line format for executable" setting entry in FAF apparently cannot handle. I haven't researched this sufficiently but I suspect there's a better way to do this.
- ~~figure out if any chages to /etc/environement are actually needed. I haven't been able to / or had time to rule out these changes as useless. ideally /ec/environment wouldn't be touched at all.~~ none were needed
- ideas welcome.

# Un-installing :

this will very much depend on how much of what you already had installed before running this script that this script has in common.

here are a couple safe bets however, run this in your terminal:

```
rm ~/the\ contents\ of\ this*
rm ~/faf_sh-*.log
rm ~/run
rm ~/.install4j
rm -rf ~/My\ Games
rm -rf ~/faf
rm -rf ~/.faforever
rm -rf ~/.com.faforever.client.FafClientApplication
sudo apt purge -y steamcmd libd3dadapter9-mesa:i386 libd3dadapter9-mesa lib32gcc1
sudo apt -y autoremove
source ~/.bashrc
```
now all that remains is :

1. steam
if steam wasn't on your system before you ran this script and you are fine with seeing it and Supreme Commander Forged Alliance as well as steamCMD and eventual dependencies go then you can run the following :
```
rm ~/.steampath
rm ~/.steampid
rm -rf ~/.steam
rm -rf ~/Steam
echo steam steam/purge note '' | sudo debconf-set-selections
sudo apt purge -y steam steamcmd libd3dadapter9-mesa:i386 libd3dadapter9-mesa lib32gcc1
sudo apt -y autoremove
```

2. JUST supreme commander, NOT steam (if you ran n°1 ignore this) :
```
rm -rf ~/.steam/steam/SteamApps/common/Supreme\ Commander\ Forged\ Alliance
```

...will do the trick.

3. keep steam but remove my steam extras such as Gallium9Proton and steamCMD and their dependencies (if you ran n°1 ignore this) : 
```
rm -rf ~/.steam/Proton
rm -rf ~/.steam/compatibilitytools.d
sudo apt purge -y steamcmd libd3dadapter9-mesa:i386 libd3dadapter9-mesa lib32gcc1
sudo apt -y autoremove
```

4. Java 10
```
grep -v 'INSTALL4J_JAVA_HOME' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
source ~/.bashrc
rm -rf ~/.java
sudo rm -rf /usr/lib/jvm/jdk-10.0.2/
```




