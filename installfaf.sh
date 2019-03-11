#!/bin/bash
  faf_stack_version=1.9


echo "_______________________________________________________________________________________________________" >> ~/'fafstack-'$faf_stack_version'.log'
echo "-------------------------------------------------------------------------------------------------------" >> ~/'fafstack-'$faf_stack_version'.log'
unameOut="$(uname -s)"
case "${unameOut}" in
	Linux*)
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_stack_version" running : "$unameOut  >> ~/'fafstack-'$faf_stack_version'.log';;
	Darwin*)
echo "Mac / Apple Macintosh is not supported yet though it could technically be; as evidenced by previous examples of people running FA and even FAF on mac. Feel free to contribute at : https://github.com/tatsujb/installFAFscript"
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_stack_version". FAILIURE. MAC UNSUPPORTED. "$unameOut  >> ~/'fafstack-'$faf_stack_version'.log'
exit 1;;
	CYGWIN*)
echo "Hello, you can go straight to : www.faforever.com and click on \"Download Client\". This script exists in order to help linux users achieve the same thing you can do out-of-the-box on your operating system. You have not the remotest use for this script :) be free, wild bird!"
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_stack_version". FAILIURE. WINDOWS UNSUPPORTED. "$unameOut  >> ~/'fafstack-'$faf_stack_version'.log'
exit 1;;
	MINGW*)
echo "Hello, you can on MinGW you cannot run Forged Alliance, this script is of no use to you."
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_stack_version". FAILIURE. MINGW UNSUPPORTED. "$unameOut  >> ~/'fafstack-'$faf_stack_version'.log'
exit 1
esac

if [ -f /etc/os-release ]; then
	# freedesktop.org and systemd (Ubuntu 18.04+)
	. /etc/os-release
	operating_system=$NAME
	os_version=$os_versionSION_ID
	echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> ~/'fafstack-'$faf_stack_version'.log'  
elif type lsb_release >/dev/null 2>&1; then
	# linuxbase.org (older Debian / Ubuntu should be here)
	operating_system=$(lsb_release -si)
	os_version=$(lsb_release -sr)
	echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> ~/'fafstack-'$faf_stack_version'.log'
	if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
	then
    echo "You're probably right to choose this..."
    echo "exiting upon demand..."
    echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> ~/'fafstack-'$faf_stack_version'.log'
    exit 1
	else
    echo "OK! fingers crossed!"
    echo "continuing..."
    echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> ~/'fafstack-'$faf_stack_version'.log'
	fi
elif [ -f /etc/lsb-release ]; then
	# For some versions of Debian/Ubuntu without lsb_release command
	. /etc/lsb-release
	operating_system=$DISTRIB_ID
	os_version=$DISTRIB_RELEASE
	echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> ~/'fafstack-'$faf_stack_version'.log'
	if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
	then
    echo "You're probably right to choose this..."
    echo "exiting upon demand..."
    echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> ~/'fafstack-'$faf_stack_version'.log'
    exit 1
	else
    echo "OK! fingers crossed!"
    echo "continuing..."
    echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> ~/'fafstack-'$faf_stack_version'.log'
	fi
elif [ -f /etc/debian_version ]; then
	# Older Debian/Ubuntu/etc.
	operating_system=oldDebian
	os_version=$(cat /etc/debian_version)
	echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> ~/'fafstack-'$faf_stack_version'.log'
	if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
	then
    echo "You're probably right to choose this..."
    echo "exiting upon demand..."
    echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> ~/'fafstack-'$faf_stack_version'.log'
    exit 1
	else
    echo "OK! fingers crossed!"
    echo "continuing..."
    echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> ~/'fafstack-'$faf_stack_version'.log'
	fi
elif [ -f /etc/SuSe-release ]; then
	# Older SuSE/etc.
	operating_system=OpenSuSE
	os_version="unknown version but likely very old"
	echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> ~/'fafstack-'$faf_stack_version'.log'
	if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
	then
    echo "You're probably right to choose this..."
    echo "exiting upon demand..."
    echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> ~/'fafstack-'$faf_stack_version'.log'
    exit 1
	else
    echo "OK! fingers crossed!"
    echo "continuing..."
    echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> ~/'fafstack-'$faf_stack_version'.log'
	fi
