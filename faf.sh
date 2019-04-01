#!/bin/bash
  faf_sh_version=2.2
  
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

real_user=$(du /home 2>/dev/null | sort -n -r | head -n 2 | tail -n +2 | cut -d/ -f3)
user_path="/home/"$real_user
cd $user_path

echo "_______________________________________________________________________________________________________" >> $user_path/faf.sh-$faf_sh_version.log
echo "-------------------------------------------------------------------------------------------------------" >> $user_path/faf.sh-$faf_sh_version.log
# DETERMINE OS BASE :
unameOut="$(uname -s)"
case "${unameOut}" in
	Linux*)
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_sh_version" running : "$unameOut  >> $user_path/faf.sh-$faf_sh_version.log;;
	Darwin*)
echo "Mac / Apple Macintosh is not supported yet though it could technically be; as evidenced by previous examples of people running FA and even FAF on mac. Feel free to contribute at : https://github.com/tatsujb/installFAFscript"
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_sh_version". FAILIURE. MAC UNSUPPORTED. "$unameOut  >> $user_path/faf.sh-$faf_sh_version.log
exit 1;;
	CYGWIN*)
echo "Hello, you can go straight to : www.faforever.com and click on \"Download Client\". This script exists in order to help linux users achieve the same thing you can do out-of-the-box on your operating system. You have not the remotest use for this script :) be free, wild bird!"
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_sh_version". FAILIURE. WINDOWS UNSUPPORTED. "$unameOut  >> $user_path/faf.sh-$faf_sh_version.log
exit 1;;
	MINGW*)
echo "Hello, are can on MinGW you cannot run Forged Alliance, this script is of no use to you."
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_sh_version". FAILIURE. MINGW UNSUPPORTED. "$unameOut  >> $user_path/faf.sh-$faf_sh_version.log
exit 1
esac


function install_basics_function
{
if [ "$operating_system" = "Debian GNU/Linux" ];
then
	apt install whiptail procps -y; # here, in debian, user is already supposed to be running script as root. suggestions welcome
else
    sudo echo "[$(date --rfc-3339=seconds)] sudo priveledges entrusted to script" >> ~/'faf.sh-'$faf_sh_version'.log' # suggestions welcome regarding entrusting sudo to a script
    sudo apt install whiptail procps -y;
fi;
}

# DETERMINE LINUX DISTRO AND RELEASE :
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd (Ubuntu 18.04+)
    . /etc/os-release
    operating_system=$NAME
    os_version=$VERSION_ID
    is_plasma="$(echo $XDG_DATA_DIRS | grep -Eo 'plasma')"
    if [ \( "$is_plasma" == "plasma" \) -o \( "$VERSION_ID" == "Ubuntu" \) ]
	then
		operating_system=Kubuntu
    fi
    if [ -z "$os_version" ]
    then
        os_version=$(lsb_release -sr)
    fi
    install_basics_function
