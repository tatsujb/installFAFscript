###### licensed under GPL-3.0-or-later
[![how to install on ubuntu](https://user-images.githubusercontent.com/5132359/55295910-de770f80-5412-11e9-8950-f22f6176e406.png)](https://www.youtube.com/watch?v=BEWUEoQ8Q4k)


This is a shell script that installs and configures [FA](https://store.steampowered.com/app/9420/Supreme_Commander_Forged_Alliance/ "Supreme Commander Forged Alliace") + [FAF](https://faforever.com "Forged Alliace Forever") multiplayer client on linux (and soon any OS that Forged Alliance can also run on).

### "I don't want a script! I want a DIY!" :

no problem! Foodlfg makes short work of summarizing all you need to know for how to install FAF over here : https://github.com/foodlfg/Supreme-Commander-FAF-install-guide

### Run successes (by distro) :
Distro icon should be clickable for a video-example (for the moment only had the time to record ubuntu but I coded for other distributions. feel free to share another youtube link for another distribution, I'll add it)

Version | Distro | distro+DE |  | Comment
--- | --- | --- | --- | ---
10 | ![Windows](https://user-images.githubusercontent.com/5132359/55296434-a4f5d280-5419-11e9-982d-c1977de61c16.png) | Windows (windows) | ? | just go here : www.faforever.com
19.04, 18.10, 18.04.2  | [![how to install on ubuntu](https://img.apk.cafe/img:bz00eXFremMmbD00MjQmaD1wbmcmZj1HbGk5MCZpPTA)](https://www.youtube.com/watch?v=BEWUEoQ8Q4k) | ubuntu (gnome3) | :heavy_check_mark: | base of script
18.10 | ![xubuntu](https://user-images.githubusercontent.com/5132359/55296491-77f5ef80-541a-11e9-9909-58bee75404ec.png) | Xubuntu (xfce) | ? | should work. untested.
19.1 | ![linuxmint](https://user-images.githubusercontent.com/5132359/54205373-7ea5dc80-44d6-11e9-851e-940f3742c1d4.png) | Mint (Cinnamon) | :heavy_check_mark: | likely closest behavior to stock ubuntu. nothing needed to change from base, worked out-of-the-box.
18.04.2, 18.10 | ![kubuntu](https://user-images.githubusercontent.com/5132359/54205501-c75d9580-44d6-11e9-91fa-ee67fff0e3f8.png) | Kubuntu (Plasma) | :heavy_check_mark: | two adaptations were made for kubuntu to work: detecting plasma + ubuntu = (kubuntu if case). Also gnome-terminal was traded out in favor of konsole.
12.4 | ![zorin](https://user-images.githubusercontent.com/5132359/54295562-92734080-45b3-11e9-95ed-627f2931ec94.png) | Zorin (zorin) | :heavy_check_mark:  | debconf-set-selections for steam is for some reason borked on zorin, trying to auto-accept the eula will result in the opposite. You'll have two eula accepting manual steps added to your process. really minor.
18.04 |![lubuntu](https://user-images.githubusercontent.com/5132359/55295985-b805a400-5413-11e9-8fca-315db5462eb6.png) | Lubuntu (LXDE) | ? | should work. untested.
5.0 | ![elementary-s](https://user-images.githubusercontent.com/5132359/54205279-59b16980-44d6-11e9-9f65-5c191eb33645.png) | Elementary (Pantheon) | :heavy_check_mark: | used xterm instead of gnome-terminal. Also I didn't know how to shut down steam, there was no tray icon, I used htop 
9.8 | ![debian](https://user-images.githubusercontent.com/5132359/54201700-99745300-44ce-11e9-8435-dc65f98a2147.png) | Debian (gnome3) | :heavy_multiplication_x: | run as root, do not sudo ./faf.sh, simply run logged in as root. don't worry, the script will place files in your user's home not root's home.
29 | ![Fedora](https://user-images.githubusercontent.com/5132359/54399527-2978ef00-46bf-11e9-8418-0031c7e991f7.png) | Fedora (gnome3) | :heavy_multiplication_x: | working on it...
18.0.4 | ![manjaro](https://user-images.githubusercontent.com/5132359/54216185-76a36800-44e9-11e9-9e32-52d6a4071643.png) | Manjaro (Plasma) | :heavy_multiplication_x: | 
18.10 | ![centos](https://user-images.githubusercontent.com/5132359/54216744-88393f80-44ea-11e9-8536-9fbd56ad3913.png) | CenT OS (gnome3) | :heavy_multiplication_x: | 
10.14 | ![apple](https://user-images.githubusercontent.com/5132359/54368435-6d92d200-4674-11e9-922f-9aebabfd7ca2.png) | Apple (Aqua) | :heavy_multiplication_x: | started work...

# Install (read entirely before running)

## Pre-requisites 

- a steam account with Forged Alliance activated on it [(9420)](https://store.steampowered.com/app/9420/Supreme_Commander_Forged_Alliance/ "Supreme Commander Forged Alliace") (no steam does not need to be preinstalled, it does not need to not be preinstalled either, both work)
- your steam games are public (they no longer are by default) so if your account is relatively new and you haven't done this yet follow this guide first :  https://youtu.be/ElH4aetA5Hc
- 11.7GB of free space

Do not run script as root! (with Debian it's the opposite, run as root)

### 1st

click on faf.sh above, then click on "RAW", then type <kbd>Ctrl</kbd> + <kbd>S</kbd>, (you can place anywhere, in home folder is comfortable to work with), then <kbd>Enter</kbd> to save file.

### 2nd

make it executable : (terminal) `chmod +x faf.sh`

### 3rd 

run the script within a terminal : `./faf.sh` 

The script will begin by asking for your linux session password.

In a seperate terminal tab, this tab will give you the commands to run yourself if your usage of a script procludes it claiming sudo priveledges. copy the commands, click on the "x" of the open terminal (accept force-closing them) open a new terminal, paste the commands. they are verbose they are dependencies without which this script cannot run. You can now run the script again, you will find that this tab will no longer show and you will not be asked for sudo priveleges at all.

If however you trust that this terminal tab does exatly what it claims you may simply type in your password.

### 4rth

Switch back to the first terminal tab. (or simply wait, the sudo tab closing will result in the same)

you are being asked if you do not have FA installed. 

if you select no you have five choices :

 1. Install FA again (this option is usefull because it allows you to use the normal script just ignoring your current install of FA which you may or may not delete at your discretion)
 2. Reinstall FA (this option is the same except you will be prompted first with a delete folder gui. This Gui does not match the folder, you can choose to delete any non-protected folder)
 3. Use my install of FA
 4. only install FAF for me.
 5. go back to the menu from before.
 
if you select yes you are then asked whether you want to install FA to default dir and drive (SDA), at your discretion you may choose no and you will be prompted with a Gui to pick the folder.

### 5th (I chose "yes I do not have FA installed", if not skip this step) 

After you've made your choices a new terminal tab opens up that begins by launching steam.

At a certain point steam starts up and you'll need to enter Steam Guard.

1. right click on "Supreme Commander - Forged Alliance" in your games Library" -> "SET LAUNCH OPTIONS..." and enter the contents of "the contents of this file are to be pasted in the forged alliance properties launch options" situated in your home folder, just in case, here they are (gallium-nine example) : `PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1, PROTON_USE_GALLIUM_NINE=1, PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1" %command%`
(vanilla proton example) : `PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1 %command%`
2. go into "Steam" -> "Setting" -> "Steam Play" -> "Enable Steam Play for all other titles" (it will be proton 4.2-2 Beta)

Steam will ask to restart.

When steam restarts don't login just close both the login and steam guard window, this will allow the rest of the script to continue. (if you accidentally logged in at this step, that's fine, just use the tray area icon to close steam, when steam is closed the script will continue)

Then it downloads Forged Alliance. this will take a while.
Once it's done steam starts again in order to finalize installation and then start Forged Alliance.

accept terms.

Forged Alliance should start, you can set a profile, then set your prefered resolution, then quit the game. do not close steam, you need an open steam instance to run FAF nowadays.

### 6th

FAF will start, go ahead and log in.

FAF will close almost immediately

then start again, that was it's preferences being set by my script. you can now play, the script is now done.

if you want to run FAF again do not run faf.sh again (remember, it is a script to install Forged Alliance + FAF client), simply search for FAF from your start:
![faf in start menu](https://user-images.githubusercontent.com/5132359/55295519-365f4780-540e-11e9-9a9c-02a94dd70b07.png)

GL HF!

## Axes of improvements

```diff
- W.I.P. set proton for FA (or all games) and FA launch options for user, don't ask the user do do it himself.
```
- W.I.P. uninstall builtin
- W.I.P. supporting gallium nine via winetricks & protontricks instead of via deprecated githubfork of proton
- W.I.P. implement Mageia
- W.I.P. implement Manjaro
- W.I.P. implement Fedora
- W.I.P. implement Mac
- W.I.P. implement windows (this will replace all emulation aspects with [fullscreen script](http://forums.faforever.com/viewtopic.php?f=2&t=9778 "fullscreen script") )
- W.I.P. emulate what steam does to FA folders on first run and the creation of the config.ini file by FA itself to further decrease user work.
- maybe custom FAF dir as well? I don't see the point it's a really small dir.
- a̶d̶d̶ ̶s̶u̶p̶p̶o̶r̶t̶ ̶f̶o̶r̶ ̶c̶u̶s̶t̶o̶m̶ ̶i̶n̶s̶t̶a̶l̶l̶ ̶l̶o̶c̶a̶t̶i̶o̶n̶.̶ ̶t̶h̶i̶s̶ ̶o̶n̶e̶ ̶i̶s̶ ̶a̶ ̶n̶i̶g̶h̶t̶m̶a̶r̶e̶.̶ ̶a̶n̶d̶ ̶n̶o̶t̶ ̶f̶a̶c̶i̶l̶i̶t̶a̶t̶e̶d̶ ̶b̶y̶ ̶p̶a̶t̶h̶s̶ ̶i̶n̶ ̶F̶A̶F̶ ̶c̶l̶i̶e̶n̶t̶ ̶s̶e̶t̶t̶i̶n̶g̶s̶ ̶n̶o̶t̶ ̶r̶e̶s̶o̶l̶v̶i̶n̶g̶ ̶r̶e̶l̶i̶a̶b̶l̶y̶.̶
- f̶i̶x̶ ̶s̶c̶r̶i̶p̶t̶ ̶f̶a̶i̶l̶i̶n̶g̶ ̶t̶o̶ ̶l̶a̶u̶n̶c̶h̶ ̶F̶A̶F̶ ̶g̶a̶m̶e̶s̶ ̶i̶f̶ ̶F̶A̶ ̶w̶a̶s̶ ̶a̶l̶r̶e̶a̶d̶y̶ ̶i̶n̶s̶t̶a̶l̶l̶e̶d̶.̶
- g̶e̶t̶ ̶r̶i̶d̶ ̶o̶f̶ ̶b̶e̶h̶a̶v̶i̶o̶r̶s̶ ̶t̶h̶a̶t̶ ̶t̶h̶e̶ ̶u̶s̶e̶r̶ ̶m̶a̶y̶ ̶n̶o̶t̶ ̶b̶e̶ ̶c̶o̶m̶f̶o̶r̶t̶a̶b̶l̶e̶ ̶w̶i̶t̶h̶;̶ ̶c̶a̶s̶e̶ ̶i̶n̶ ̶p̶o̶i̶n̶t̶ ̶a̶n̶d̶ ̶f̶i̶r̶s̶t̶ ̶o̶f̶f̶e̶n̶d̶e̶r̶:̶ ̶g̶i̶v̶i̶n̶g̶ ̶a̶ ̶s̶h̶e̶l̶l̶ ̶s̶c̶r̶i̶p̶t̶ ̶s̶u̶d̶o̶ ̶p̶r̶i̶v̶e̶l̶e̶d̶g̶e̶s̶ ̶i̶n̶ ̶i̶t̶'̶s̶ ̶e̶n̶t̶i̶r̶e̶t̶y̶.̶ ̶i̶f̶ ̶t̶h̶e̶ ̶u̶s̶e̶r̶ ̶i̶s̶ ̶w̶a̶r̶n̶e̶d̶ ̶f̶i̶r̶s̶t̶ ̶h̶a̶n̶d̶ ̶t̶h̶a̶t̶ ̶h̶e̶ ̶n̶e̶e̶d̶s̶ ̶c̶u̶r̶l̶,̶ ̶s̶t̶e̶a̶m̶C̶M̶D̶,̶ ̶s̶t̶e̶a̶m̶,̶ ̶l̶i̶b̶3̶2̶g̶c̶c̶1̶,̶ ̶l̶i̶b̶d̶3̶d̶a̶d̶a̶p̶t̶e̶r̶9̶-̶m̶e̶s̶a̶:̶i̶3̶8̶6̶,̶ ̶l̶i̶b̶d̶3̶d̶a̶d̶a̶p̶t̶e̶r̶9̶-̶m̶e̶s̶a̶ ̶b̶e̶f̶o̶r̶e̶h̶a̶n̶d̶ ̶o̶r̶ ̶g̶i̶v̶e̶n̶ ̶a̶n̶ ̶a̶p̶t̶ ̶i̶n̶s̶t̶a̶l̶l̶ ̶c̶o̶m̶m̶a̶n̶d̶ ̶t̶h̶a̶t̶ ̶o̶p̶e̶n̶s̶ ̶u̶p̶ ̶r̶e̶a̶d̶y̶ ̶t̶o̶ ̶r̶u̶n̶ ̶i̶n̶ ̶a̶ ̶s̶e̶p̶e̶r̶a̶t̶e̶ ̶t̶e̶r̶m̶i̶n̶a̶l̶ ̶(̶t̶h̶a̶t̶ ̶t̶e̶r̶m̶i̶n̶a̶l̶'̶s̶ ̶o̶u̶t̶c̶o̶m̶e̶ ̶b̶e̶i̶n̶g̶ ̶o̶n̶ ̶a̶n̶ ̶"̶i̶f̶"̶)̶ ̶s̶o̶ ̶t̶h̶a̶t̶ ̶t̶h̶e̶ ̶u̶s̶e̶r̶ ̶s̶e̶e̶s̶ ̶f̶i̶r̶s̶t̶h̶a̶n̶d̶ ̶w̶h̶a̶t̶ ̶h̶e̶'̶s̶ ̶a̶l̶l̶o̶w̶i̶n̶g̶ ̶s̶u̶d̶o̶ ̶f̶o̶r̶ ̶a̶n̶d̶ ̶w̶h̶a̶t̶ ̶s̶u̶d̶o̶ ̶p̶r̶i̶v̶e̶l̶e̶d...t̶ ̶c̶a̶n̶ ̶c̶o̶m̶e̶ ̶o̶f̶f̶ ̶l̶e̶s̶s̶ ̶b̶a̶d̶ ̶p̶r̶a̶c̶t̶i̶c̶e̶.̶ ̶A̶l̶s̶o̶ ̶t̶h̶e̶r̶e̶ ̶s̶h̶o̶u̶l̶d̶ ̶b̶e̶ ̶a̶n̶ ̶o̶p̶t̶ ̶o̶u̶t̶ ̶o̶f̶ ̶s̶t̶e̶a̶m̶ ̶u̶s̶e̶r̶n̶a̶m̶e̶ ̶a̶n̶d̶ ̶p̶a̶s̶s̶w̶o̶r̶d̶ ̶e̶n̶t̶e̶r̶i̶n̶g̶,̶ ̶i̶n̶ ̶w̶h̶i̶c̶h̶ ̶c̶a̶s̶e̶ ̶a̶t̶ ̶t̶h̶e̶ ̶b̶e̶g̶i̶n̶i̶n̶g̶,̶ ̶t̶h̶e̶ ̶s̶c̶r̶i̶p̶t̶ ̶s̶h̶o̶u̶l̶d̶ ̶b̶e̶ ̶a̶b̶l̶e̶ ̶t̶o̶ ̶d̶e̶t̶e̶c̶t̶ ̶i̶f̶ ̶t̶h̶e̶ ̶c̶o̶n̶d̶i̶t̶i̶o̶n̶ ̶o̶f̶ ̶F̶o̶r̶g̶e̶d̶ ̶A̶l̶l̶i̶a̶n̶c̶e̶ ̶b̶e̶i̶n̶g̶ ̶i̶n̶s̶t̶a̶l̶l̶e̶d̶ ̶(̶e̶a̶s̶y̶)̶ ̶a̶n̶d̶ ̶f̶i̶r̶s̶t̶-̶r̶u̶n̶ ̶h̶a̶v̶e̶ ̶b̶e̶e̶n̶ ̶m̶e̶t̶ ̶(̶b̶i̶t̶ ̶o̶f̶ ̶a̶ ̶p̶i̶c̶k̶l̶e̶,̶ ̶i̶t̶'̶s̶ ̶n̶o̶t̶ ̶a̶s̶ ̶e̶a̶s̶y̶ ̶a̶s̶ ̶h̶a̶v̶i̶n̶g̶ ̶a̶ ̶c̶o̶n̶f̶i̶g̶ ̶f̶i̶l̶e̶.̶ ̶a̶l̶t̶h̶o̶u̶g̶h̶,̶ ̶t̶h̶i̶s̶ ̶r̶e̶q̶u̶i̶r̶e̶s̶ ̶s̶o̶m̶e̶ ̶t̶e̶s̶t̶i̶n̶g̶,̶ ̶p̶e̶r̶h̶a̶p̶s̶ ̶F̶A̶F̶ ̶r̶e̶q̶u̶i̶r̶e̶s̶ ̶n̶o̶t̶h̶i̶n̶g̶ ̶m̶o̶r̶e̶ ̶t̶h̶a̶n̶ ̶F̶A̶ ̶p̶h̶y̶s̶i̶c̶a̶l̶ ̶f̶i̶l̶e̶s̶,̶ ̶r̶e̶g̶ ̶e̶n̶t̶r̶i̶e̶s̶ ̶a̶n̶d̶ ̶p̶e̶r̶i̶p̶h̶e̶r̶a̶l̶ ̶r̶u̶n̶t̶i̶m̶e̶ ̶l̶i̶b̶r̶a̶r̶i̶e̶s̶ ̶m̶a̶y̶ ̶b̶e̶ ̶u̶n̶u̶s̶e̶d̶ ̶b̶y̶ ̶F̶A̶F̶ ̶t̶o̶ ̶r̶u̶n̶ ̶i̶t̶'̶s̶ ̶F̶A̶)̶.̶
- f̶i̶n̶i̶s̶h̶ ̶J̶a̶v̶a̶ ̶1̶0̶ ̶w̶o̶r̶k̶a̶r̶o̶u̶n̶d̶s̶.̶ no longer needed since it turned out the java 10 folder could be independent. now I only avoid re-installing.
- r̶e̶f̶a̶c̶t̶o̶r̶i̶n̶g̶.̶.̶.̶ ̶I̶ ̶l̶a̶z̶i̶l̶y̶ ̶c̶o̶p̶y̶ ̶p̶a̶s̶t̶e̶d̶ ̶t̶h̶e̶ ̶s̶c̶r̶i̶p̶t̶ ̶f̶o̶r̶ ̶t̶h̶e̶ ̶d̶i̶s̶t̶r̶o̶'̶s̶ ̶i̶f̶ ̶c̶a̶s̶e̶s̶,̶ ̶t̶h̶i̶s̶ ̶m̶a̶d̶e̶ ̶i̶t̶ ̶o̶v̶e̶r̶ ̶1̶7̶0̶0̶ ̶l̶i̶n̶e̶s̶ ̶l̶o̶n̶g̶.̶.̶.̶ ̶t̶h̶e̶r̶e̶ ̶s̶h̶o̶u̶l̶d̶ ̶b̶e̶ ̶a̶ ̶b̶e̶t̶t̶e̶r̶ ̶w̶a̶y̶ ̶b̶u̶t̶ ̶I̶'̶m̶ ̶s̶h̶o̶r̶t̶ ̶o̶n̶ ̶t̶i̶m̶e̶.̶ ̶i̶t̶ ̶w̶o̶r̶k̶s̶ ̶t̶h̶a̶t̶'̶s̶ ̶t̶h̶e̶ ̶m̶a̶i̶n̶ ̶f̶a̶c̶t̶o̶r̶.̶ now refactored : 2383 −> down to 671 !!!
- r̶e̶m̶o̶v̶e̶ ̶a̶s̶ ̶m̶u̶c̶h̶ ̶a̶s̶ ̶p̶o̶s̶s̶i̶b̶l̶e̶ ̶.̶b̶a̶s̶h̶r̶c̶ ̶m̶o̶d̶i̶f̶i̶c̶a̶t̶i̶o̶n̶s̶ ̶a̶n̶d̶ ̶d̶e̶f̶a̶u̶l̶t̶ ̶t̶o̶ ̶u̶s̶i̶n̶g̶ ̶t̶h̶e̶ ̶r̶u̶n̶ ̶f̶i̶l̶e̶ ̶s̶t̶e̶a̶m̶ ̶c̶r̶e̶a̶t̶e̶s̶
- m̶a̶k̶e̶ ̶t̶h̶i̶s̶ ̶s̶c̶r̶i̶p̶t̶ ̶m̶o̶r̶e̶ ̶p̶o̶s̶i̶x̶-̶c̶o̶m̶p̶l̶i̶a̶n̶t̶ could always be better
- ~~create if-cases for differing linux distros~~ 
- r̶e̶m̶o̶v̶e̶ ̶t̶h̶e̶ ̶n̶e̶e̶d̶ ̶f̶o̶r̶ ̶t̶h̶e̶ ̶u̶s̶e̶r̶ ̶s̶o̶ ̶s̶e̶t̶ ̶f̶a̶f̶ ̶s̶e̶t̶t̶i̶n̶g̶s̶ ̶h̶i̶m̶s̶e̶l̶f̶
- c̶r̶e̶a̶t̶e̶ ̶F̶A̶F̶ ̶l̶a̶u̶n̶c̶h̶e̶r̶ 
- f̶i̶g̶u̶r̶e̶ ̶o̶u̶t̶ ̶a̶ ̶p̶r̶o̶p̶e̶r̶ ̶f̶i̶x̶ ̶t̶o̶ ̶t̶h̶e̶ ̶c̶u̶r̶r̶e̶n̶t̶ ̶l̶a̶c̶k̶ ̶o̶f̶ ̶p̶a̶t̶h̶-̶r̶e̶s̶o̶l̶v̶i̶n̶g̶ ̶f̶o̶r̶ ̶F̶A̶F̶'̶s̶ ̶s̶e̶t̶t̶i̶n̶g̶ ̶"̶C̶o̶m̶m̶a̶n̶d̶ ̶l̶i̶n̶e̶ ̶f̶o̶r̶m̶a̶t̶ ̶f̶o̶r̶ ̶e̶x̶e̶c̶u̶t̶a̶b̶l̶e̶"̶ ̶t̶h̶e̶n̶ ̶t̶h̶e̶ ̶c̶u̶r̶r̶e̶n̶t̶ ̶w̶o̶r̶k̶a̶r̶o̶u̶n̶d̶:̶ ̶C̶u̶r̶r̶e̶n̶t̶l̶y̶ ̶I̶'̶m̶ ̶f̶o̶r̶c̶e̶d̶ ̶t̶o̶ ̶c̶o̶p̶y̶ ̶P̶r̶o̶t̶o̶n̶ ̶G̶a̶l̶l̶i̶u̶m̶ ̶n̶i̶n̶e̶'̶s̶ ̶f̶o̶l̶d̶e̶r̶ ̶t̶o̶ ̶a̶ ̶n̶e̶w̶ ̶f̶o̶l̶d̶e̶r̶ ̶a̶n̶d̶ ̶p̶o̶i̶n̶t̶ ̶t̶o̶ ̶t̶h̶a̶t̶ ̶n̶e̶w̶ ̶f̶o̶l̶d̶e̶r̶ ̶i̶n̶s̶t̶e̶a̶d̶ ̶b̶e̶c̶a̶u̶s̶e̶ ̶t̶h̶e̶ ̶n̶e̶w̶ ̶f̶o̶l̶d̶e̶r̶'̶s̶ ̶p̶a̶t̶h̶ ̶d̶o̶e̶s̶n̶'̶t̶ ̶c̶o̶n̶t̶a̶i̶n̶ ̶d̶o̶t̶s̶,̶ ̶n̶u̶m̶b̶e̶r̶s̶ ̶o̶r̶ ̶s̶p̶a̶c̶e̶s̶ ̶w̶h̶i̶c̶h̶ ̶"̶C̶o̶m̶m̶a̶n̶d̶ ̶l̶i̶n̶e̶ ̶f̶o̶r̶m̶a̶t̶ ̶f̶o̶r̶ ̶e̶x̶e̶c̶u̶t̶a̶b̶l̶e̶"̶ ̶s̶e̶t̶t̶i̶n̶g̶ ̶e̶n̶t̶r̶y̶ ̶i̶n̶ ̶F̶A̶F̶ ̶a̶p̶p̶a̶r̶e̶n̶t̶l̶y̶ ̶c̶a̶n̶n̶o̶t̶ ̶h̶a̶n̶d̶l̶e̶.̶ ̶I̶ ̶h̶a̶v̶e̶n̶'̶t̶ ̶r̶e̶s̶e̶a̶r̶c̶h̶e̶d̶ ̶t̶h̶i̶s̶ ̶s̶u̶f̶f̶i̶c̶i̶e̶n̶t̶l̶y̶ ̶b̶u̶t̶ ̶I̶ ̶s̶u̶s̶p̶e̶c̶t̶ ̶t̶h̶e̶r̶e̶'̶s̶ ̶a̶ ̶b̶e̶t̶t̶e̶r̶ ̶w̶a̶y̶ ̶t̶o̶ ̶d̶o̶ ̶t̶h̶i̶s̶.̶
- ~~figure out if any chages to /etc/environement are actually needed. I haven't been able to / or had time to rule out these changes as useless. ideally /ec/environment wouldn't be touched at all.~~ none were needed
- ideas welcome.

## Not working ?

Feedback will help me fix things. This script creates a very minimal log file called "faf_sh-\*.log" in your home. Paste it's contents as part of an issue/bug report. your first and foremost issue is probably the linux distro flavor, you can check what release is supported as of now [here](https://github.com/tatsujb/installFAFscript#run-successes-by-distro- "distro compatibility"), but a couple syntax edits should make my script work for you.

### known issues :

1. "game already running" this is by far the most common issue. it happens both when trying to restart steam after enabling Proton and after steamCMD download, when steam is attempting to run FA for the first time in order to generate the config.ini file. The solution to this is unclear for me. but sometimes attempting to run the game outisde of the script, sutting down you pc and restarting does this. In this case no need to have the script install FA for you which it now tolerates.

2. "I'm just missing Maps and Mods symlinking!" :
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
 3. another known issue is run files being kinda borked at generation. if you're not getting an FA starting when running from FAF but it does start from steam, this is what you may want to look into, your run file is at `$HOME/faf/` and here's a sample one to find issues with yours :

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

possible flaws are `/steam/steamapps/common/Proton/` being a `/compatibilitytools.d/Proton_3.16-6_Gallium_Nine_Extras_0.3.0/` instead or there not being a `LD_LIBRARY_PATH` or `DEF_CMD` having a `shutdown` at the end of it, also `steamapps` instead of `SteamApps`. Also try `WINEDLLOVERRIDES=""` (nothing inside).

4. Durring the FA start process from steam, the window for steam pre-check for Forged Alliance takes awhile then opens up too small and you get path assert failures. no panic! Simply close that window, go to your steam icon in the top left of your screen (notification's area) and open steam's library, right click on FA and click "properties", then go into the "local files" tab and click verify integrity of game files. Now try starting FA again. this time it should run. You can continue.


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
 - kill (used to stop faf in order to set settings, procps package if you don't have kill)
 - zenity (browse for folder)
 - jq (json modifier)
 
 Dependencies :
  
 - lib32gcc1 (steamCMD)
 - libnss3-tools libd3dadapter9-mesa:i386 libd3dadapter9-mesa (Gallium-Proton)
 - whiptail (contextual menus)
 - python3-pip python3-setuptools python3-venv (for pipx)
 -̶ ̶p̶i̶p̶x̶ ̶(̶n̶o̶t̶ ̶y̶e̶t̶,̶ ̶t̶h̶i̶s̶ ̶w̶i̶l̶l̶ ̶b̶e̶ ̶f̶o̶r̶ ̶g̶a̶l̶l̶i̶u̶m̶ ̶n̶i̶n̶e̶ ̶s̶u̶p̶p̶o̶r̶t̶)̶
 
 Unwanteds :
 
 - winetricks from apt (granted sudo, in the second step, this will be removed and the latest winetricks from github will be installed instead)

# Un-installing :

If you are in the use-case of re-running the script this is almost entirely unecessary with the current version of the script, however here are some commands you can run if you really want to clean up before or after running this script or to uninstall for good :

```
rm ~/the\ contents\ of\ this*
rm ~/faf_sh-*.log
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

1. Forged Alliance if you installed it to default dir :
```
rm -rf ~/.steam/steam/SteamApps/common/Supreme\ Commander\ Forged\ Alliance
```
2. keep steam but remove my steam extras such as Gallium9Proton and steamCMD and their dependencies : 
```
rm -rf ~/.steam/compatibilitytools.d
sudo apt purge -y steamcmd libnss3-tools libd3dadapter9-mesa:i386 libd3dadapter9-mesa lib32gcc1 python3-pip python3-setuptools python3-venv
sudo apt -y autoremove
```

3. OPTIONAL : Uninstall the whole of steam
if steam wasn't on your system before you ran this script and you are fine with seeing it and Supreme Commander Forged Alliance as well as steamCMD and eventual dependencies go then you can run the following :
```
rm ~/.steampath
rm ~/.steampid
rm -rf ~/.steam
rm -rf ~/Steam
echo steam steam/purge note '' | sudo debconf-set-selections
sudo apt purge -y steam
sudo apt -y autoremove
```
4. OPTIONAL restore old winetricks
```
sudo rm -rf /usr/bin/winetricks
sudo rm -rf /usr/share/bash-completion/completions/winetricks
sudo apt install winetricks
```

5. Java 10
```
grep -v 'INSTALL4J_JAVA_HOME' ~/.bashrc > ~/.bashrc2; mv ~/.bashrc2 ~/.bashrc
source ~/.bashrc
sudo rm -rf /usr/lib/jvm/jdk-10.0.2/
```




