#!/bin/bash

echo "steam user name :"
read STEAMUSERNAME
echo "steam password :"
read -s STEAMPASSWORD
sudo echo "now sudo"
if [[ $(command -v java) ]] || [[ $(type -p java) ]] || [[ -n "$JAVA_HOME" ]] || [[ -x "$JAVA_HOME/bin/java" ]]
then
	echo "UH-OH, Java is already installed!"
	echo "This is suboptimal, crossing fingers for correct version Java version (E.G. version number 10)..."

	if [ $(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -f1 -d'.') -eq "10" ]
	then
		echo "Huzzah! you have the correct version of Java, here's hoping for the best!"
		echo "Checking, if .bashrc config is also correct..."

		if grep -q "export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2" ~/.bashrc
		then
			echo "Huzzah! Java looks all set, let's move on..."

        else
            echo "Hmmm... we're not looking to hot on .bashrc, let's see if we can fix that..."

            if (whiptail --title "Entered : \"Java 10 present but .bashrc not correctly configured use-case\"" --yesno "Attempt .bashrc automated correct? \n\"No\" will close this script \n\"Yes\" will automatically edit bashrc \n(keep in mind this script was written by a donkey...)" 10 100)
			then
				echo export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2 >> ~/.bashrc
				source ~/.bashrc
				echo "OK! \".bashrc\" edited!"
				echo "assuming Java is all set, let's move on..."

			else
				echo "You're probably right to choose this..."
				echo "please edit .bashrc yourself or remove java 10 and start over."
				echo "exiting upon demand..."
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
        exit 1

	fi

else
	echo "installing java 10..."
    

    wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
    sudo mkdir /usr/lib/jvm
    cd /usr/lib/jvm
    sudo tar -xvzf ~/openjdk-10.0.2_linux-x64_bin.tar.gz
    cd
    rm openjdk-10.0.2_linux-x64_bin.tar.gz
    sudo update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk-10.0.2/bin/java" 0
    sudo update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk-10.0.2/bin/javac" 0
    sudo update-alternatives --set java /usr/lib/jvm/jdk-10.0.2/bin/java
    sudo update-alternatives --set javac /usr/lib/jvm/jdk-10.0.2/bin/javac
    echo export INSTALL4J_JAVA_HOME=/usr/lib/jvm/jdk-10.0.2 >> ~/.bashrc
    source ~/.bashrc

fi

echo "now moving on to installing Downlord's FAF..."