elif [ -f /etc/redhat-release ]; then
	# Older Red Hat, CentOS, etc.
	operating_system=oldRedHatorCentos
	os_version="unknown version but likely very old"
	echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> ~/'fafstack-'$faf_stack_version'.log'
	if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
	then
    echo "You're probably right to choose this..."
    echo "exiting upon demand..."
    echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> ~/'fafstack-'$faf_stack_version'.log'
    exit 1
	else
    echo "OK! fingers crossed!"
    echo "continuing..."
    echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> ~/'fafstack-'$faf_stack_version'.log'
	fi
else
	# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
	operating_system=$(uname -s)
	os_version=$(uname -r)
	echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> ~/'fafstack-'$faf_stack_version'.log'
	if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
	then
    echo "You're probably right to choose this..."
    echo "exiting upon demand..."
    echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> ~/'fafstack-'$faf_stack_version'.log'
    exit 1
	else
    echo "OK! fingers crossed!"
    echo "continuing..."
    echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> ~/'fafstack-'$faf_stack_version'.log'
	fi
fi

# template for use cases according to distributions TODO: test output of above if statement on different virtualboxed distros
#case "${OS}" in
#	Ubuntu*)
#	;;
#	Debian*)
#	;;
#	oldDebian*)
#	;;
#	OpenSuSE*)
#	;;
#	oldRedHatorCentos*)
#    
#esac
echo "-------------------------------------------------------------------------------------------------------" >> ~/'fafstack-'$faf_stack_version'.log'
echo "Hard storage setup :" >> ~/'fafstack-'$faf_stack_version'.log'
echo "_______________________________________________________________________________________________________" >> ~/'fafstack-'$faf_stack_version'.log'
lsblk_ouput=$(lsblk | grep -v 'loop')
echo "$lsblk_ouput" >> ~/'fafstack-'$faf_stack_version'.log'
dfh_ouput=$(df -h --total | grep -v 'loop')
echo "$dfh_ouput" >> ~/'fafstack-'$faf_stack_version'.log'
echo "_______________________________________________________________________________________________________" >> ~/'fafstack-'$faf_stack_version'.log'
echo "" >> ~/'fafstack-'$faf_stack_version'.log'
echo "steam user name :"
read steam_user_name
echo "steam password :"
read -s steam_password
echo "[$(date --rfc-3339=seconds)] T1 Steam credentials entrusted to scritp" >> ~/'fafstack-'$faf_stack_version'.log' # NOTE THAT THIS IS NOT MY IDEAL SOLUTION BUT I HAVENT YET FOUND BETTER
sudo echo "[$(date --rfc-3339=seconds)] sudo priveledges entrusted to script" >> ~/'fafstack-'$faf_stack_version'.log' # AGAIN, SUGGESTIONS WELCOME...
if (whiptail --title "Use Gallium Nine Proton instead of vanilla Proton?" --yesno "If you don't know what Gallium Nine is or don't care, choose \"No\"." 10 100)
then
	gallium_nine=true
	echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1, PROTON_USE_GALLIUM_NINE=1, PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1" %command%' > ~/"the contents of this file are to be pasted in the forged alliance properties launch options"
	echo "[$(date --rfc-3339=seconds)] T1 Gallium Nine chosen" >> ~/'fafstack-'$faf_stack_version'.log'
else
	echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1 %command%' > ~/"the contents of this file are to be pasted in the forged alliance properties launch options"
	gallium_nine=false
	echo "[$(date --rfc-3339=seconds)] T1 Vanilla Proton chosen" >> ~/'fafstack-'$faf_stack_version'.log'
fi
if grep -Fxq "# deb http://archive.canonical.com/ubuntu cosmic partner" /etc/apt/sources.list
then
	echo "[$(date --rfc-3339=seconds)] T1 enabled partners" >> ~/'fafstack-'$faf_stack_version'.log'
	sudo sed -i 's/# deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/g' /etc/apt/sources.list
else
	echo "[$(date --rfc-3339=seconds)] T1 did not enable partners, hoping it was already enabled." >> ~/'fafstack-'$faf_stack_version'.log'
fi