elif type lsb_release >/dev/null 2>&1; then
	# linuxbase.org (older Debian / Ubuntu should be here)
	operating_system=$(lsb_release -si)
	os_version=$(lsb_release -sr)
	install_basics_function
	if (whiptail --title "Distribution may be a little old ('$os_version') and is, at present, untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
	then
    echo "You're probably right to choose this..."
    echo "exiting upon demand..."
    echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> $user_path/faf.sh-$faf_sh_version.log
    exit 1
	else
    echo "OK! fingers crossed!"
    echo "continuing..."
    echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> $user_path/faf.sh-$faf_sh_version.log
	fi
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    operating_system=$DISTRIB_ID
    os_version=$DISTRIB_RELEASE
    install_basics_function
    if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
    then
	echo "You're probably right to choose this..."
	echo "exiting upon demand..."
	echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> $user_path/faf.sh-$faf_sh_version.log
	exit 1
    else
	echo "OK! fingers crossed!"
	echo "continuing..."
	echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> $user_path/faf.sh-$faf_sh_version.log
    fi
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    operating_system=oldDebian
    os_version=$(cat /etc/debian_version)
    install_basics_function
    if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
    then
	echo "You're probably right to choose this..."
	echo "exiting upon demand..."
	echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> $user_path/faf.sh-$faf_sh_version.log
	exit 1
    else
	echo "OK! fingers crossed!"
	echo "continuing..."
	echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> $user_path/faf.sh-$faf_sh_version.log
    fi
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    operating_system=OpenSuSE
    os_version="unknown version but likely very old"
    install_basics_function
    if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
    then
	echo "You're probably right to choose this..."
	echo "exiting upon demand..."
	echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> $user_path/faf.sh-$faf_sh_version.log
	exit 1
    else
	echo "OK! fingers crossed!"
	echo "continuing..."
	echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> $user_path/faf.sh-$faf_sh_version.log
    fi
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    operating_system=oldRedHatorCentos
    os_version="unknown version but likely very old"
    install_basics_function
    if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
    then
	echo "You're probably right to choose this..."
	echo "exiting upon demand..."
	echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> $user_path/faf.sh-$faf_sh_version.log
	exit 1
    else
	echo "OK! fingers crossed!"
	echo "continuing..."
	echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> $user_path/faf.sh-$faf_sh_version.log
    fi
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    operating_system=$(uname -s)
    os_version=$(uname -r)
    install_basics_function
    if (whiptail --title "Distribution $operating_system $os_version is at present untested, Abort?" --yesno "Pursuing means you believe you know what you are doing and have pre-emptively read the contents of this .sh and are endowed with the needed skill to repair your OS, should things go wrong.\n\n        	Abort?     	\"Yes\" will stop the scipt,      	\"No\" will pursue" 10 100)
    then
	echo "You're probably right to choose this..."
	echo "exiting upon demand..."
	echo "[$(date --rfc-3339=seconds)] T1 Abandoned on user demand, OS version too experimental" >> $user_path/faf.sh-$faf_sh_version.log
	exit 1
    else
	echo "OK! fingers crossed!"
 	echo "continuing..."
	echo "[$(date --rfc-3339=seconds)] T1 wrong distribution, user-chosen continue." >> $user_path/faf.sh-$faf_sh_version.log
    fi
fi

echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> $user_path/faf.sh-$faf_sh_version.log
echo "-------------------------------------------------------------------------------------------------------" >> $user_path/faf.sh-$faf_sh_version.log
echo "Hard storage setup :" >> $user_path/faf.sh-$faf_sh_version.log
echo "_______________________________________________________________________________________________________" >> $user_path/faf.sh-$faf_sh_version.log
lsblk_ouput=$(lsblk | grep -v 'loop')
echo "$lsblk_ouput" >> $user_path/faf.sh-$faf_sh_version.log
dfh_ouput=$(df -h --total | grep -v 'loop')
echo "$dfh_ouput" >> $user_path/faf.sh-$faf_sh_version.log
echo "_______________________________________________________________________________________________________" >> $user_path/faf.sh-$faf_sh_version.log
echo "" >> $user_path/faf.sh-$faf_sh_version.log
while [ -z "$steam_user_name" ]
do
	echo "steam user name :"
	read steam_user_name
done
while [ -z "$steam_password" ]
do
	echo "steam password :"
	read -s steam_password
done
echo "[$(date --rfc-3339=seconds)] T1 Steam credentials entrusted to scritp" >> $user_path/faf.sh-$faf_sh_version.log # NOTE THAT THIS IS NOT MY IDEAL SOLUTION BUT I HAVENT YET FOUND BETTER

if (whiptail --title "Use Gallium Nine Proton instead of vanilla Proton?" --yesno "If you don't know what Gallium Nine is or don't care, choose \"No\"." 10 100)
then
	gallium_nine=true
	echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1, PROTON_USE_GALLIUM_NINE=1, PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1" %command%' > $user_path/"the contents of this file are to be pasted in the forged alliance properties launch options"
	echo "[$(date --rfc-3339=seconds)] T1 Gallium Nine chosen" >> $user_path/faf.sh-$faf_sh_version.log
else
	echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1 %command%' > $user_path/"the contents of this file are to be pasted in the forged alliance properties launch options"
	gallium_nine=false
	echo "[$(date --rfc-3339=seconds)] T1 Vanilla Proton chosen" >> $user_path/faf.sh-$faf_sh_version.log
fi


# sources editting stack for debian
if [ "$operating_system" = "Debian GNU/Linux" ]
then	
	if grep -q "debian.org/debian/ stretch main contrib non-free" /etc/apt/sources.list > /dev/null
	then
		echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : stretch already correct" >> $user_path/$user_path/faf.sh-$faf_sh_version.log
	else 
		echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : stretch edited" >> $user_path/faf.sh-$faf_sh_version.log
		sed -i "s_debian.org/debian/ stretch main contrib_debian.org/debian/ stretch main contrib non-free_" /etc/apt/sources.list
	fi

	if grep -q "http://security.debian.org/debian-security stretch/updates main contrib non-free" /etc/apt/sources.list > /dev/null
	then
		echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : stretch/updates already correct" >> $user_path/faf.sh-$faf_sh_version.log
	else
		echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : stretch/updates edited" >> $user_path/faf.sh-$faf_sh_version.log
		sed -i "s_http://security.debian.org/debian-security stretch/updates main contrib_http://security.debian.org/debian-security stretch/updates main contrib non-free_" /etc/apt/sources.list
	fi

	if grep -q "debian.org/debian/ stretch-updates main contrib non-free" /etc/apt/sources.list > /dev/null
	then
		echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : stretch-updates already correct" >> $user_path/faf.sh-$faf_sh_version.log
	else
		echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : stretch-updates edited" >> $user_path/faf.sh-$faf_sh_version.log
		sed -i "s_debian.org/debian/ stretch-updates main contrib_debian.org/debian/ stretch-updates main contrib non-free_" /etc/apt/sources.list
	fi

	if grep -q "deb http://ftp.*.debian.org/debian/ stretch-proposed-updates main contrib non-free" /etc/apt/sources.list > /dev/null
	then
		echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : proposed already present" >> $user_path/faf.sh-$faf_sh_version.log
	else
		donwload_country=$(grep "deb http://ftp." /etc/apt/sources.list | head -1 | cut -d. -f2)
		echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : added proposed" >> $user_path/faf.sh-$faf_sh_version.log
		echo "deb http://ftp.$donwload_country.debian.org/debian/ stretch-proposed-updates main contrib non-free" >> /etc/apt/sources.list
	fi
# sources editting stack for other (ubuntu-based)
else
	if grep -Fxq "# deb http://archive.canonical.com/ubuntu cosmic partner" /etc/apt/sources.list
	then
		echo "[$(date --rfc-3339=seconds)] T1 enabled partners" >> ~/'faf.sh-'$faf_sh_version'.log'
		sudo sed -i 's/# deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/g' /etc/apt/sources.list
	else
		echo "[$(date --rfc-3339=seconds)] T1 did not enable partners, hoping it was already enabled." >> ~/'faf.sh-'$faf_sh_version'.log'
	fi
fi

to_be_installed=0
if [ $(command -v steam) ]
then
	echo "steam is already installed, proceeding..."
	echo "[$(date --rfc-3339=seconds)] T1 steam is already installed, proceeding..." >> $user_path/faf.sh-$faf_sh_version.log
else
	echo "[$(date --rfc-3339=seconds)] T1 steam was not yet installed, installing..." >> $user_path/faf.sh-$faf_sh_version.log
	if [ "$operating_system" != "Zorin OS" ]
	then
		if [ "$operating_system" = "Debian GNU/Linux" ]
		then
			echo steam steam/question select "I AGREE" | debconf-set-selections
			echo steam steam/license note '' | debconf-set-selections
		else
			echo steam steam/question select "I AGREE" | sudo debconf-set-selections
			echo steam steam/license note '' | sudo debconf-set-selections
		fi
	fi
	if [ "$operating_system" = "Debian GNU/Linux" ]
	then
		usermod -a -G video,audio $real_user
    		dpkg --add-architecture i386
	fi
	to_be_installed=$((to_be_installed+1))
fi
if [ $(command -v curl) ]
then
	echo "[$(date --rfc-3339=seconds)] T1 curl is already installed, proceeding..." >> $user_path/faf.sh-$faf_sh_version.log
	echo "curl is already installed, proceeding..."
else
	echo "[$(date --rfc-3339=seconds)] T1 curl was not yet installed, installing..." >> $user_path/faf.sh-$faf_sh_version.log
	to_be_installed=$((to_be_installed+2))
fi
if [ $(command -v pv) ]
then
	echo "[$(date --rfc-3339=seconds)] T1 pv is already installed, proceeding..." >> $user_path/faf.sh-$faf_sh_version.log
	echo "pv is already installed, proceeding..."
else
	echo "[$(date --rfc-3339=seconds)] T1 pv was not yet installed, installing..." >> $user_path/faf.sh-$faf_sh_version.log
	to_be_installed=$((to_be_installed+4))
fi
if [ $(command -v jq) ]
then
	echo "[$(date --rfc-3339=seconds)] T1 jq is already installed, proceeding..." >> $user_path/faf.sh-$faf_sh_version.log
	echo "jq is already installed, proceeding..."
else
	echo "[$(date --rfc-3339=seconds)] T1 jq was not yet installed, installing..." >> $user_path/faf.sh-$faf_sh_version.log
	to_be_installed=$((to_be_installed+8))
fi
if [ "$operating_system" = "Debian GNU/Linux" ]
then
	apt update -y
	apt -y full-upgrade
	case "${to_be_installed}" in
		0)
		echo "nothing to install";;
		1)
		apt install -y steam;;
		2)
		apt install -y curl;;
		3)
		apt install -y curl steam;;
		4)
		apt install -y pv;;
		5)
		apt install -y pv steam;;
		6)
		apt install -y curl pv;;
		7)
		apt install -y curl pv steam;;
		8)
		apt install -y jq;;
		9)
		apt install -y jq steam;;
		10)
		apt install -y curl jq;;
		11)
		apt install -y curl jq steam;;
		12)
		apt install -y pv jq;;
		13)
		apt install -y pv jq steam;;
		14)
		apt install -y curl jq pv;;
		15)
		apt install -y jq curl pv steam
	esac
