
[![how to install on ubuntu](https://user-images.githubusercontent.com/5132359/53690402-25b5a600-3d6a-11e9-94cd-3ac2fc06cf9a.png)](https://www.youtube.com/watch?v=c5K7QmK-Xas)


This is a shell script that installs and configures [FA](https://store.steampowered.com/app/9420/Supreme_Commander_Forged_Alliance/ "Supreme Commander Forged Alliace") + [FAF](https://faforever.com "Forged Alliace Forever") multiplayer client on linux (and soon any OS that Forged Alliance can also run on).

### "I don't want a script! I want a DIY!" :

no problem! Foodlfg makes short work of summarizing all you need to know for how to install FAF over here : https://github.com/foodlfg/Supreme-Commander-FAF-install-guide

### Run successes (by distro) :
Distro icon should be clickable for a video-example (for the moment only had the time to record ubuntu but I coded for other distributions. feel free to share another youtube link for another distribution, I'll add it)

Version | Distro | distro+DE |  | Comment
--- | --- | --- | --- | ---
18.04.2, 18.10 | [![how to install on ubuntu](https://img.apk.cafe/img:bz00eXFremMmbD00MjQmaD1wbmcmZj1HbGk5MCZpPTA)](https://www.youtube.com/watch?v=c5K7QmK-Xas) | ubuntu (gnome3) | :heavy_check_mark: | base of script
19.1 | ![linuxmint](https://user-images.githubusercontent.com/5132359/54205373-7ea5dc80-44d6-11e9-851e-940f3742c1d4.png) | Mint (Cinnamon) | :heavy_check_mark: | likely closest behavior to stock ubuntu. nothing needed to change from base, worked out-of-the-box.
18.04.2, 18.10 | ![kubuntu](https://user-images.githubusercontent.com/5132359/54205501-c75d9580-44d6-11e9-91fa-ee67fff0e3f8.png) | Kubuntu (Plasma) | :heavy_check_mark: | two adaptations were made for kubuntu to work: detecting plasma + ubuntu = (kubuntu if case). Also gnome-terminal was traded out in favor of konsole.
12.4 | ![zorin](https://user-images.githubusercontent.com/5132359/54295562-92734080-45b3-11e9-95ed-627f2931ec94.png) | Zorin (zorin) | :heavy_check_mark:  | debconf-set-selections for steam is for some reason borked on zorin, trying to auto-accept the eula will result in the opposite. You'll have two eula accepting manual steps added to your process. really minor.
5.0 | ![elementary-s](https://user-images.githubusercontent.com/5132359/54205279-59b16980-44d6-11e9-9f65-5c191eb33645.png) | Elementary (Pantheon) | :heavy_check_mark: | used xterm instead of gnome-terminal. Also I didn't know how to shut down steam, there was no tray icon, I used htop 
9.8 | ![debian](https://user-images.githubusercontent.com/5132359/54201700-99745300-44ce-11e9-8435-dc65f98a2147.png) | Debian (gnome3) | :heavy_multiplication_x: | run as root, do not sudo ./faf.sh, simply run logged in as root. don't worry, the script will place files in your user's home not root's home.
29 | ![Fedora](https://user-images.githubusercontent.com/5132359/54399527-2978ef00-46bf-11e9-8418-0031c7e991f7.png) | Fedora (gnome3) | :heavy_multiplication_x: | working on it...
18.0.4 | ![manjaro](https://user-images.githubusercontent.com/5132359/54216185-76a36800-44e9-11e9-9e32-52d6a4071643.png) | Manjaro (Plasma) | :heavy_multiplication_x: | 
18.10 | ![centos](https://user-images.githubusercontent.com/5132359/54216744-88393f80-44ea-11e9-8536-9fbd56ad3913.png) | CenT OS (gnome3) | :heavy_multiplication_x: | 
10.14 | ![apple](https://user-images.githubusercontent.com/5132359/54368435-6d92d200-4674-11e9-922f-9aebabfd7ca2.png) | Apple (Aqua) | :heavy_multiplication_x: | started work...

# Install

(read entirely before running)

# Pre-requisites 

- a steam account with Forged Alliance activated on it [(9420)](https://store.steampowered.com/app/9420/Supreme_Commander_Forged_Alliance/ "Supreme Commander Forged Alliace") (no steam does not need to be preinstalled, it does not need to not be preinstalled either, both work)
- your steam games are public (they no longer are by default) so if your account is relatively new and you haven't done this yet follow this guide first :  https://youtu.be/ElH4aetA5Hc
- a linux system (preferably debian-based such as ubuntu,  for further compatibility please contribute) 
- have at least a total of 11.7GB of free space on boot drive
- be willing to write to your boot drive
- be willing to have stuff put into .bashrc

Do not run script as root! (Debian being an exception)

Ideally run on a fresh system with nothing (such as steam) currently open, although the script has been known to work in those cases.

if you have made previous attempts at installing faf that are not this script, please remove all elements of faf first : faf-download-client, java 10, and forrged alliance and reboot your computer.

### 1st

click on faf.sh above, then click on "RAW", then type <kbd>Ctrl</kbd> + <kbd>S</kbd>, (you can place anywhere, in home folder is comfortable to work with), then <kbd>Enter</kbd> to save file.

### 2nd

make it executable : (terminal) `chmod +x faf.sh`

### 3rd 

run the script within a terminal : `./faf.sh` 

you'll be asked in order :
- your linux session password
- your steam account usename
- your steam account password
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

FAF will start, go ahead and log in.

FAF will close almost immediately

then start again, that was it's preferences being set by my script. you can now play, the script is now done.

if you want to run FAF again do not run faf.sh again (remember, it is a script to install Forged Alliance + FAF client), simply search for FAF from your start:
![faf in start menu](https://user-images.githubusercontent.com/5132359/55295519-365f4780-540e-11e9-9a9c-02a94dd70b07.png)

GL HF!

## Axes of improvements

```diff
- Most Importantly I want to figure out a way to set steam's "proton for all games" flag to true in and set Forged Alliance's launch options in my script rather than have the user do it himself via GUI.
```
- W.I.P. implement different linux distro (including mac), I rely on you the reader for this. so far I've done: ubuntu, lubuntu, kubuntu, mint, elementary, zorin and debian.
- W.I.P. add support for custom install location. this one is a nightmare. and not facillitated by paths in FAF client settings not resolving reliably.
- W.I.P. fix script failing to launch FAF games if FA was already installed.
- W.I.P. uninstall builtin
- W.I.P. finish Java 10 workarounds.
- W.I.P. get rid of behaviors that the user may not be comfortable with; case in point and first offender: giving a shell script sudo priveledges in it's entirety. if the user is warned first hand that he needs curl, steamCMD, steam, lib32gcc1, libd3dadapter9-mesa:i386, libd3dadapter9-mesa beforehand or given an apt install command that opens up ready to run in a seperate terminal (that terminal's outcome being on an "if") so that the user sees firsthand what he's allowing sudo for and what sudo priveledges have been constrained to, then the script can come off less bad practice. Also there should be an opt out of steam username and password entering, in which case at the begining, the script should be able to detect if the condition of Forged Alliance being installed (easy) and first-run have been met (bit of a pickle, it's not as easy as having a config file. although, this requires some testing, perhaps FAF requires nothing more than FA physical files, reg entries and peripheral runtime libraries may be unused by FAF to run it's FA).
- r̶e̶f̶a̶c̶t̶o̶r̶i̶n̶g̶.̶.̶.̶ ̶I̶ ̶l̶a̶z̶i̶l̶y̶ ̶c̶o̶p̶y̶ ̶p̶a̶s̶t̶e̶d̶ ̶t̶h̶e̶ ̶s̶c̶r̶i̶p̶t̶ ̶f̶o̶r̶ ̶t̶h̶e̶ ̶d̶i̶s̶t̶r̶o̶'̶s̶ ̶i̶f̶ ̶c̶a̶s̶e̶s̶,̶ ̶t̶h̶i̶s̶ ̶m̶a̶d̶e̶ ̶i̶t̶ ̶o̶v̶e̶r̶ ̶1̶7̶0̶0̶ ̶l̶i̶n̶e̶s̶ ̶l̶o̶n̶g̶.̶.̶.̶ ̶t̶h̶e̶r̶e̶ ̶s̶h̶o̶u̶l̶d̶ ̶b̶e̶ ̶a̶ ̶b̶e̶t̶t̶e̶r̶ ̶w̶a̶y̶ ̶b̶u̶t̶ ̶I̶'̶m̶ ̶s̶h̶o̶r̶t̶ ̶o̶n̶ ̶t̶i̶m̶e̶.̶ ̶i̶t̶ ̶w̶o̶r̶k̶s̶ ̶t̶h̶a̶t̶'̶s̶ ̶t̶h̶e̶ ̶m̶a̶i̶n̶ ̶f̶a̶c̶t̶o̶r̶.̶ now refactored : 2383 −> down to 665 !!!
- r̶e̶m̶o̶v̶e̶ ̶a̶s̶ ̶m̶u̶c̶h̶ ̶a̶s̶ ̶p̶o̶s̶s̶i̶b̶l̶e̶ ̶.̶b̶a̶s̶h̶r̶c̶ ̶m̶o̶d̶i̶f̶i̶c̶a̶t̶i̶o̶n̶s̶ ̶a̶n̶d̶ ̶d̶e̶f̶a̶u̶l̶t̶ ̶t̶o̶ ̶u̶s̶i̶n̶g̶ ̶t̶h̶e̶ ̶r̶u̶n̶ ̶f̶i̶l̶e̶ ̶s̶t̶e̶a̶m̶ ̶c̶r̶e̶a̶t̶e̶s̶ (if you want bashrc edits it's only one edit ago : https://github.com/tatsujb/installFAFscript/blob/5d5ffec3c47aa05a09b02429e13b4532311a9d67/faf.sh )
- m̶a̶k̶e̶ ̶t̶h̶i̶s̶ ̶s̶c̶r̶i̶p̶t̶ ̶m̶o̶r̶e̶ ̶p̶o̶s̶i̶x̶-̶c̶o̶m̶p̶l̶i̶a̶n̶t̶ could always be better
- ~~create if-cases for differing linux distros~~ 
- r̶e̶m̶o̶v̶e̶ ̶t̶h̶e̶ ̶n̶e̶e̶d̶ ̶f̶o̶r̶ ̶t̶h̶e̶ ̶u̶s̶e̶r̶ ̶s̶o̶ ̶s̶e̶t̶ ̶f̶a̶f̶ ̶s̶e̶t̶t̶i̶n̶g̶s̶ ̶h̶i̶m̶s̶e̶l̶f̶
- c̶r̶e̶a̶t̶e̶ ̶F̶A̶F̶ ̶l̶a̶u̶n̶c̶h̶e̶r̶ 
- f̶i̶g̶u̶r̶e̶ ̶o̶u̶t̶ ̶a̶ ̶p̶r̶o̶p̶e̶r̶ ̶f̶i̶x̶ ̶t̶o̶ ̶t̶h̶e̶ ̶c̶u̶r̶r̶e̶n̶t̶ ̶l̶a̶c̶k̶ ̶o̶f̶ ̶p̶a̶t̶h̶-̶r̶e̶s̶o̶l̶v̶i̶n̶g̶ ̶f̶o̶r̶ ̶F̶A̶F̶'̶s̶ ̶s̶e̶t̶t̶i̶n̶g̶ ̶"̶C̶o̶m̶m̶a̶n̶d̶ ̶l̶i̶n̶e̶ ̶f̶o̶r̶m̶a̶t̶ ̶f̶o̶r̶ ̶e̶x̶e̶c̶u̶t̶a̶b̶l̶e̶"̶ ̶t̶h̶e̶n̶ ̶t̶h̶e̶ ̶c̶u̶r̶r̶e̶n̶t̶ ̶w̶o̶r̶k̶a̶r̶o̶u̶n̶d̶:̶ ̶C̶u̶r̶r̶e̶n̶t̶l̶y̶ ̶I̶'̶m̶ ̶f̶o̶r̶c̶e̶d̶ ̶t̶o̶ ̶c̶o̶p̶y̶ ̶P̶r̶o̶t̶o̶n̶ ̶G̶a̶l̶l̶i̶u̶m̶ ̶n̶i̶n̶e̶'̶s̶ ̶f̶o̶l̶d̶e̶r̶ ̶t̶o̶ ̶a̶ ̶n̶e̶w̶ ̶f̶o̶l̶d̶e̶r̶ ̶a̶n̶d̶ ̶p̶o̶i̶n̶t̶ ̶t̶o̶ ̶t̶h̶a̶t̶ ̶n̶e̶w̶ ̶f̶o̶l̶d̶e̶r̶ ̶i̶n̶s̶t̶e̶a̶d̶ ̶b̶e̶c̶a̶u̶s̶e̶ ̶t̶h̶e̶ ̶n̶e̶w̶ ̶f̶o̶l̶d̶e̶r̶'̶s̶ ̶p̶a̶t̶h̶ ̶d̶o̶e̶s̶n̶'̶t̶ ̶c̶o̶n̶t̶a̶i̶n̶ ̶d̶o̶t̶s̶,̶ ̶n̶u̶m̶b̶e̶r̶s̶ ̶o̶r̶ ̶s̶p̶a̶c̶e̶s̶ ̶w̶h̶i̶c̶h̶ ̶"̶C̶o̶m̶m̶a̶n̶d̶ ̶l̶i̶n̶e̶ ̶f̶o̶r̶m̶a̶t̶ ̶f̶o̶r̶ ̶e̶x̶e̶c̶u̶t̶a̶b̶l̶e̶"̶ ̶s̶e̶t̶t̶i̶n̶g̶ ̶e̶n̶t̶r̶y̶ ̶i̶n̶ ̶F̶A̶F̶ ̶a̶p̶p̶a̶r̶e̶n̶t̶l̶y̶ ̶c̶a̶n̶n̶o̶t̶ ̶h̶a̶n̶d̶l̶e̶.̶ ̶I̶ ̶h̶a̶v̶e̶n̶'̶t̶ ̶r̶e̶s̶e̶a̶r̶c̶h̶e̶d̶ ̶t̶h̶i̶s̶ ̶s̶u̶f̶f̶i̶c̶i̶e̶n̶t̶l̶y̶ ̶b̶u̶t̶ ̶I̶ ̶s̶u̶s̶p̶e̶c̶t̶ ̶t̶h̶e̶r̶e̶'̶s̶ ̶a̶ ̶b̶e̶t̶t̶e̶r̶ ̶w̶a̶y̶ ̶t̶o̶ ̶d̶o̶ ̶t̶h̶i̶s̶.̶
- ~~figure out if any chages to /etc/environement are actually needed. I haven't been able to / or had time to rule out these changes as useless. ideally /ec/environment wouldn't be touched at all.~~ none were needed
- ideas welcome.

## Not working ?

Feedback will help me fix things. This script creates a very minimal log file called "faf_sh-\*.log" in your home. Paste it's contents as part of an issue/bug report. your first and foremost issue is probably the linux distro flavor, you can check what release is supported as of now [here](https://github.com/tatsujb/installFAFscript#run-successes-by-distro- "distro compatibility"), but a couplesyntax edits should make my script work for you.

### known issues :

1. "game already running" preventing steam restart after enabling proton; or preventing install finislazion after download : 

this happens mostly when you're running this script for the second time (reinstalling) without a reboot.

If removing everything, rebooting and reinstalling is too much of a hassle (because of how much bandwitdth it takes to download forged alliance), I have a solution for you as well :

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
   
 2. another known issue is run files being kinda borked at generation. if you're not getting an FA starting when running from FAF but it does start from steam, this is what you may want to look into, your run file is at `$HOME/faf/` and here's a sample one to find issues with yours :

### sample :
```
#!/bin/bash
#Run game or given command in environment

cd "/home/t/.steam/steam/steamapps/common/Supreme Commander Forged Alliance"
DEF_CMD=("/home/t/.steam/steam/steamapps/common/Supreme Commander Forged Alliance/bin/SupremeCommander.exe")
PATH="/home/t/.steam/steam/steamapps/common/Proton/dist/bin/:/home/t/.steam/ubuntu12_32/steam-runtime/amd64/bin:/home/t/.steam/ubuntu12_32/steam-runtime/amd64/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/jdk-10.0.2/bin:/usr/bin/python:/usr/bin/gtags:/snap/bin" \
	TERM="xterm" \
	WINEDEBUG="-all" \
	WINEDLLPATH="/home/t/.steam/steam/steamapps/common/Proton/dist/lib64/wine:/home/t/.steam/steam/steamapps/common/Proton/dist/lib/wine" \
	LD_LIBRARY_PATH="/home/t/.steam/steam/steamapps/common/Proton/dist/lib64:/home/t/.steam/steam/steamapps/common/Proton/dist/lib:/home/t/.steam/ubuntu12_32/steam-runtime/pinned_libs_32:/home/t/.steam/ubuntu12_32/steam-runtime/pinned_libs_64:/usr/lib/x86_64-linux-gnu/libfakeroot:/lib/i386-linux-gnu:/usr/lib/i386-linux-gnu:/usr/local/lib:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/lib:/usr/lib:/home/t/.steam/ubuntu12_32/steam-runtime/i386/lib/i386-linux-gnu:/home/t/.steam/ubuntu12_32/steam-runtime/i386/lib:/home/t/.steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu:/home/t/.steam/ubuntu12_32/steam-runtime/i386/usr/lib:/home/t/.steam/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu:/home/t/.steam/ubuntu12_32/steam-runtime/amd64/lib:/home/t/.steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu:/home/t/.steam/ubuntu12_32/steam-runtime/amd64/usr/lib:" \
	WINEPREFIX="/home/t/.steam/steam/steamapps/compatdata/9420/pfx/" \
	SteamGameId="9420" \
	SteamAppId="9420" \
	WINEDLLOVERRIDES="d3d11=n;d3d10=n;d3d10core=n;d3d10_1=n;dxgi=n" \
	STEAM_COMPAT_CLIENT_INSTALL_PATH="/home/t/.steam" \
	"/home/t/.steam/steam/steamapps/common/Proton/dist/bin//wine" "${@:-${DEF_CMD[@]}}"
```

possible flaws are `/steam/steamapps/common/Proton/` being a `/compatibilitytools.d/Proton_3.16-6_Gallium_Nine_Extras_0.3.0/` instead or there not being a `LD_LIBRARY_PATH` or `DEF_CMD` having a `shutdown` at the end of it, also `steamapps` instead of `SteamApps`.


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




