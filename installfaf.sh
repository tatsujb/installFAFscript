#!/bin/bash
# version 1.3
STACKVERSION=1.3
echo 'new log file, fafSTACK version '$STACKVERSION >> ~/'fafstack-'$STACKVERSION'.log'
echo "steam user name :"
read STEAMUSERNAME
echo "steam password :"
read -s STEAMPASSWORD
if grep -Fxq "# deb http://archive.canonical.com/ubuntu cosmic partner" /etc/apt/sources.list
then
    echo "enabled partners" >> ~/'fafstack-'$STACKVERSION'.log'
    sudo sed -i 's/# deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/g' /etc/apt/sources.list
else
    echo "did not enable partners, hoping it was already enabled." >> ~/'fafstack-'$STACKVERSION'.log'
fi
sudo apt update -y &&
echo "[$(date --rfc-3339=seconds)] now sudo" >> ~/'fafstack-'$STACKVERSION'.log'
sudo apt -y dist-upgrade &&


if [ $(command -v lib32gcc1) ]
then
    echo "[$(date --rfc-3339=seconds)] lib32gcc1 is already installed, proceeding..." >> ~/'fafstack-'$STACKVERSION'.log'
    echo "lib32gcc1 is already installed, proceeding..."
else
    cd
    echo "[$(date --rfc-3339=seconds)] lib32gcc1 was not yet installed, installing..." >> ~/'fafstack-'$STACKVERSION'.log'
    sudo apt install -y lib32gcc1
fi

if [ $(command -v steamcmd) ]
then
    echo "[$(date --rfc-3339=seconds)] steam CMD is already installed, proceeding..." >> ~/'fafstack-'$STACKVERSION'.log'
    echo "steam CMD is already installed, proceeding..."
else
    echo "[$(date --rfc-3339=seconds)] steam CMD was not yet installed, installing..." >> ~/'fafstack-'$STACKVERSION'.log'
    echo steamcmd steam/question select "I AGREE" | sudo debconf-set-selections
    echo steamcmd steam/license note '' | sudo debconf-set-selections
    sudo useradd -m steam
    cd /home/steam
    sudo apt install -y steamcmd
	cd
fi


echo "[$(date --rfc-3339=seconds)] installing dependencies" >> ~/'fafstack-'$STACKVERSION'.log'

echo "starting Forged Alliance Download..."
echo "[$(date --rfc-3339=seconds)] starting Forged Alliance Download..." >> ~/'fafstack-'$STACKVERSION'.log'


gnome-terminal --tab -- bash -c 'steamcmd +login '$STEAMUSERNAME' '$STEAMPASSWORD' +@sSteamCmdForcePlatformType windows +app_update 9420 validate +quit'

sudo apt install -y libd3dadapter9-mesa:i386 libd3dadapter9-mesa &&

if [ $(command -v curl) ]
then
    echo "[$(date --rfc-3339=seconds)] curl is already installed, proceeding..." >> ~/'fafstack-'$STACKVERSION'.log'
    echo "curl is already installed, proceeding..."
else
    cd
    echo "[$(date --rfc-3339=seconds)] curl was not yet installed, installing..." >> ~/'fafstack-'$STACKVERSION'.log'
    sudo apt install -y curl
fi


sudo apt autoremove -y &&
sudo apt autoclean &&
echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1, PROTON_USE_GALLIUM_NINE=1, PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1" %command%' >> ~/"the contents of this file are to be pasted in the forged alliance properties launch options"

echo "installing steam and steam CMD..."
echo "[$(date --rfc-3339=seconds)] installing steam and steam CMD..." >> ~/'fafstack-'$STACKVERSION'.log'
if [ $(command -v steam) ]
then
    echo "steam is already installed, proceeding..."
    echo "[$(date --rfc-3339=seconds)] steam is already installed, proceeding..." >> ~/'fafstack-'$STACKVERSION'.log'
else
    echo "[$(date --rfc-3339=seconds)] steam was not yet installed, installing..." >> ~/'fafstack-'$STACKVERSION'.log'
    echo steam steam/question select "I AGREE" | sudo debconf-set-selections
    echo steam steam/license note '' | sudo debconf-set-selections
    sudo apt install -y steam