# on fedora, will be
# dnf update
# dnf upgrade
# centos redhat and fedora all seem to use
# yum update
# arch seems to be pacman -Syu I've used yoghurt before when trying arch out but know it to not be shipped with arch

sudo apt update -y &&
sudo apt -y full-upgrade
sudo apt install whiptail
to_be_installed=0
if [ $(command -v steam) ]
then
	echo "steam is already installed, proceeding..."
	echo "[$(date --rfc-3339=seconds)] T1 steam is already installed, proceeding..." >> ~/'fafstack-'$faf_stack_version'.log'
else
	echo "[$(date --rfc-3339=seconds)] T1 steam was not yet installed, installing..." >> ~/'fafstack-'$faf_stack_version'.log'
	echo steam steam/question select "I AGREE" | sudo debconf-set-selections
	echo steam steam/license note '' | sudo debconf-set-selections
	to_be_installed=$((to_be_installed+1))
fi
if [ $(command -v curl) ]
then
	echo "[$(date --rfc-3339=seconds)] T1 curl is already installed, proceeding..." >> ~/'fafstack-'$faf_stack_version'.log'
	echo "curl is already installed, proceeding..."
else
	echo "[$(date --rfc-3339=seconds)] T1 curl was not yet installed, installing..." >> ~/'fafstack-'$faf_stack_version'.log'
	to_be_installed=$((to_be_installed+2))
fi
if [ $(command -v pv) ]
then
	echo "[$(date --rfc-3339=seconds)] T1 pv is already installed, proceeding..." >> ~/'fafstack-'$faf_stack_version'.log'
	echo "pv is already installed, proceeding..."
else
	echo "[$(date --rfc-3339=seconds)] T1 pv was not yet installed, installing..." >> ~/'fafstack-'$faf_stack_version'.log'
	to_be_installed=$((to_be_installed+4))
fi
case "${to_be_installed}" in
	0*)
	echo "nothing to install";;
	1*)
	sudo apt install -y steam;;
	2*)
	sudo apt install -y curl;;
	3*)
	sudo apt install -y curl steam;;
	4*)
	sudo apt install -y pv;;
	5*)
	sudo apt install -y pv steam;;
	6*)
	sudo apt install -y curl pv;;
	7*)
	sudo apt install -y curl pv steam
esac
 