else
	sudo apt update -y
	sudo apt -y full-upgrade
	case "${to_be_installed}" in
		0)
		echo "nothing to install";;
		1)
		sudo apt install -y steam;;
		2)
		sudo apt install -y curl;;
		3)
		sudo apt install -y curl steam;;
		4)
		sudo apt install -y pv;;
		5)
		sudo apt install -y pv steam;;
		6)
		sudo apt install -y curl pv;;
		7)
		sudo apt install -y curl pv steam;;
		8)
		sudo apt install -y jq;;
		9)
		sudo apt install -y jq steam;;
		10)
		sudo apt install -y curl jq;;
		11)
		sudo apt install -y curl jq steam;;
		12)
		sudo apt install -y pv jq;;
		13)
		sudo apt install -y pv jq steam;;
		14)
		sudo apt install -y curl jq pv;;
		15)
		sudo apt install -y jq curl pv steam
	esac
fi
#########################################################################################################################
#                                                                                                                   	#
# WIP! have not figured out a way to toggle proton-> [on] & set set launch options via command line, right now      	#
# you have to do it yourself when steam starts up while the script is running                                       	#
#                                                                                                                   	#
#########################################################################################################################
middlescript='[ '$gallium_nine' ] && echo "installing gallium/proton and running steam...";
echo "expecting you to type in Forged Alliances Launch options";
echo "reminder : look in your home folder, theres a file there with the contents to be pasted";
echo "once thats done edit steam settings in order to enable Proton for all games";
[ '$gallium_nine' ] && echo "it should have Gallium pre-selected already, this is what you want, just tick the box next to it.";
echo "";
echo "";
echo "[$(date --rfc-3339=seconds)] T2 running steam" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
if '$gallium_nine' ;
then mkdir -p '$user_path'/.steam/compatibilitytools.d;
proton_version=$(curl -v --silent https://api.github.com/repos/popsUlfr/Proton/releases 2>&1 | grep "tag_name" | head -n 1 | cut -f4,4 -d"\"");
proton_temp_value=$(curl -v --silent https://api.github.com/repos/popsUlfr/Proton/releases 2>&1 | grep "target_commitish" | head -n 1 | cut -f4,4 -d"\"" | sed "s/[^_]\+/\L\u&/g");
proton_version_number=${proton_temp_value/_G/-6_G};
proton_name=$proton_version_number"_"${proton_version##*-};
wget https://github.com/popsUlfr/Proton/releases/download/$proton_version/$proton_name.tar.xz;
pv $proton_name.tar.xz | tar xp -J -C '$user_path'/.steam/compatibilitytools.d;
rm $proton_name.tar.xz;
fi;
echo "starting Steam...";
echo "[$(date --rfc-3339=seconds)] T2 starting Steam..." >> '$user_path'/faf.sh-'$faf_sh_version'.log;
steam -login '$steam_user_name' '$steam_password';
echo "starting Forged Alliance Download...";
echo "[$(date --rfc-3339=seconds)] T2 starting Forged Alliance Download..." >> '$user_path'/faf.sh-'$faf_sh_version'.log;
while [ \( ! -d ~/.steam/steam/steamapps/common/Supreme* \) -a \( ! -d ~/.steam/steam/SteamApps/common/Supreme* \) ];
do steamcmd +login '$steam_user_name' '$steam_password' +@sSteamCmdForcePlatformType windows +app_update 9420 validate +quit;
done;
echo "steamCMD terminated (in a good way), starting FA to finalize install";
echo "[$(date --rfc-3339=seconds)] T2 steamCMD terminated (in a good way), starting FA to finalize install" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
steam -login '$steam_user_name' '$steam_password' -applaunch 9420 -shutdown;
echo "FA install done. Waiting in case it isnt";
cp -f /tmp/proton_'$real_user'/run '$user_path'/faf/
echo "making map & mods symbolic links";
echo "[$(date --rfc-3339=seconds)] T2 making map & mods symbolic links" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
if [ -d '$user_path'/.steam/steam/steamapps ] ;
then steamapps="steamapps";
echo "[$(date --rfc-3339=seconds)] T2 steamapps found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
if [ -d '$user_path'/.steam/steam/steamapps/common/Supreme* ] ;
then echo "[$(date --rfc-3339=seconds)] T2 Supreme Commander folder found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
cd '$user_path'/.steam/steam/steamapps/common/Supreme\ Commander\ Forged\ Alliance;
ln -s '$user_path'/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps;
ln -s '$user_path'/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods;
else echo "[$(date --rfc-3339=seconds)] T2 Supreme Commander folder not found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
fi;
if [ -d '$user_path'/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser ] ;
then echo "[$(date --rfc-3339=seconds)] T2 steamuser profile folder found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
cd '$user_path'/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser;
rm -rf My\ Documents;
mkdir My\ Documents;
cd My\ Documents;
ln -s '$user_path'/My\ Games/ My\ Games;
else echo "[$(date --rfc-3339=seconds)] T2 steamuser profile folder not found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
fi;
elif [ -d '$user_path'/.steam/steam/SteamApps ];
then steamapps="SteamApps";
echo "[$(date --rfc-3339=seconds)] T2 SteamApps found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
if [ -d '$user_path'/.steam/steam/SteamApps/common/Supreme* ] ;
then echo "[$(date --rfc-3339=seconds)] T2 Supreme Commander folder found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
cd '$user_path'/.steam/steam/SteamApps/common/Supreme\ Commander\ Forged\ Alliance;
ln -s '$user_path'/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps;
ln -s '$user_path'/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods;
else echo "[$(date --rfc-3339=seconds)] T2 Supreme Commander folder not found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
fi;
if [ -d '$user_path'/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser ] ;
then echo "[$(date --rfc-3339=seconds)] T2 steamuser profile folder found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
cd '$user_path'.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser;
rm -rf My\ Documents;
mkdir My\ Documents;
cd My\ Documents;
ln -s '$user_path'/My\ Games/ My\ Games;
else echo "[$(date --rfc-3339=seconds)] T2 steamuser profile folder not found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
fi;
else echo "[$(date --rfc-3339=seconds)] T2 neither cammel case (SteamApps), nor lowercase (steamapps) found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
echo "UNACCEPTABLEEEEEEEEEEEEEEEE";
exit 1;
fi;
if '$gallium_nine' ;
then cp -rf '$user_path'/.steam/compatibilitytools.d/$proton_name '$user_path'/.steam/compatibilitytools.d/Proton;
mv '$user_path'/.steam/compatibilitytools.d/Proton '$user_path'/.steam/steam/$steamapps/common;
else cp -rf '$user_path'/.steam/steam/$steamapps/common/Proton* '$user_path'/.steam/steam/$steamapps/common/Proton;
fi;
[ \( -d '$user_path'/.steam/steam/steamapps/common/Proton \) -o \( -d '$user_path'/.steam/steam/SteamApps/common/Proton \) ] && echo "[$(date --rfc-3339=seconds)] T2 PROTON folder found" >> '$user_path'/faf.sh-'$faf_sh_version'.log || echo "[$(date --rfc-3339=seconds)] T2 Proton folder not found" >> '$user_path'/faf.sh-'$faf_sh_version'.log;
cd '$user_path';
source .bashrc;
eval "$(cat .bashrc | tail -n +10)";
echo "Finished thread two (install & run steam, steamcmd, FA) without issue, starting (FAF)...";
echo "[$(date --rfc-3339=seconds)] T2 Finished thread two (install & run steam, steamcmd, FA) without issue, starting (FAF)..." >> '$user_path'/faf.sh-'$faf_sh_version'.log;'
gnomeTerminalFirstConsoleVar='gnome-terminal --tab --active --title="install & run steam, steamcmd, FA" -- bash -c '"'"''
konsoleFirstConsoleVar='konsole -e /bin/bash --rcfile <(echo '"'"''
xtermFirstConsoleVar='xterm -T "install & run steam, steamcmd, FA" -e '"'"''
gnomeTerminalSecondConsoleVar='gnome-terminal --tab --title="(FAF)" -- bash -c "cd ~/faf; ./downlords-faf-client";'"'"''
konsoleSecondConsoleVar='konsole -e /bin/bash --rcfile <(echo "cd ~/faf; ./downlords-faf-client; exit 0") &'"'"') &'
xtermSecondConsoleVar='	xterm -T "(FAF)" -e "cd ~/faf; ./downlords-faf-client";'"'"' &'
# this "eval" solution doesn't seem like it will be robust enough to work on any os. suggestions welcome
if [ "$operating_system" = "Kubuntu" ]
then
	eval "$konsoleFirstConsoleVar $middlescript $konsoleSecondConsoleVar"
elif [ "$operating_system" = "elementary OS" ]
then
	eval "$xtermFirstConsoleVar $middlescript $xtermSecondConsoleVar"
else
	eval "$gnomeTerminalFirstConsoleVar $middlescript $gnomeTerminalSecondConsoleVar"
fi
# source $user_path/.bashrc be it in main thread or in tab, has no effect the user will have to run it himself.
# end of second thread
# finalising apt-install
echo "[$(date --rfc-3339=seconds)] T1 start of second thread did not crash first thread" >> $user_path/faf.sh-$faf_sh_version.log
if ! dpkg-query -W -f='${Status}' lib32gcc1 | grep "ok installed"
then
	echo "[$(date --rfc-3339=seconds)] T1 lib32gcc1 was not yet installed, installing..." >> $user_path/faf.sh-$faf_sh_version.log
	if [ "$operating_system" = "Debian GNU/Linux" ]
	then
		apt install -y lib32gcc1
	else
		sudo apt install -y lib32gcc1
	fi
else
	echo "[$(date --rfc-3339=seconds)] T1 lib32gcc1 is already installed, proceeding..." >> $user_path/faf.sh-$faf_sh_version.log
	echo "lib32gcc1 is already installed, proceeding..."
fi
if [ $(command -v steamcmd) ]
then
	echo "[$(date --rfc-3339=seconds)] T1 steam CMD is already installed, proceeding..." >> $user_path/faf.sh-$faf_sh_version.log
	echo "steam CMD is already installed, proceeding..."
else
	echo "[$(date --rfc-3339=seconds)] T1 steam CMD was not yet installed, installing..." >> $user_path/faf.sh-$faf_sh_version.log
	if [ "$operating_system" != "Zorin OS" ]
	then
		if [ "$operating_system" = "Debian GNU/Linux" ]
		then
			echo steamcmd steam/question select "I AGREE" | debconf-set-selections
			echo steamcmd steam/license note '' | debconf-set-selections
		else
			echo steamcmd steam/question select "I AGREE" | sudo debconf-set-selections
			echo steamcmd steam/license note '' | sudo debconf-set-selections
		fi
	fi
	useradd -m steam
	cd /home/steam
	if [ "$operating_system" = "Debian GNU/Linux" ]
	then
		apt install -y steamcmd
	else
		sudo apt install -y steamcmd
	fi
	cd $user_path
fi
if ! dpkg-query -W -f='${Status}' libnss3-tools | grep "ok installed"
then
	echo "[$(date --rfc-3339=seconds)] T1 libnss3 was not yet installed, installing..." >> $user_path/faf.sh-$faf_sh_version.log
	if [ "$operating_system" = "Debian GNU/Linux" ]
	then
		apt install -y libnss3-tools
	else
		sudo apt install -y libnss3-tools
	fi
else
	echo "[$(date --rfc-3339=seconds)] T1 libnss3 is already installed, proceeding..." >> $user_path/faf.sh-$faf_sh_version.log
	echo "libnss3 is already installed, proceeding..."
fi
if [ "$operating_system" = "Debian GNU/Linux" ]
then
	[ $gallium_nine ] && apt install -y libd3dadapter9-mesa:i386 libd3dadapter9-mesa
	apt autoremove -y
	apt autoclean
else
	[ $gallium_nine ] && sudo apt install -y libd3dadapter9-mesa:i386 libd3dadapter9-mesa
	sudo apt autoremove -y
	sudo apt autoclean
fi
# no more apt-install
# Java install block
echo "Now probing the Java status of this OS..."
echo "[$(date --rfc-3339=seconds)] T1 Now probing the Java status of this OS..." >> $user_path/faf.sh-$faf_sh_version.log
if [ -d /usr/lib/jvm/jdk-10.0.2 ]
then
	echo "Java is already installed, moving on"
	echo "[$(date --rfc-3339=seconds)] T1 Java already installed!" >> $user_path/faf.sh-$faf_sh_version.log
else
	# Download & install java 10 open jdk
	echo "Java 10 installation procedure..."
	echo "[$(date --rfc-3339=seconds)] T1 Java 10 installing..." >> $user_path/faf.sh-$faf_sh_version.log
	wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
	if [ "$operating_system" = "Debian GNU/Linux" ]
	then
		mkdir -p /usr/lib/jvm
		cd /usr/lib/jvm
		pv $user_path/openjdk-10.0.2_linux-x64_bin.tar.gz | tar xzp -C /usr/lib/jvm
		cd $user_path
		rm openjdk-10.0.2_linux-x64_bin.tar.gz
		update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-10.0.2/bin/java" 0
		update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-10.0.2/bin/javac" 0
		update-alternatives --set java /usr/lib/jvm/jdk-10.0.2/bin/java
		update-alternatives --set javac /usr/lib/jvm/jdk-10.0.2/bin/javac
	else
		sudo mkdir -p /usr/lib/jvm
		cd /usr/lib/jvm
		sudo pv ~/openjdk-10.0.2_linux-x64_bin.tar.gz | sudo tar xzp -C /usr/lib/jvm
		cd
		rm openjdk-10.0.2_linux-x64_bin.tar.gz
		sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-10.0.2/bin/java" 0
		sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-10.0.2/bin/javac" 0
		sudo update-alternatives --set java /usr/lib/jvm/jdk-10.0.2/bin/java
		sudo update-alternatives --set javac /usr/lib/jvm/jdk-10.0.2/bin/javac
	fi
	echo "" >> $user_path/.bashrc
	echo "" >> $user_path/.bashrc
	! grep -q 'INSTALL4J_JAVA_HOME' $user_path/.bashrc > /dev/null && echo "export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2" >> $user_path/.bashrc
	# /end Download & install java 10 open jdk
fi
# /end Java install block
# make faf .desktop runner
[ ! -d $user_path/.local/share/icons ] && mkdir -p .local/share/icons
if [ ! -f $user_path/.local/share/icons/faf.png ]
then
	echo "[$(date --rfc-3339=seconds)] T1 getting desktop launcher icon" >> $user_path/faf.sh-$faf_sh_version.log
	cd $user_path/.local/share/icons
	wget https://github.com/tatsujb/FAFICON/raw/master/faf.png
fi
if [ ! -f $user_path/.local/share/applications/faforever.desktop ]
then
	echo "[$(date --rfc-3339=seconds)] T1 making desktop launcher" >> $user_path/faf.sh-$faf_sh_version.log
	cd $user_path/.local/share/applications
	echo '#!/usr/bin/env xdg-open' >> faforever.desktop
	echo "[Desktop Entry]" >> faforever.desktop
	echo "Version=$faf_version" >> faforever.desktop
	echo "Type=Application" >> faforever.desktop
	echo 'Exec=bash -c "cd '$user_path'/faf;export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2; ./downlords-faf-client"' >> faforever.desktop
	echo "Name=FAF" >> faforever.desktop
	echo "Comment=Forged Alliance Forever Client" >> faforever.desktop
	echo "Icon=$user_path/.local/share/icons/faf.png" >> faforever.desktop
	chmod +x faforever.desktop
fi
cd $user_path
# /end make faf .desktop runner
# Download & install FAF client
echo "now moving on to installing Downlord's FAF..."
if [ -d $user_path/faf ]
then
	rm -rf faf
else
	echo "[$(date --rfc-3339=seconds)] T1 installing DOWNLORD" >> $user_path/faf.sh-$faf_sh_version.log
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
	chmod +x downlords-faf-client
	chmod +x lib/faf-uid
fi
cd $user_path
# /end Download & install FAF client
# wait for user to log in
echo "please switch to opened FAF client. Waiting on user to log in"
echo ""
no_login=true
i=1
sp="/-\|"
echo -n "waiting...  "
while $no_login
do
  printf "\b${sp:i++%${#sp}:1}"
  grep --no-messages '"username": "' $user_path/.faforever/client.prefs && no_login=false
  sleep 1
done
echo "done looping!"
sleep 2
kill -9 $(pgrep java | tail -1)
# editting client.prefs :
if [ -d '$user_path'/.steam/steam/SteamApps ]
then
	steamapps="SteamApps"
else
	steamapps="steamapps"
fi
jq --arg user_path "$user_path" --arg steamapps "$steamapps" '
    .forgedAlliance += {
        installationPath: ($user_path + "/.steam/steam/" + $steamapps + "/common/Supreme Commander Forged Alliance"),
        path: ($user_path + "/.steam/steam/" + $steamapps + "/common/Supreme Commander Forged Alliance"),
        preferencesFile: ($user_path + "/.steam/steam/" + $steamapps + "/compatdata/9420/pfx/drive_c/users/steamuser/Local Settings/Application Data/Gas Powered Games/Supreme Commander Forged Alliance/Game.prefs"),
        executableDecorator: ($user_path + "/faf/run \"%s\"")
    }' $user_path/.faforever/client.prefs > $user_path/.faforever/client.prefs.tmp
mv $user_path/.faforever/client.prefs.tmp $user_path/.faforever/client.prefs
echo "done editting!"
gtk-launch faforever
echo "Finished thread one (proton/downlord/open-jdk/bashrc) without issue..."
echo "[$(date --rfc-3339=seconds)] T1 Finished thread one. (proton/downlord/open-jdk/bashrc)" >> $user_path/faf.sh-$faf_sh_version.log