ENVIRONMENT=$( cat /etc/environment )
if [ 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"' == "$ENVIRONMENT" ]
then
    echo "environment is vanilla..."
    echo "proceeding..."
    sudo rm /etc/environment
    sudo cat >/etc/environment <<EOF
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/jdk-10.0.2/bin:/home/$USER/.steam/steam/steamapps/common/Proton/dist/bin/:/home/$USER/.steam/ubuntu12_32/steam-runtime/amd64/bin:/home/$USER/.steam/ubuntu12_32/steam-runtime/amd64/usr/bin"
JAVA_HOME="/usr/lib/jvm/jdk-10.0.2"
EOF
    source /etc/environment
else
    if (whiptail --title "Entered : \"Java 10 present but evironement is non-vanilla use-case\"" --yesno "Overwrite /etc/environment? \n\user config that you may have set yourself was discovered in environment. is this keep-worthy? \n\"No\" will skip this \n\"Yes\" will delete and replace /etc/environment \n(keep in mind this script was written by a donkey...)" 11 100)
    then
        sudo rm /etc/environment
        sudo cat >/etc/environment <<EOF
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/jdk-10.0.2/bin:/home/$USER/.steam/steam/steamapps/common/Proton/dist/bin/:/home/$USER/.steam/ubuntu12_32/steam-runtime/amd64/bin:/home/$USER/.steam/ubuntu12_32/steam-runtime/amd64/usr/bin"
JAVA_HOME="/usr/lib/jvm/jdk-10.0.2"
EOF
        source /etc/environment
        echo "OK! \".bashrc\" edited!"
        echo "assuming Java is all set, let's move on..."

    else
        echo "You're probably right to choose this..."
        echo "you'll have to check /etc/environement 's variables yourself at the end of this script."
	fi
fi
cd
mkdir faf
cd faf
FAFVERSIONNUMBER=$(curl -v --silent https://api.github.com/repos/FAForever/downlords-faf-client/releases 2>&1 | grep '"tag_name": ' | head -n 1 | cut -f4,4 -d'"')
TEMP=${VERSIONNUMBER:1}
FAFVERSIONNUMBERNAME=${TEMP//./_}
wget https://github.com/FAForever/downlords-faf-client/releases/download/$FAFVERSIONNUMBER/_dfc_unix_$FAFVERSIONNUMBERNAME.tar.gz
tar -xpvzf _dfc_unix_0_9_3-beta.tar.gz
mv downlords-faf-client-0.9.3-beta/{.,}* .
rmdir downlords-faf-client-0.9.3-beta
rm _dfc_unix_0_9_3-beta.tar.gz
chmod +x downlords-faf-client && chmod +x lib/faf-uid
cd
echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1 PROTON_USE_GALLIUM_NINE=1 PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1"%command%' >> ~/"the contents of this file are to be pasted in the forged alliance properties launch options"
echo 'export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libnss3.so' >> ~/.bashrc
echo 'export DEF_CMD=("/home/'$USER'/.steam/steam/steamapps/common/Supreme Commander Forged Alliance/bin/SupremeCommander.exe")' >> ~/.bashrc
echo 'export TERM=xterm' >> ~/.bashrc
echo 'export WINEDEBUG=-all' >> ~/.bashrc
echo 'export WINEDLLPATH=/home/'$USER'/.steam/steam/steamapps/common/Proton/dist/lib64/wine:/home/'$USER'/.steam/steam/steamapps/common/Proton/dist/lib/wine' >> ~/.bashrc
echo 'export WINEPREFIX=/home/'$USER'/.steam/steam/steamapps/compatdata/9420/pfx/' >> ~/.bashrc
echo 'export SteamGameId=9420' >> ~/.bashrc
echo 'export SteamAppId=9420' >> ~/.bashrc
echo 'export WINEDLLOVERRIDES="d3d11=n;d3d10=n;d3d10core=n;d3d10_1=n;dxgi=n"' >> ~/.bashrc

echo "installing steam and steam CMD..."
if [ $(command -v steam) ]
then
    echo "steam is already installed, proceeding..."
else
    echo steam steam/question select "I AGREE" | sudo debconf-set-selections
    echo steam steam/license note '' | sudo debconf-set-selections
    sudo apt install -y steam
fi
mkdir -p ~/.steam/compatibilitytools.d
https://api.github.com/repos/popsUlfr/Proton/releases
PROTONVERSIONNUMBER=$(curl -v --silent https://api.github.com/repos/popsUlfr/Proton/releases 2>&1 | grep '"tag_name": ' | head -n 1 | cut -f4,4 -d'"')
REPLACING=$(curl -v --silent https://api.github.com/repos/popsUlfr/Proton/releases 2>&1 | grep '"target_commitish": ' | head -n 1 | cut -f4,4 -d'"' | sed 's/[^_]\+/\L\u&/g')
PROTONVERSION=${REPLACING/_G/-6_G}
PROTONNAME=$PROTONVERSION"_"${PROTONVERSIONNUMBER##*-}
wget https://github.com/popsUlfr/Proton/releases/download/$PROTONVERSIONNUMBER/$PROTONNAME.tar.xz

tar xfv Proton_3.16-6_Gallium_Nine_Extras_0.3.0.tar.xz -C ~/.steam/compatibilitytools.d
rm Proton_3.16-6_Gallium_Nine_Extras_0.3.0.tar.xz
sudo apt-get install libd3dadapter9-mesa:i386 libd3dadapter9-mesa

gnome-terminal -e "steam -nofriendsui -login ${STEAMUSERNAME} ${STEAMPASSWORD} -remember_password"
sleep 6m
if [ $(command -v steamcmd) ]
then
    echo "steam CMD is already installed, proceeding..."
else
    echo steamcmd steam/question select "I AGREE" | sudo debconf-set-selections
    echo steamcmd steam/license note '' | sudo debconf-set-selections
    sudo useradd -m steam
    cd /home/steam
    sudo apt install -y steamcmd
	cd
fi
if [ $(command -v lib32gcc1) ]
then
    echo "lib32gcc1 is already installed, proceeding..."
else
    cd
    sudo apt install -y lib32gcc1
fi
cd


#########################################################################################################################
#                                                                                                                       #
# WIP! have not figured out a way to enable proton for all games via command line, right now you have to do it manually #
#                                                                                                                       #
#########################################################################################################################

steamcmd +login ${STEAMUSERNAME} ${STEAMPASSWORD} +app_update 9420 validate +quit
steam -applaunch 9420