#########################################################################################################################
#                                                                                                                   	#
# WIP! have not figured out a way to toggle proton-> [on] & set set launch options via command line, right now      	#
# you have to do it yourself when steam starts up while the script is running                                       	#
#                                                                                                                   	#
#########################################################################################################################
gnome-terminal --tab --active --title="install & run steam, steamcmd, FA" -- bash -c '[ '$gallium_nine' ] && echo "installing gallium/proton and running steam...";
echo "expecting you to type in Forged Alliances Launch options";
echo "reminder : look in your home folder, theres a file there with the contents to be pasted";
echo "once thats done edit steam settings in order to enable Proton for all games";
[ '$gallium_nine' ] && echo "it should have Gallium pre-selected already, this is what you want, just tick the box next to it.";
echo "";
echo "";
echo "[$(date --rfc-3339=seconds)] T2 running steam" >> ~/fafstack-'$faf_stack_version'.log;
if '$gallium_nine' ;
then mkdir -p ~/.steam/compatibilitytools.d;
proton_version=$(curl -v --silent https://api.github.com/repos/popsUlfr/Proton/releases 2>&1 | grep "tag_name" | head -n 1 | cut -f4,4 -d"\"");
proton_temp_value=$(curl -v --silent https://api.github.com/repos/popsUlfr/Proton/releases 2>&1 | grep "target_commitish" | head -n 1 | cut -f4,4 -d"\"" | sed "s/[^_]\+/\L\u&/g");
proton_version_number=${proton_temp_value/_G/-6_G};
proton_name=$proton_version_number"_"${proton_version##*-};
wget https://github.com/popsUlfr/Proton/releases/download/$proton_version/$proton_name.tar.xz;
pv $proton_name.tar.xz | tar xp -J -C ~/.steam/compatibilitytools.d;
rm $proton_name.tar.xz;
fi;
echo "starting Steam...";
echo "[$(date --rfc-3339=seconds)] T2 starting Steam..." >> ~/fafstack-'$faf_stack_version'.log;
steam -login '$steam_user_name' '$steam_password';
echo "starting Forged Alliance Download...";
echo "[$(date --rfc-3339=seconds)] T2 starting Forged Alliance Download..." >> ~/fafstack-'$faf_stack_version'.log;
steamcmd +login '$steam_user_name' '$steam_password' +@sSteamCmdForcePlatformType windows +app_update 9420 validate +quit;
echo "steamCMD terminated (in a good way), starting FA to finalize install";
echo "[$(date --rfc-3339=seconds)] T2 steamCMD terminated (in a good way), starting FA to finalize install" >> ~/fafstack-'$faf_stack_version'.log;
steam -login '$steam_user_name' '$steam_password' -applaunch 9420 -shutdown;
echo "FA install done. Waiting in case it isnt";
cp -f /tmp/proton_$USER/run ~/
echo "making map & mods symbolic links";
echo "[$(date --rfc-3339=seconds)] T2 making map & mods symbolic links" >> ~/fafstack-'$faf_stack_version'.log;
if [ -d ~/.steam/steam/steamapps ] ;
then steamapps="steamapps";
echo "[$(date --rfc-3339=seconds)] T2 steamapps found" >> ~/fafstack-'$faf_stack_version'.log;
if [ -d ~/.steam/steam/steamapps/common/Supreme* ] ;
then echo "[$(date --rfc-3339=seconds)] T2 Supreme Commander folder found" >> ~/fafstack-'$faf_stack_version'.log;
cd ~/.steam/steam/steamapps/common/Supreme\ Commander\ Forged\ Alliance;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods;
else echo "[$(date --rfc-3339=seconds)] T2 Supreme Commander folder not found" >> ~/fafstack-'$faf_stack_version'.log;
fi;
if [ -d ~/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser ] ;
then echo "[$(date --rfc-3339=seconds)] T2 steamuser profile folder found" >> ~/fafstack-'$faf_stack_version'.log;
cd ~/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser;
rm -rf My\ Documents;
mkdir My\ Documents;
cd My\ Documents;
ln -s ~/My\ Games/ My\ Games;
else echo "[$(date --rfc-3339=seconds)] T2 steamuser profile folder not found" >> ~/fafstack-'$faf_stack_version'.log;
fi;
elif [ -d ~/.steam/steam/SteamApps ];
then steamapps="SteamApps";
echo "[$(date --rfc-3339=seconds)] T2 SteamApps found" >> ~/fafstack-'$faf_stack_version'.log;
if [ -d ~/.steam/steam/SteamApps/common/Supreme* ] ;
then echo "[$(date --rfc-3339=seconds)] T2 Supreme Commander folder found" >> ~/fafstack-'$faf_stack_version'.log;
cd ~/.steam/steam/SteamApps/common/Supreme\ Commander\ Forged\ Alliance;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods;
else echo "[$(date --rfc-3339=seconds)] T2 Supreme Commander folder not found" >> ~/fafstack-'$faf_stack_version'.log;
fi;
if [ -d ~/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser ] ;
then echo "[$(date --rfc-3339=seconds)] T2 steamuser profile folder found" >> ~/fafstack-'$faf_stack_version'.log;
cd ~/.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser;
rm -rf My\ Documents;
mkdir My\ Documents;
cd My\ Documents;
ln -s ~/My\ Games/ My\ Games;
else echo "[$(date --rfc-3339=seconds)] T2 steamuser profile folder not found" >> ~/fafstack-'$faf_stack_version'.log;
fi;
else echo "[$(date --rfc-3339=seconds)] T2 neither cammel case (SteamApps), nor lowercase (steamapps) found" >> ~/fafstack-'$faf_stack_version'.log;
echo "UNACCEPTABLEEEEEEEEEEEEEEEE";
exit 1;
fi;
if '$gallium_nine' ;
then cp -rf ~/.steam/compatibilitytools.d/$proton_name ~/.steam/compatibilitytools.d/Proton;
mv ~/.steam/compatibilitytools.d/Proton ~/.steam/steam/$steamapps/common;
else cp -rf ~/.steam/steam/$steamapps/common/Proton* ~/.steam/steam/$steamapps/common/Proton;
mv ~/.steam/steam/$steamapps/common/Proton* ~/.steam/steam/$steamapps/common;
fi;
[[ ( -d ~/.steam/steam/steamapps/common/Proton ) || ( -d ~/.steam/steam/SteamApps/common/Proton ) ]] && echo "[$(date --rfc-3339=seconds)] T2 PROTON folder found" >> ~/fafstack-'$faf_stack_version'.log || echo "[$(date --rfc-3339=seconds)] T2 Proton folder not found" >> ~/fafstack-'$faf_stack_version'.log;
! grep -q "DEF_CMD" ~/.bashrc && echo "export DEF_CMD=(\"/home/${USER}/.steam/steam/${steamapps}/common/Supreme Commander Forged Alliance/bin/SupremeCommander.exe\")" >> ~/.bashrc;
! grep -q "export TERM" ~/.bashrc && echo "export TERM=xterm" >> ~/.bashrc;
! grep -q "WINEDEBUG" ~/.bashrc && echo "export WINEDEBUG=-all" >> ~/.bashrc;
! grep -q "WINEDLLPATH" ~/.bashrc && echo "export WINEDLLPATH=/home/${USER}/.steam/steam/${steamapps}/common/Proton/dist/lib64/wine:/home/${USER}/.steam/steam/${steamapps}/common/Proton/dist/lib/wine" >> ~/.bashrc;
! grep -q "LD_LIBRARY_PATH" ~/.bashrc && echo "export LD_LIBRARY_PATH=/home/${USER}/.steam/steam/${steamapps}/common/Proton/dist/lib64:/home/${USER}/.steam/steam/${steamapps}/common/Proton/dist/lib:/home/${USER}/.steam/ubuntu12_32/steam-runtime/pinned_libs_32:/home/${USER}/.steam/ubuntu12_32/steam-runtime/pinned_libs_64:/usr/lib/x86_64-linux-gnu/libfakeroot:/lib/i386-linux-gnu:/usr/lib/i386-linux-gnu:/usr/local/lib:/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:/lib:/usr/lib:/home/${USER}/.steam/ubuntu12_32/steam-runtime/i386/lib/i386-linux-gnu:/home/${USER}/.steam/ubuntu12_32/steam-runtime/i386/lib:/home/${USER}/.steam/ubuntu12_32/steam-runtime/i386/usr/lib/i386-linux-gnu:/home/${USER}/.steam/ubuntu12_32/steam-runtime/i386/usr/lib:/home/${USER}/.steam/ubuntu12_32/steam-runtime/amd64/lib/x86_64-linux-gnu:/home/${USER}/.steam/ubuntu12_32/steam-runtime/amd64/lib:/home/${USER}/.steam/ubuntu12_32/steam-runtime/amd64/usr/lib/x86_64-linux-gnu:/home/${USER}/.steam/ubuntu12_32/steam-runtime/amd64/usr/lib" >> ~/.bashrc;
! grep -q "WINEDLLPATH" ~/.bashrc && echo "export WINEDLLPATH=/home/${USER}/.steam/Proton/dist/lib64/wine:/home/${USER}/.steam/Proton/dist/lib/wine" >> ~/.bashrc;
! grep -q "WINEPREFIX" ~/.bashrc && echo "export WINEPREFIX=/home/${USER}/.steam/steam/${steamapps}/compatdata/9420/pfx/" >> ~/.bashrc;
! grep -q "SteamGameId" ~/.bashrc && echo "export SteamGameId=9420" >> ~/.bashrc;
! grep -q "SteamAppId" ~/.bashrc && echo "export SteamAppId=9420" >> ~/.bashrc;
! grep -q "WINEDLLOVERRIDES" ~/.bashrc && echo "export WINEDLLOVERRIDES=\"\"" >> ~/.bashrc;
source ~/.bashrc;
eval "$(cat ~/.bashrc | tail -n +10)";
echo "Finished thread two (install & run steam, steamcmd, FA) without issue, starting (FAF)...";
echo "[$(date --rfc-3339=seconds)] T2 Finished thread two (install & run steam, steamcmd, FA) without issue, starting (FAF)..." >> ~/fafstack-'$faf_stack_version'.log;
gnome-terminal --tab --title="(FAF)" -- bash -c "cd ~/faf; ./downlords-faf-client";'
# source ~/.bashrc be it in main thread or in tab, has no effect the user will have to run it himself.
# end of second thread
# finalising apt-install
echo "[$(date --rfc-3339=seconds)] T1 start of second thread did not crash first thread" >> ~/'fafstack-'$faf_stack_version'.log'
if ! dpkg-query -W -f='${Status}' lib32gcc1 | grep "ok installed"
then
	echo "[$(date --rfc-3339=seconds)] T1 lib32gcc1 was not yet installed, installing..." >> ~/'fafstack-'$faf_stack_version'.log'
	sudo apt install -y lib32gcc1
else
	echo "[$(date --rfc-3339=seconds)] T1 lib32gcc1 is already installed, proceeding..." >> ~/'fafstack-'$faf_stack_version'.log'
	echo "lib32gcc1 is already installed, proceeding..."
fi
if [ $(command -v steamcmd) ]
then
	echo "[$(date --rfc-3339=seconds)] T1 steam CMD is already installed, proceeding..." >> ~/'fafstack-'$faf_stack_version'.log'
	echo "steam CMD is already installed, proceeding..."
else
	echo "[$(date --rfc-3339=seconds)] T1 steam CMD was not yet installed, installing..." >> ~/'fafstack-'$faf_stack_version'.log'
	echo steamcmd steam/question select "I AGREE" | sudo debconf-set-selections
	echo steamcmd steam/license note '' | sudo debconf-set-selections
	sudo useradd -m steam
	cd /home/steam
	sudo apt install -y steamcmd
	cd
fi
if ! dpkg-query -W -f='${Status}' libnss3-tools | grep "ok installed"
then
	echo "[$(date --rfc-3339=seconds)] T1 libnss3 was not yet installed, installing..." >> ~/'fafstack-'$faf_stack_version'.log'
	sudo apt install -y libnss3-tools
else
	echo "[$(date --rfc-3339=seconds)] T1 libnss3 is already installed, proceeding..." >> ~/'fafstack-'$faf_stack_version'.log'
	echo "libnss3 is already installed, proceeding..."
fi
[ $gallium_nine ] && sudo apt install -y libd3dadapter9-mesa:i386 libd3dadapter9-mesa &&
sudo apt autoremove -y &&
sudo apt autoclean
# no more apt-install
# Java fix-me block
echo "Now probing the Java status of this OS..."
echo "[$(date --rfc-3339=seconds)] T1 Now probing the Java status of this OS..." >> ~/'fafstack-'$faf_stack_version'.log'
if [[ $(command -v java) ]] || [[ $(type -p java) ]] || [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]
then
	echo "UH-OH, Java is already installed!"
	echo "This is suboptimal, crossing fingers for correct version Java version (E.G. version number 10)..."
	echo "[$(date --rfc-3339=seconds)] T1 Java already installed!" >> ~/'fafstack-'$faf_stack_version'.log'
	if [ $(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -f1 -d'.') == "10" ]
	then
    echo "Huzzah! you have the correct version of Java, here's hoping for the best!"
    echo "Checking, if .bashrc config is also correct..."
    echo "[$(date --rfc-3339=seconds)] T1 specifically Java 10." >> ~/'fafstack-'$faf_stack_version'.log'
    if grep -q "export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2" ~/.bashrc
    then
    	echo "Huzzah! Java looks all set, let's move on..."
    	echo "[$(date --rfc-3339=seconds)] T1 satisfied with Java config." >> ~/'fafstack-'$faf_stack_version'.log'
    	else
        	echo "Hmmm... we're not looking to hot on .bashrc, let's see if we can fix that..."
    	echo "[$(date --rfc-3339=seconds)] T1 but not correct config." >> ~/'fafstack-'$faf_stack_version'.log'
        	if (whiptail --title "Entered : \"Java 10 present but .bashrc not correctly configured use-case\"" --yesno "Attempt .bashrc automated correct? \n\"No\" will close this script \n\"Yes\" will automatically edit bashrc \n(keep in mind this script was written by a donkey...)" 10 100)
    	then
   	 echo "OK! \".bashrc\" edited!"
   	 echo "assuming Java is all set, let's move on..."
   	 echo "[$(date --rfc-3339=seconds)] T1 corrected Java config." >> ~/'fafstack-'$faf_stack_version'.log'
    	else
   	 echo "You're probably right to choose this..."
   	 echo "please edit .bashrc yourself or remove Java 10 and start over."
   	 echo "exiting upon demand..."
   	 echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, Java was ill-configured" >> ~/'fafstack-'$faf_stack_version'.log'
   	 exit 1
    	fi      	 
    	fi
	else
    if [ ! -f /usr/lib/jvm ]
    then
    	echo "your Path is defined but Java is not in /usr/lib/jvm "
        	echo "[$(date --rfc-3339=seconds)] T1 potential unclean uninstall of Java, java detected set yet /usr/lib/jvm does not even exist" >> ~/'fafstack-'$faf_stack_version'.log'
    fi
    	echo "You have a version of Java that is not Java 10"
    	echo "This is problematic as this case is not yet handled by this script (though it could easily be!)"
    	echo "Feel free to contribute at : https://github.com/tatsujb/installFAFscript"
    	echo "The easliest sollution for you to use this script as-is, is for you to purge all Java versions from your system (be sure to remove references in /etc/environment),"
    	echo "then, re-run this script"
    	echo "FAF-stack not installed, exiting..."
    echo "[$(date --rfc-3339=seconds)] T1 Incorrect Java version, exiting!" >> ~/'fafstack-'$faf_stack_version'.log'
    	exit 1
	fi
else
	# Download & install java 10 open jdk
	echo "Java 10 installation procedure..."
	echo "[$(date --rfc-3339=seconds)] T1 Java 10 installing..." >> ~/'fafstack-'$faf_stack_version'.log'
	wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
	sudo mkdir -p /usr/lib/jvm
	cd /usr/lib/jvm
	sudo pv ~/openjdk-10.0.2_linux-x64_bin.tar.gz | sudo tar xzp -C /usr/lib/jvm
	cd
	rm openjdk-10.0.2_linux-x64_bin.tar.gz
	sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-10.0.2/bin/java" 0
	sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-10.0.2/bin/javac" 0
	sudo update-alternatives --set java /usr/lib/jvm/jdk-10.0.2/bin/java
	sudo update-alternatives --set javac /usr/lib/jvm/jdk-10.0.2/bin/javac
	! grep -q 'INSTALL4J_JAVA_HOME' ~/.bashrc && echo "export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2" >> ~/.bashrc
	# /end Download & install java 10 open jdk
fi
# /end Java fix-me block
# Download & install FAF client
echo "now moving on to installing Downlord's FAF..."
echo "[$(date --rfc-3339=seconds)] T1 installing DOWNLORD" >> ~/'fafstack-'$faf_stack_version'.log'
cd
mkdir faf
cd faf
rm -rf *
faf_version_number=$(curl -v --silent https://api.github.com/repos/FAForever/downlords-faf-client/releases 2>&1 | grep '"tag_name": ' | head -n 1 | cut -f4,4 -d'"')
faf_version=$( echo ${faf_version_number:1} | tr '.' '_' )
wget https://github.com/FAForever/downlords-faf-client/releases/download/$faf_version_number/_dfc_unix_$faf_version.tar.gz
pv _dfc_unix_$faf_version.tar.gz | tar xzp -C ~/faf
mv downlords-faf-client-${faf_version_number:1}/{.,}* . 2>/dev/null
rm -rf downlords-faf-client-${faf_version_number:1}
rm _dfc_unix_$faf_version.tar.gz
chmod +x downlords-faf-client && chmod +x lib/faf-uid
cd
# /end Download & install FAF client
echo "please switch to terminal tab : \"install & run steam, steamcmd, FA\"."
echo ""
no_proton_found=true
i=1
sp="/-\|"
echo -n "waiting...  "
while $no_proton_found
do
  printf "\b${sp:i++%${#sp}:1}"
  [[ ( -d ~/.steam/steam/steamapps/common/Proton ) || ( -d ~/.steam/steam/SteamApps/common/Proton ) ]] && no_proton_found=fa
  sleep 1
done
echo "Finished thread one (proton/downlord/open-jdk/bashrc) without issue..."
echo "[$(date --rfc-3339=seconds)] T1 Finished thread one. (proton/downlord/open-jdk/bashrc)" >> ~/'fafstack-'$faf_stack_version'.log'
