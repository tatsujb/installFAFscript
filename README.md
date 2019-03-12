# faf.sh 1.9

## (first succesfull run! ubuntu 18.04.2 [11/03/2019] )
contributions welcome!

A shell script that installs and configures FA + FAF multiplayer client on linux
[![how to install on ubuntu](https://user-images.githubusercontent.com/5132359/53690402-25b5a600-3d6a-11e9-94cd-3ac2fc06cf9a.png)](https://www.youtube.com/watch?v=c5K7QmK-Xas)

### Run successes (by distro) :

Version | Distro | Pass/Fail
--- | --- | ---
18.04.2, 18.10 | [![how to install on ubuntu](https://img.apk.cafe/img:bz00eXFremMmbD00MjQmaD1wbmcmZj1HbGk5MCZpPTA)](https://www.youtube.com/watch?v=c5K7QmK-Xas) (click me!) | :heavy_check_mark: 
18.04.2, 18.10 | ![kubuntu](https://user-images.githubusercontent.com/5132359/54205501-c75d9580-44d6-11e9-91fa-ee67fff0e3f8.png) | ...
5.0 | ![elementary-s](https://user-images.githubusercontent.com/5132359/54205279-59b16980-44d6-11e9-9f65-5c191eb33645.png) | ...
19.1 | ![linuxmint](https://user-images.githubusercontent.com/5132359/54205373-7ea5dc80-44d6-11e9-851e-940f3742c1d4.png) | ...
9.8 | ![image](https://user-images.githubusercontent.com/5132359/54201700-99745300-44ce-11e9-8435-dc65f98a2147.png) | :heavy_multiplication_x: 


#### What is a faf.sh?

a faf.sh is a set of software and environment settings and folder names and configs allowing you to enjoy the delights of playing [Forged Alliace Forever](https://faforever.com "Forged Alliace Forever") on linux as you would under windows.

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

1. right click on "Supreme Commander - Forged Alliance" in your games Library" -> "SET LAUNCH OPTIONS..." and enter the contents of "the contents of this file are to be pasted in the forged alliance properties launch options" situated in your home folder, just in case, here they are : `PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1, PROTON_USE_GALLIUM_NINE=1, PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1" %command%`
2. go into "Steam" -> "Setting" -> "Steam Play" -> "Enable Steam Play for all other titles" (Gallium-nine should already be preselected in the drop-down.)

it will ask to restart.

when steam starts don't login just close both login windows, this will allow the rest of the script to continue.

### 5th

Then it downloads Forged Alliance. this will take a while.
Once it's done steam starts again in order to finalize installation (non root hard drive installation is not supported. (E.G.: to a secondary storage HHD, for now I only support installing to SDA.)) and then start Forged Alliance.

accept terms. you can tick the box "Launch game as soon as it's read ready".

Forged Alliance should start, you can set a profile, then set your prefered resulution, then quit the game. (use steam's notification-area icon to close steam once again, to allow the script to continue)

### 6th

FAF is running, log in and set your preferences under "Forged Alliance Forever":
![image](https://user-images.githubusercontent.com/5132359/54200701-44cfd880-44cc-11e9-9abd-4eff42f20562.png)


"Game Location" :
```
/home/USERNAME/.steam/steam/steamapps/common/Supreme Commander Forged Alliance
```
"Command line format for executable" :
```
/home/USERNAME/.steam/steam/steamapps/common/Proton/dist/bin/wine "%s"
```
(steamapps may be SteamApps for you, first navigate to the wine executable in your browser and copy paste the path from you brwoser to make sure we're talking about a dirrectory that exists) 
if this doesn't work try (if you do this you may have to remove .bashrc entries for proton same for ) :
```
/home/USERNAME/run "%s"
```

where "USERNAME" is what you get when you type `echo $USER` into the terminal.

seems optional now :

try to join two games and before the second run in your terminal :

```
chmod +x -R ~/.faforever/bin/ForgedAlliance.exe
```

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
everytime you want to run FAF after that, working on creating a launcher as part of the script, help wanted!

GL HF!

# Pre-requisites 

- a steam account with Forged Alliance activated on it [(9420)](https://store.steampowered.com/app/9420/Supreme_Commander_Forged_Alliance/ "Supreme Commander Forged Alliace") 
- a linux system (preferably debian-based such as ubuntu,  for further compatibility please contribute) 
- have at least a total of 11.7GB of free space on boot drive
- be willing to write to your boot drive
- be willing to have stuff put into .bashrc

## Axes of improvements

```diff
- Most Importantly I want to figure out a way to set steam's "proton for all games" flag to true in and set Forged Alliance's launch options my script rather than have the user do it himself via GUI.
```
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

## Not working ?

Feedback will help me fix things. This script creates a very minimal log file called "fafstack-\*.log" in your home. Paste it's contents as part of an issue/bug report. your first and foremost issue is probably the linux distro flavor, but a couplesyntax edits should therefore make my script work for you.

### known issues :

- "game already running" preventing steam restart after enableing proton; or preventing install finislazion after download : 
  it's a timing issue. you can adjust the sleep value or try to be quicker when setting launch options / enabling proton.

# Un-installing :

this will very much depend on how much of what you already had installed before running this script that this script has in common.

here are a couple safe bets however, run this in your terminal:

```
rm ~/the\ contents\ of\ this*
rm ~/fafstack-*.log
rm ~/run
rm ~/.install4j
rm -rf ~/My\ Games
rm -rf ~/faf
rm -rf ~/.faforever
rm -rf ~/.com.faforever.client.FafClientApplication
grep -v 'LD_PRELOAD' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'LD_LIBRARY_PATH' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'DEF_CMD' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'export TERM' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'WINEDLLPATH' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'WINEPREFIX' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'WINEDEBUG' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'SteamGameId' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'SteamAppId' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
grep -v 'WINEDLLOVERRIDES' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
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

4. Java 10 (you will have to put back your other versions of java yourself)
```
grep -v 'INSTALL4J_JAVA_HOME' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
source ~/.bashrc
rm -rf ~/.java
sudo rm -rf /usr/lib/jvm/jdk-10.0.2/
sudo update-alternatives --remove "java" "/usr/lib/jvm/jdk-10.0.2/bin/java"
sudo update-alternatives --remove "javac" "/usr/lib/jvm/jdk-10.0.2/bin/javac"
sudo update-alternatives --remove "javaws" "/usr/lib/jvm/jdk-10.0.2/jre/bin/javaws"
```