fi
mkdir -p ~/.steam/compatibilitytools.d
PROTONVERSIONNUMBER=$(curl -v --silent https://api.github.com/repos/popsUlfr/Proton/releases 2>&1 | grep '"tag_name": ' | head -n 1 | cut -f4,4 -d'"')
REPLACING=$(curl -v --silent https://api.github.com/repos/popsUlfr/Proton/releases 2>&1 | grep '"target_commitish": ' | head -n 1 | cut -f4,4 -d'"' | sed 's/[^_]\+/\L\u&/g')
PROTONVERSION=${REPLACING/_G/-6_G}
PROTONNAME=$PROTONVERSION"_"${PROTONVERSIONNUMBER##*-}
wget https://github.com/popsUlfr/Proton/releases/download/$PROTONVERSIONNUMBER/$PROTONNAME.tar.xz
tar xf $PROTONNAME.tar.xz -C ~/.steam/compatibilitytools.d
rm $PROTONNAME.tar.xz


#########################################################################################################################
#                                                                                                                       #
# WIP! have not figured out a way to enable proton for all games via command line, right now you have to do it manually #
#                                                                                                                       #
#########################################################################################################################

#BE SURE TO EDIT THIS VALUE ("180") ACCORDING TO YOUR INTERNET SPEED
gnome-terminal --tab -- bash -c 'timeout -k 5 180 steam -nofriendsui -login '$STEAMUSERNAME' '$STEAMPASSWORD' -remember_password'



cd
if [[ $(command -v java) ]] || [[ $(type -p java) ]] || [[ -n "$JAVA_HOME" ]] || [[ -x "$JAVA_HOME/bin/java" ]]
then
	echo "UH-OH, Java is already installed!"
	echo "This is suboptimal, crossing fingers for correct version Java version (E.G. version number 10)..."
    	echo "[$(date --rfc-3339=seconds)] JAVA already installed!" >> ~/'fafstack-'$STACKVERSION'.log'
	if [ $(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -f1 -d'.') -eq "10" ]
	then
		echo "Huzzah! you have the correct version of Java, here's hoping for the best!"
		echo "Checking, if .bashrc config is also correct..."
		echo "[$(date --rfc-3339=seconds)] specifically JAVA 10." >> ~/'fafstack-'$STACKVERSION'.log'
		if grep -q "export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2" ~/.bashrc
		then
			echo "Huzzah! Java looks all set, let's move on..."
			echo "[$(date --rfc-3339=seconds)] satisfied with JAVA config." >> ~/'fafstack-'$STACKVERSION'.log'
        else
            echo "Hmmm... we're not looking to hot on .bashrc, let's see if we can fix that..."
	echo "[$(date --rfc-3339=seconds)] but not correct config." >> ~/'fafstack-'$STACKVERSION'.log'
            if (whiptail --title "Entered : \"Java 10 present but .bashrc not correctly configured use-case\"" --yesno "Attempt .bashrc automated correct? \n\"No\" will close this script \n\"Yes\" will automatically edit bashrc \n(keep in mind this script was written by a donkey...)" 10 100)
			then
				echo export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2 >> ~/.bashrc
				echo "OK! \".bashrc\" edited!"
				echo "assuming Java is all set, let's move on..."
				echo "[$(date --rfc-3339=seconds)] corrected JAVA config." >> ~/'fafstack-'$STACKVERSION'.log'
			else
				echo "You're probably right to choose this..."
				echo "please edit .bashrc yourself or remove java 10 and start over."
				echo "exiting upon demand..."
				echo "[$(date --rfc-3339=seconds)] Abandoned on user demand, JAVA was ill-configured" >> ~/'fafstack-'$STACKVERSION'.log'
				exit 1
			fi
            
        fi
        else
        echo "You have a version of java that is not Java 10"
        echo "This is problematic as this case is not yet handled by this script (though it could easily be!)"
        echo "Feel free to contribute at : https://github.com/tatsujb/installFAFscript"
        echo "The easliest sollution for you to use this script as-is, is for you to purge all java versions from your system (be sure to remove references in /etc/environment),"
        echo "then, re-run this script"
        echo "FAF-stack not installed, exiting..."
	echo "[$(date --rfc-3339=seconds)] Incorrect JAVA version, exiting!" >> ~/'fafstack-'$STACKVERSION'.log'
        exit 1
	fi
else
	echo "installing java 10..."
	echo "[$(date --rfc-3339=seconds)] JAVA 10 installing..." >> ~/'fafstack-'$STACKVERSION'.log'
    
    wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
    sudo mkdir /usr/lib/jvm
    cd /usr/lib/jvm
    sudo tar xzf ~/openjdk-10.0.2_linux-x64_bin.tar.gz
    cd
    rm openjdk-10.0.2_linux-x64_bin.tar.gz
    sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-10.0.2/bin/java" 0
    sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-10.0.2/bin/javac" 0
    sudo update-alternatives --set java /usr/lib/jvm/jdk-10.0.2/bin/java
    sudo update-alternatives --set javac /usr/lib/jvm/jdk-10.0.2/bin/javac
    echo export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2 >> ~/.bashrc
fi
echo "now moving on to installing Downlord's FAF..."
echo "[$(date --rfc-3339=seconds)] installing DOWNLORD" >> ~/'fafstack-'$STACKVERSION'.log'
ENVIRONMENT=$( cat /etc/environment )
RESOLVEDPATH=$('PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/jdk-10.0.2/bin:/home/'$USER'/.steam/compatibilitytools.d/Proton/dist/bin:/home/'$USER'/.steam/ubuntu12_32/steam-runtime/amd64/usr/bin"')
RESOLVEDJAVA='JAVA_HOME="/usr/lib/jvm/jdk-10.0.2"'
if [ ! -f /etc/environment ] || [ 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"' == "$ENVIRONMENT" ]
then
    echo "environment is vanilla..."
    echo "proceeding..."
    echo "[$(date --rfc-3339=seconds)] optimal use-case" >> ~/'fafstack-'$STACKVERSION'.log'
    [ ! -f /etc/environment ] && sudo touch /etc/environment || echo ""
    sudo bash -c 'echo '$RESOLVEDPATH' >> /etc/environment'
    sudo bash -c 'echo '$RESOLVEDJAVA' >> /etc/environment'
    source /etc/environment
else
    if (whiptail --title "Entered : \"Java 10 present but evironement is non-vanilla use-case\"" --yesno "Overwrite /etc/environment? \n\user config that you may have set yourself was discovered in environment. is this keep-worthy? \n\"No\" will skip this \n\"Yes\" will delete and replace /etc/environment \n(keep in mind this script was written by a donkey...)" 11 100)
    then
    echo "[$(date --rfc-3339=seconds)] sub-optimal use-case, corrected /etc/environment" >> ~/'fafstack-'$STACKVERSION'.log'
    [ ! -f /etc/environment ] && sudo touch /etc/environment || echo ""
    sudo bash -c 'echo '$RESOLVEDPATH' >> /etc/environment'
    sudo bash -c 'echo '$RESOLVEDJAVA' >> /etc/environment'
    source /etc/environment
        echo "OK! \".bashrc\" edited!"
        echo "assuming Java is all set, let's move on..."
    else
        echo "You're probably right to choose this..."
        echo "you'll have to check /etc/environment 's variables yourself at the end of this script."
    echo "[$(date --rfc-3339=seconds)] user chose to leave /etc/environment untouched, this might be the cause." >> ~/'fafstack-'$STACKVERSION'.log'
	fi
fi
cd
mkdir faf
cd faf
FAFVERSIONNUMBER=$(curl -v --silent https://api.github.com/repos/FAForever/downlords-faf-client/releases 2>&1 | grep '"tag_name": ' | head -n 1 | cut -f4,4 -d'"')
FAFVERSION=$( echo ${FAFVERSIONNUMBER:1} | tr '.' '_' )
wget https://github.com/FAForever/downlords-faf-client/releases/download/$FAFVERSIONNUMBER/_dfc_unix_$FAFVERSION.tar.gz
tar xpzf _dfc_unix_$FAFVERSION.tar.gz
sleep 8
mv downlords-faf-client-${FAFVERSIONNUMBER:1}/{.,}* .
rmdir downlords-faf-client-${FAFVERSIONNUMBER:1}
rm _dfc_unix_$FAFVERSION.tar.gz
sleep 1
chmod +x downlords-faf-client && chmod +x lib/faf-uid
cd
echo 'export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnss3.so' >> ~/.bashrc
echo 'export DEF_CMD=("/home/'$USER'/.steam/steam/steamapps/common/Supreme Commander Forged Alliance/bin/SupremeCommander.exe")' >> ~/.bashrc
echo 'export TERM=xterm' >> ~/.bashrc
echo 'export WINEDEBUG=-all' >> ~/.bashrc
echo 'export WINEDLLPATH=/home/'$USER'/.steam/compatibilitytools.d/Proton/dist/lib64/wine:/home/'$USER'/.steam/compatibilitytools.d/Proton/dist/lib/wine' >> ~/.bashrc
echo 'export WINEPREFIX=/home/'$USER'/.steam/steam/steamapps/compatdata/9420/pfx/' >> ~/.bashrc
echo 'export SteamGameId=9420' >> ~/.bashrc
echo 'export SteamAppId=9420' >> ~/.bashrc

source .bashrc

echo "starting Forged Alliance..."
echo "[$(date --rfc-3339=seconds)] starting Forged Alliance..." >> ~/'fafstack-'$STACKVERSION'.log'
steam -login $STEAMUSERNAME $STEAMPASSWORD -nofriendsui -applaunch 9420 -shutdown

STEAMUSERNAME=''
STEAMPASSWORD=''
cd
mv /$USER/tatsu/.steam/compatibilitytools.d/$PROTONNAME /home/$USER/.steam/compatibilitytools.d/Proton
echo "making map & mods symbolic links"
echo "[$(date --rfc-3339=seconds)] Maps & Mods" >> ~/'fafstack-'$STACKVERSION'.log'
cd /home/$USER/.steam/steam/SteamApps/common/Supreme\ Commander\ Forged\ Alliance
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods
cd /home/$USER/.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser
rm -rf My\ Documents
mkdir My\ Documents
cd My\ Documents
ln -s ~/My\ Games/ My\ Games
cd
echo "launching FAF"
echo "[$(date --rfc-3339=seconds)] FAF installed, launching FAF..." >> ~/'fafstack-'$STACKVERSION'.log'
source .bashrc
gnome-terminal --tab -- bash -c "cd ~/faf; timeout -k 5 100 ./downlords-faf-client"
echo "[$(date --rfc-3339=seconds)] made it to the end." >> ~/'fafstack-'$STACKVERSION'.log'
echo "well done! we made it all the way! you'll need to set the executable permissions on all of the contents of .faforever after hosting a game yourself."


