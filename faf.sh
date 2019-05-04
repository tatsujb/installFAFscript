#!/bin/bash
  faf_sh_version=2.4
 
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

cd
real_user=$(pwd | cut -c 7-)
 
echo "_______________________________________________________________________________________________________" >> ~/faf.sh-$faf_sh_version.log
echo "-------------------------------------------------------------------------------------------------------" >> ~/faf.sh-$faf_sh_version.log
# DETERMINE OS BASE :
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_sh_version" running : "$unameOut  >> ~/faf.sh-$faf_sh_version.log;;
    Darwin*)
echo "Mac / Apple Macintosh is not supported yet though it could technically be; as evidenced by previous examples of people running FA and even FAF on mac. Feel free to contribute at : https://github.com/tatsujb/installFAFscript"
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_sh_version". FAILIURE. MAC UNSUPPORTED. "$unameOut  >> ~/faf.sh-$faf_sh_version.log
exit 1;;
    CYGWIN*)
echo "Hello, you can go straight to : www.faforever.com and click on \"Download Client\". This script exists in order to help linux users achieve the same thing you can do out-of-the-box on your operating system. You have not the remotest use for this script :) be free, wild bird!"
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_sh_version". FAILIURE. WINDOWS UNSUPPORTED. "$unameOut  >> ~/faf.sh-$faf_sh_version.log
exit 1;;
    MINGW*)
echo "Hello, are can on MinGW you cannot run Forged Alliance, this script is of no use to you."
echo "[$(date --rfc-3339=seconds)] T1 New log file. fafSTACK version "$faf_sh_version". FAILIURE. MINGW UNSUPPORTED. "$unameOut  >> ~/faf.sh-$faf_sh_version.log
exit 1
esac
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
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org (older Debian / Ubuntu should be here)
    operating_system=$(lsb_release -si)
    os_version=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    operating_system=$DISTRIB_ID
    os_version=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    operating_system=oldDebian
    os_version=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    operating_system=OpenSuSE
    os_version="unknown version but likely very old"
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    operating_system=oldRedHatorCentos
    os_version="unknown version but likely very old"
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    operating_system=$(uname -s)
    os_version=$(uname -r)
fi

echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> ~/faf.sh-$faf_sh_version.log
echo "-------------------------------------------------------------------------------------------------------" >> ~/faf.sh-$faf_sh_version.log
echo "Hard storage setup :" >> ~/faf.sh-$faf_sh_version.log
echo "_______________________________________________________________________________________________________" >> ~/faf.sh-$faf_sh_version.log
lsblk_ouput=$(lsblk | grep -v 'loop')
echo "$lsblk_ouput" >> ~/faf.sh-$faf_sh_version.log
dfh_ouput=$(df -h --total | grep -v 'loop')
echo "$dfh_ouput" >> ~/faf.sh-$faf_sh_version.log
echo "_______________________________________________________________________________________________________" >> ~/faf.sh-$faf_sh_version.log
echo "" >> ~/faf.sh-$faf_sh_version.log
# real start of script
to_be_installed=""
if [ -f /bin/kill ]
then
    echo "[$(date --rfc-3339=seconds)] T1 procps is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 procps was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed procps"

fi
if [ $(command -v xterm) ]
then
    echo "[$(date --rfc-3339=seconds)] T1 xterm is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 xterm was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed xterm"
fi
if [ $(command -v whiptail) ]
then
    echo "[$(date --rfc-3339=seconds)] T1 whiptail is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 whiptail was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed whiptail"
fi
if ! dpkg-query -W -f='${Status}' zenity | grep "ok installed"
then
    echo "[$(date --rfc-3339=seconds)] T1 zenity was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed zenity"
else
    echo "[$(date --rfc-3339=seconds)] T1 zenity is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
fi
if [ $(command -v whiptail) ]
then
    echo "[$(date --rfc-3339=seconds)] T1 whiptail is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 whiptail was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed whiptail"
fi
if [ $(command -v pv) ]
then
    echo "[$(date --rfc-3339=seconds)] T1 pv is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 pv was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed pv"
fi
if ! dpkg-query -W -f='${Status}' python3-pip | grep "ok installed"
then
    echo "[$(date --rfc-3339=seconds)] T1 python3-pip was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed python3-pip"
else
    echo "[$(date --rfc-3339=seconds)] T1 python3-pip is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
fi
if ! dpkg-query -W -f='${Status}' python3-setuptools | grep "ok installed"
then
    echo "[$(date --rfc-3339=seconds)] T1 python3-setuptools was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed python3-setuptools"
else
    echo "[$(date --rfc-3339=seconds)] T1 python3-setuptools is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
fi
if ! dpkg-query -W -f='${Status}' python3-venv | grep "ok installed"
then
    echo "[$(date --rfc-3339=seconds)] T1 python3-venv was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed python3-venv"
else
    echo "[$(date --rfc-3339=seconds)] T1 python3-venv is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
fi
if [ $(command -v curl) ]
then
    echo "[$(date --rfc-3339=seconds)] T1 curl is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 curl was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed curl"
fi
if ! dpkg-query -W -f='${Status}' lib32gcc1 | grep "ok installed"
then
    echo "[$(date --rfc-3339=seconds)] T1 lib32gcc1 was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed lib32gcc1"
else
    echo "[$(date --rfc-3339=seconds)] T1 lib32gcc1 is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
fi
if ! dpkg-query -W -f='${Status}' libnss3-tools | grep "ok installed"
then
    echo "[$(date --rfc-3339=seconds)] T1 libnss3 was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed libnss3-tools"
else
    echo "[$(date --rfc-3339=seconds)] T1 libnss3 is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
fi
if [ "$operating_system" != "Debian GNU/Linux" ]
then
if ! dpkg-query -W -f='${Status}' libd3dadapter9-mesa | grep "ok installed"
then
    echo "[$(date --rfc-3339=seconds)] T1 libd3dadapter9-mesa was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed libd3dadapter9-mesa libd3dadapter9-mesa:i386"
else
    echo "[$(date --rfc-3339=seconds)] T1 libd3dadapter9-mesa is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
fi
fi
if [ $(command -v jq) ]
then
    echo "[$(date --rfc-3339=seconds)] T1 jq is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 jq was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    to_be_installed="$to_be_installed jq"
fi
if [ $(command -v steam) ];
then
    echo "[$(date --rfc-3339=seconds)] T1 steam is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 steam was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    [ "$operating_system" = "Debian GNU/Linux" ] && usermod -a -G video,audio $real_user
    [ "$operating_system" = "Debian GNU/Linux" ] && dpkg --add-architecture i386
    to_be_installed="$to_be_installed steam"
fi
if [ $(command -v steamcmd) ]
then
    echo "[$(date --rfc-3339=seconds)] T1 steam CMD is already installed, proceeding..." >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 steam CMD was not yet installed, installing..." >> ~/faf.sh-$faf_sh_version.log
    if [ "'$operating_system'" = "Debian GNU/Linux" ]
    then
        if getent passwd steam > /dev/null 2>&1
        then
	    echo "steam home already exists"
        else
	    useradd -m steam
            ln -s /usr/games/steamcmd /home/steam/steamcmd
        fi
    fi
    to_be_installed="$to_be_installed steamcmd"
fi
if [ $(command -v winetricks) ]
then
    purge_winetricks=true
else
    purge_winetricks=false
fi
# end eval missing dependencies

# Isolating all sudo commands into a seperate window
sudo_script='echo "If you wish for this script to be able to do its task you must elevate it to sudo and it will install the needed dependencies.";
echo "Fortunately all sudo commands have been centralized to this one window and you can know ahead of time all the sudo commands that will be run.";
echo "At your own discretion, you may copy them, exit the script by closing all the terminal windows and execute them yourself.";
echo "Upon re-runing the script this window should not appear and you should not be prompted for sudo priveledges.";
echo "";
echo "However, if you trust the script, you may simply type in your admin password and this script will continue.";
echo "";
echo "Pending obtaning sudo priveledges, this windows will run the following :";
echo "";
echo "sudo apt update -y &&";
echo "sudo apt full-upgrade -y &&";
if '$purge_winetricks';
then echo "sudo purge winetricks -y";
fi;
echo "sudo apt install -y'$to_be_installed' &&";
echo "sudo apt autoremove -y &&";
echo "sudo apt autoclean";
echo "wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks";
echo "chmod +x winetricks";
echo "wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion";
echo "sudo mv winetricks /usr/bin";
echo "sudo mv winetricks.bash-completion /usr/share/bash-completion/completions/winetricks";
echo "";
[ "'$operating_system'" != "Debian GNU/Linux" ] && sudo echo "";
if [ ! $(command -v steam) ];
then if [ "'$operating_system'" != "Zorin OS" ];
then echo steam steam/question select "I AGREE" | sudo debconf-set-selections;
echo steam steam/license note '' | sudo debconf-set-selections;
fi;
fi;
if [ ! $(command -v steamcmd) ];
then if [ "'$operating_system'" != "Zorin OS" ];
then echo steamcmd steam/question select "I AGREE" | sudo debconf-set-selections;
echo steamcmd steam/license note '' | sudo debconf-set-selections;
fi;
fi;
if [ "'$operating_system'" = "Debian GNU/Linux" ];
then if grep -q "debian.org/debian/ stretch main contrib non-free" /etc/apt/sources.list > /dev/null;
then echo "[$(date --rfc-3339=seconds)] T2 editing debian sources : stretch already correct" >> ~/faf.sh-'$faf_sh_version'.log;
else echo "[$(date --rfc-3339=seconds)] T2 editing debian sources : stretch edited" >> ~/faf.sh-'$faf_sh_version'.log;
sed -i "s_debian.org/debian/ stretch main contrib_debian.org/debian/ stretch main contrib non-free_" /etc/apt/sources.list;
fi;
if grep -q "http://security.debian.org/debian-security stretch/updates main contrib non-free" /etc/apt/sources.list > /dev/null;
then echo "[$(date --rfc-3339=seconds)] T2 editing debian sources : stretch/updates already correct" >> ~/faf.sh-'$faf_sh_version'.log;
else echo "[$(date --rfc-3339=seconds)] T2 editing debian sources : stretch/updates edited" >> ~/faf.sh-'$faf_sh_version'.log;
sed -i "s_http://security.debian.org/debian-security stretch/updates main contrib_http://security.debian.org/debian-security stretch/updates main contrib non-free_" /etc/apt/sources.list;
fi;
if grep -q "debian.org/debian/ stretch-updates main contrib non-free" /etc/apt/sources.list > /dev/null;
then echo "[$(date --rfc-3339=seconds)] T2 editing debian sources : stretch-updates already correct" >> ~/faf.sh-'$faf_sh_version'.log;
else echo "[$(date --rfc-3339=seconds)] T2 editing debian sources : stretch-updates edited" >> ~/faf.sh-'$faf_sh_version'.log;
sed -i "s_debian.org/debian/ stretch-updates main contrib_debian.org/debian/ stretch-updates main contrib non-free_" /etc/apt/sources.list;
fi;
if grep -q "deb http://ftp.*.debian.org/debian/ stretch-proposed-updates main contrib non-free" /etc/apt/sources.list > /dev/null;
then echo "[$(date --rfc-3339=seconds)] T2 editing debian sources : proposed already present" >> ~/faf.sh-'$faf_sh_version'.log;
else donwload_country=$(grep "deb http://ftp." /etc/apt/sources.list | head -1 | cut -d. -f2);
echo "[$(date --rfc-3339=seconds)] T1 editing debian sources : added proposed" >> ~/faf.sh-'$faf_sh_version'.log;
echo "deb http://ftp.$donwload_country.debian.org/debian/ stretch-proposed-updates main contrib non-free" >> /etc/apt/sources.list;
fi;
else if grep -Fxq "# deb http://archive.canonical.com/ubuntu cosmic partner" /etc/apt/sources.list;
then echo "[$(date --rfc-3339=seconds)] T2 enabled partners" >> ~/faf.sh-'$faf_sh_version'.log;
sudo sed -i "s/# deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/g" /etc/apt/sources.list;
else echo "[$(date --rfc-3339=seconds)] T2 did not enable partners, hoping it was already enabled." >> ~/faf.sh-'$faf_sh_version'.log;
fi;
fi;
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks;
chmod +x winetricks;
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion;
sudo mv winetricks /usr/bin;
sudo mv winetricks.bash-completion /usr/share/bash-completion/completions/winetricks;
if [ \( "'$operating_system'" = "Arch" \) -o \( "'$operating_system'" = "Manjaro" \) ];
then sudo pacman -Syu;
sudo pacman -Syy;
sudo pacman -Scc;
sudo pacman -Suu;
if '$purge_winetricks';
then sudo pacman -R winetricks;
fi;
sudo pacman -S '$to_be_installed';
elif [ "'$operating_system'" = "Fedora" ];
then sudo dnf distro-sync;
if '$purge_winetricks';
then sudo dnf remove winetricks -y;
fi;
sudo dnf install -y'$to_be_installed';
sudo dnf clean all;
sudo dnf autoremove;
elif [ "'$operating_system'" = "Mageia" ];
then sudo dnf distro-sync;
if '$purge_winetricks';
then sudo dnf remove winetricks -y;
fi;
sudo dnf install -y'$to_be_installed';
sudo dnf clean all;
sudo dnf autoremove;
elif [ "'$operating_system'" = "CentOS" ];
then sudo yum upgrade;
if '$purge_winetricks';
then sudo yum remove winetricks -y;
fi;
sudo yum install -y'$to_be_installed';
sudo yum clean all;
else sudo apt update -y;
sudo apt full-upgrade -y;
if '$purge_winetricks';
then sudo apt purge winetricks -y;
fi;
sudo apt install -y'$to_be_installed';
sudo apt autoremove -y;
sudo apt autoclean;
fi;'"'"''
# dnf is used in Fedora, and RHEL 8 and later;
# yum is used in RHEL up to version 7, CentOS up to version 7, and probably other RPM-based distributions;
# for OpenSuSe it'll be zypper
# pacman / yahourt for arch
# https://wiki.archlinux.org/index.php/Pacman/Rosetta

# opening and closings
#debian_opening_sudo_script='gnome-terminal -- bash -c '"'"''
gnome_opening_sudo_script='gnome-terminal --tab --active --title="externalized sudo" -- bash -c '"'"''
konsole_opening_sudo_script='konsole -e /bin/bash --rcfile <(echo '"'"''
io_opening_sudo_script='io.elementary.terminal -e '"'"''
xterm_opening_sudo_script='xterm -T "externalized sudo" -e '"'"''

gnome_opening_faf_script='gnome-terminal --tab --active --title="install & run steam, steamcmd, FA" -- bash -c '"'"''
konsole_opening_faf_script='konsole -e /bin/bash --rcfile <(echo '"'"''
io_opening_faf_script='io.elementary.terminal -e "bash -c '"'"'curl  wttr.in/bydgoszcz'"'"';'"'"'sleep 3'"'"''
xterm_opening_faf_script='xterm -T "install & run steam, steamcmd, FA" -e '"'"''

gnome_closing_faf_script='gnome-terminal -- bash -c "cd faf; ./downlords-faf-client";'"'"''
konsole_closing_faf_script='konsole -e /bin/bash --rcfile <(echo "cd faf; ./downlords-faf-client; exit 0") &'"'"') &'
io_closing_faf_script='io.elementary.terminal -e "cd faf; ./downlords-faf-client";'"'"''
xterm_closing_faf_script='xterm -T "FAF" -e "cd faf; ./downlords-faf-client";'"'"' &'
# end opening and closings

echo ""
if [ "$to_be_installed" = "" ]
then
    echo "all dependencies met :)"
    echo "[$(date --rfc-3339=seconds)] T1 all dependencies met" >> ~/faf.sh-$faf_sh_version.log
else
    echo "[$(date --rfc-3339=seconds)] T1 installing $to_be_installed..." >> ~/faf.sh-$faf_sh_version.log
    # OS splitter
    if [ \( "'$operating_system'" = "Ubuntu" \) -o \( "'$operating_system'" = "Debian GNU/Linux" \) ]
    then
        eval "$gnome_opening_sudo_script $sudo_script"
    elif [ "$operating_system" = "Kubuntu" ]
    then
        eval "$konsole_opening_sudo_script $sudo_script)" &
    elif [ "$operating_system" = "elementary OS" ] # elementary's acting up. have to resort to xterm
    then
        eval "$xterm_opening_sudo_script $sudo_script" &
    else
        eval "$xterm_opening_sudo_script $sudo_script"
    fi
fi
echo "[$(date --rfc-3339=seconds)] T1 start of second thread did not crash first thread" >> ~/faf.sh-$faf_sh_version.log
# end of OS Splitter

function install_faf_function
{
# Download & install FAF client
echo "now moving on to installing Downlord's FAF..."

if [ \( "'$operating_system'" = "Arch" \) -o \( "'$operating_system'" = "Manjaro" \) ]
then
    if [ ! -d faf ]
    then
        mkdir faf
        cd faf
        curl https://aur.archlinux.org/cgit/aur.git/snapshot/downlords-faf-client.tar.gz
        pv -xzvf faf.tar.gz | tar xzp -C ~/faf
        cd faf
        makepkg -si
	cd
	ln -s ~/.faforever/user
    fi
else
    if [ ! -d faf ]
    then
        echo "[$(date --rfc-3339=seconds)] T1 installing DOWNLORD" >> ~/faf.sh-$faf_sh_version.log
        mkdir faf
        cd faf
        faf_version_number=$(curl -v --silent https://api.github.com/repos/FAForever/downlords-faf-client/releases 2>&1 | grep '"tag_name": ' | head -n 1 | cut -f4,4 -d'"')
        faf_version=$( echo ${faf_version_number:1} | tr '.' '_' )
        wget https://github.com/FAForever/downlords-faf-client/releases/download/$faf_version_number/dfc__unix_$faf_version.tar.gz
        pv dfc__unix_$faf_version.tar.gz | tar xzp -C ~/faf
        mv downlords-faf-client-${faf_version_number:1}/{.,}* . 2>/dev/null
        rm -rf downlords-faf-client-${faf_version_number:1}
        rm dfc__unix_$faf_version.tar.gz
        chmod +x downlords-faf-client
        chmod +x lib/faf-uid
    fi
    cd ~
    # /end Download & install FAF client
    # Java install block
    echo "Now seeing if Java was already installed by this script..."
    echo "[$(date --rfc-3339=seconds)] T1 Now seeing if Java was already installed by this script..." >> ~/faf.sh-$faf_sh_version.log
    if [ -d ~/faf/jdk-10.0.2 ]
    then
        echo "Java is already installed, moving on"
        echo "[$(date --rfc-3339=seconds)] T1 Java already installed!" >> ~/faf.sh-$faf_sh_version.log
    else
        # Download & install java 10 open jdk
        echo "Java 10 installation procedure..."
        echo "[$(date --rfc-3339=seconds)] T1 Java 10 installing..." >> ~/faf.sh-$faf_sh_version.log
        wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
        pv ~/openjdk-10.0.2_linux-x64_bin.tar.gz | tar xzp -C ~/faf
        rm openjdk-10.0.2_linux-x64_bin.tar.gz
        echo "" >> ~/.bashrc
        echo "" >> ~/.bashrc
        ! grep -q 'INSTALL4J_JAVA_HOME' ~/.bashrc > /dev/null && echo "export INSTALL4J_JAVA_HOME=~/faf/jdk-10.0.2" >> ~/.bashrc
        # /end Download & install java 10 open jdk
    fi
fi
# /end Java install block
# make faf .desktop runner
[ ! -d ~/.local/share/icons ] && mkdir -p .local/share/icons
if [ ! -f ~/.local/share/icons/faf.png ]
then
    echo "[$(date --rfc-3339=seconds)] T1 getting desktop launcher icon" >> ~/faf.sh-$faf_sh_version.log
    cd ~/.local/share/icons
    wget https://github.com/tatsujb/FAFICON/raw/master/faf.png
fi
if [ ! -f ~/.local/share/applications/faforever.desktop ]
then
    echo "[$(date --rfc-3339=seconds)] T1 making desktop launcher" >> ~/faf.sh-$faf_sh_version.log
    cd ~/.local/share/applications
    echo '#!/usr/bin/env xdg-open' >> faforever.desktop
    echo "[Desktop Entry]" >> faforever.desktop
    echo "Version=$faf_version" >> faforever.desktop
    echo "Type=Application" >> faforever.desktop
    echo 'Exec=bash -c "cd ~/faf;export INSTALL4J_JAVA_HOME=~/faf/jdk-10.0.2; ./downlords-faf-client"' >> faforever.desktop
    echo "Name=FAF" >> faforever.desktop
    echo "Comment=Forged Alliance Forever Client" >> faforever.desktop
    echo "Icon=~/.local/share/icons/faf.png" >> faforever.desktop
    chmod +x faforever.desktop
fi
cd ~
# /end make faf .desktop runner
}
 
function set_install_dir_function
{
    directory=$(zenity --file-selection --directory --title "$1")
    echo "[$(date --rfc-3339=seconds)] T1 folder set to $directory" >> ~/faf.sh-$faf_sh_version.log
} 

function get_user_input_function
{
if (whiptail --title "The game Forged Alliance is NOT installed on my system :" --yesno "" 12 85 --fb)
then
    already_fa=false
    if (whiptail --title "Install Forged Alliance to default dirrectory? (SDA)" --yesno "Current install dir : ~/.steam/steam/steamapps/common/Supreme Commander Forged Alliance\n(default)" 12 85 --fb)
    then
        default_dir=true
        echo "[$(date --rfc-3339=seconds)] T1 default dir chosen" >> ~/faf.sh-$faf_sh_version.log
    else
        default_dir=false
        echo "[$(date --rfc-3339=seconds)] T1 non-standart dir chosen" >> ~/faf.sh-$faf_sh_version.log
        set_install_dir_function "choose your desired Forged Alliance installation directory/folder"
    fi
else
    echo "[$(date --rfc-3339=seconds)] T1 FA already installed chosen" >> ~/faf.sh-$faf_sh_version.log
    what_to_do=$(whiptail --title "What do you wish to do?" --notags --nocancel --menu "" 12 85 0 "1" "Install another FA somewhere else, then install (FAF)" "2" "Reinstall FA, then install (FAF)" "3" "Use my install of FA and install (FAF)" "4" "FA is configured, I only want (FAF)" "5" "...wait... I messed up!" --fb 3>&1 1>&2 2>&3)
    case $what_to_do in
        1)
            echo "[$(date --rfc-3339=seconds)] T1 resintall FA chosen" >> ~/faf.sh-$faf_sh_version.log
            already_fa=false
            if (whiptail --title "Second install of Forged Alliance to default dirrectory? (SDA)" --yesno "Current install dir : ~/.steam/steam/steamapps/common/Supreme Commander Forged Alliance\n(default)" 12 85 --fb)
            then
                default_dir=true
                echo "[$(date --rfc-3339=seconds)] T1 default dir chosen" >> ~/faf.sh-$faf_sh_version.log
            else
                default_dir=false
                echo "[$(date --rfc-3339=seconds)] T1 non-standart dir chosen" >> ~/faf.sh-$faf_sh_version.log
                set_install_dir_function "choose your desired Forged Alliance installation directory/folder"
            fi
        ;;
        2)
            del_directory=$(zenity --file-selection --directory --title "select the folder you want to delete (FA)")
            rm -rf del_directory
            echo "[$(date --rfc-3339=seconds)] T1 resintall FA chosen" >> ~/faf.sh-$faf_sh_version.log
            already_fa=false
            if (whiptail --title "ReInstall Forged Alliance to default dirrectory? (SDA)" --yesno "Current install dir : ~/.steam/steam/steamapps/common/Supreme Commander Forged Alliance\n(default)" 12 85 --fb)
            then
                default_dir=true
                echo "[$(date --rfc-3339=seconds)] T1 default dir chosen" >> ~/faf.sh-$faf_sh_version.log
            else
                default_dir=false
                echo "[$(date --rfc-3339=seconds)] T1 non-standart dir chosen" >> ~/faf.sh-$faf_sh_version.log
                set_install_dir_function "choose your desired Forged Alliance installation directory/folder"
            fi
        ;;
        3)
            echo "[$(date --rfc-3339=seconds)] T1 keep but configure FA chosen" >> ~/faf.sh-$faf_sh_version.log
            already_fa=true
            default_dir=false
            set_install_dir_function  "Select grandparent folder that contains steamapps/common/Supreme Commander Forged Alliance"
            while [ ! -d "$directory/steamapps/common/Supreme Commander Forged Alliance" ]
            do
                set_install_dir_function "Sorry, that was wrong, Select grandparent folder that contains steamapps/common/Supreme Commander Forged Alliance"
            done
        ;;
        4)
            echo "[$(date --rfc-3339=seconds)] T1 keep and dont configure FA chosen" >> ~/faf.sh-$faf_sh_version.log
            install_faf_function
            echo "installed faf only, as per user demand, nothing else to do, exiting."
            exit 0
        ;;
        5)
            get_user_input_function
    esac
fi
}

get_user_input_function


echo ""
echo "[$(date --rfc-3339=seconds)] T1 FA not installed chosen" >> ~/faf.sh-$faf_sh_version.log
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
# NOTE THAT THIS IS NOT MY IDEAL SOLUTION BUT I HAVENT YET FOUND BETTER
echo "[$(date --rfc-3339=seconds)] T1 Steam credentials entrusted to scritp" >> ~/faf.sh-$faf_sh_version.log
echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1, PROTON_USE_GALLIUM_NINE=1, PROTON_GALLIUM_NINE_MODULEPATH="/usr/lib/i386-linux-gnu/d3d/d3dadapter9.so.1:/usr/lib/x86_64-linux-gnu/d3d/d3dadapter9.so.1" %command%' > ~/"the contents of this file are to be pasted in the forged alliance properties launch options"

echo ""
i=1
sp="/-\|"
no_steam=true
echo "waiting for dependencies to be present... "
while $no_steam
do
  printf "\b${sp:i++%${#sp}:1}"
  [[ $(command -v steam) ]] && no_steam=false
  sleep 1
done
# [[ $(dpkg-query -W -f='${Status}' python3-pip 2>/dev/null | grep "ok installed") ]] && no_pipx=false
echo ""

# start faf_script '"'"'
faf_script='echo "expecting you to type in Forged Alliances Launch options";
echo "reminder : look in your home folder, theres a file there with the contents to be pasted";
echo "once thats done edit steam settings in order to enable Proton for all games";
if '$already_fa';
then echo "";
else echo "";
echo "";
echo "";
echo "[$(date --rfc-3339=seconds)] T3 running steam" >> ~/faf.sh-'$faf_sh_version'.log;
steam -login '$steam_user_name' '$steam_password';
if '$default_dir';
then echo "[$(date --rfc-3339=seconds)] T3 installing FA to default dir" >> ~/faf.sh-'$faf_sh_version'.log;
while [ \( ! -d ~/.steam/steam/steamapps/common/Supreme* \) -a \( ! -d ~/.steam/steam/SteamApps/common/Supreme* \) ];
do steamcmd +login '$steam_user_name' '$steam_password' +@sSteamCmdForcePlatformType windows +app_update 9420 +quit;
done;
else echo "[$(date --rfc-3339=seconds)] T3 installing FA to default dir" >> ~/faf.sh-'$faf_sh_version'.log;
while [ ! -d '$directory'/bin ];
do steamcmd +login '$steam_user_name' '$steam_password' +@sSteamCmdForcePlatformType windows +force_install_dir '$directory' +app_update 9420 +quit;
done;
cd '$directory';
mkdir -p steamapps/common/Supreme\ Commander\ Forged\ Alliance;
mv * steamapps/common/Supreme\ Commander\ Forged\ Alliance/ 2>/dev/null;
cd ~;
fi;
echo "[$(date --rfc-3339=seconds)] T3 FA installed condition met" >> ~/faf.sh-'$faf_sh_version'.log;
fi;
echo "[$(date --rfc-3339=seconds)] T3 launching FA" >> ~/faf.sh-'$faf_sh_version'.log;
eval "steam -login '$steam_user_name' '$steam_password' -applaunch 9420 &";
echo "";
if '$default_dir';
then origin="~/.steam/steam";
else origin='$directory';
fi;
i=1;
sp="/-\|";
no_config=true;
while $no_config;
do printf "\b${sp:i++%${#sp}:1}";
[[ -f "$origin/steamapps/compatdata/9420/pfx/drive_c/users/steamuser/Local Settings/Application Data/Gas Powered Games/Supreme Commander Forged Alliance/Game.prefs" ]] && [ ! $(pidof SupremeCommande) ]  && no_config=false;
sleep 1;
done;
echo "";
if '$already_fa';
then echo;
else echo "[$(date --rfc-3339=seconds)] T3 copying over run file" >> ~/faf.sh-'$faf_sh_version'.log;
cp -f /tmp/proton_'$real_user'/run ~/faf/
fi;
echo "[$(date --rfc-3339=seconds)] T3 making symbolic links" >> ~/faf.sh-'$faf_sh_version'.log;
if '$default_dir';
then if [ -d ~/.steam/steam/steamapps ];
then if [ -d ~/.steam/steam/steamapps/common/Supreme* ];
then cd ~/.steam/steam/steamapps/common/Supreme\ Commander\ Forged\ Alliance;
rm -rf Maps;
rm -rf Mods;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods;
else echo "[$(date --rfc-3339=seconds)] T3 steamapps FA folder not found" >> ~/faf.sh-'$faf_sh_version'.log;
fi;
if [ -d ~/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser ];
then cd ~/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser;
rm -rf My\ Documents;
mkdir My\ Documents;
cd My\ Documents;
ln -s ~/My\ Games/ My\ Games;
else echo "[$(date --rfc-3339=seconds)] T3 steamapps FA compatdata folder not found" >> ~/faf.sh-'$faf_sh_version'.log;
fi;
elif [ -d ~/.steam/steam/SteamApps ];
then echo "[$(date --rfc-3339=seconds)] T3 curious case of SteamApps instead of steamapps" >> ~/faf.sh-'$faf_sh_version'.log;
if [ -d ~/.steam/steam/SteamApps/common/Supreme* ];
then cd ~/.steam/steam/SteamApps/common/Supreme\ Commander\ Forged\ Alliance;
rm -rf Maps;
rm -rf Mods;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods;
else echo "[$(date --rfc-3339=seconds)] T3 SteamApps FA folder not found" >> ~/faf.sh-'$faf_sh_version'.log;
fi;
if [ -d ~/.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser ];
then cd ~.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser;
rm -rf My\ Documents;
mkdir My\ Documents;
cd My\ Documents;
ln -s ~/My\ Games/ My\ Games;
else echo "[$(date --rfc-3339=seconds)] T3 SteamApps FA compatdata folder not found" >> ~/faf.sh-'$faf_sh_version'.log;
fi;
else echo "[$(date --rfc-3339=seconds)] T3 neither steamapps nor SteamApps are found. exiting" >> ~/faf.sh-'$faf_sh_version'.log;
exit 1;
fi;
else echo "[$(date --rfc-3339=seconds)] T3 symlinking for non-standart install location" >> ~/faf.sh-'$faf_sh_version'.log;
cd '$directory'/steamapps/common/Supreme\ Commander\ Forged\ Alliance;
rm -rf Maps;
rm -rf Mods;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps;
ln -s ~/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods;
if [ -d ~/.steam/steam/steamapps ];
then if [ -d ~/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser ];
then cd '$directory'/steamapps/compatdata/9420/pfx/drive_c/users/steamuser;
rm -rf My\ Documents;
mkdir My\ Documents;
cd My\ Documents;
ln -s ~/My\ Games/ My\ Games;
fi;
elif [ -d ~/.steam/steam/SteamApps ];
then if [ -d ~/.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser ];
then cd ~.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser;
rm -rf My\ Documents;
mkdir My\ Documents;
cd My\ Documents;
ln -s ~/My\ Games/ My\ Games;
fi;
fi;
fi;
cd ~;
source .bashrc;
eval "$(cat .bashrc | tail -n +10)";
echo "[$(date --rfc-3339=seconds)] T3 starting T4 and exiting T3" >> ~/faf.sh-'$faf_sh_version'.log;'
# end faf_script

# OS splitter again
# OS splitter
if [ \( "'$operating_system'" = "Ubuntu" \) -o \( "'$operating_system'" = "Debian GNU/Linux" \) ]
then
    eval "$gnome_opening_faf_script $faf_script $gnome_closing_faf_script"
elif [ "$operating_system" = "Kubuntu" ]
then
     eval "$konsole_opening_faf_script $faf_script $konsole_closing_faf_script"
elif [ "$operating_system" = "elementary OS" ] # elementary's acting up. have to resort to xterm
then
    eval "$xterm_opening_faf_script $faf_script $xterm_closing_faf_script" #"$io_opening_faf_script $middlescript $io_closing_faf_script"
else
    eval "$xterm_opening_faf_script $faf_script $xterm_closing_faf_script"
fi
echo "[$(date --rfc-3339=seconds)] T1 start of second thread did not crash first thread" >> ~/faf.sh-$faf_sh_version.log
# end of OS Splitter

install_faf_function
 
# wait for user to log in
echo "[$(date --rfc-3339=seconds)] T1 waiting" >> ~/faf.sh-$faf_sh_version.log
echo ""
echo ""
no_login=true
echo -n "Please switch to opened FAF client, waiting on user to log in (if it not open yet simply switch to \"install & run steam, steamcmd, FA\" terminal tab)...  "
while $no_login
do
  printf "\b${sp:i++%${#sp}:1}"
  grep --no-messages '"username": "' ~/.faforever/client.prefs && no_login=false
  sleep 1
done
echo ""
echo "restarting (FAF)"
echo "[$(date --rfc-3339=seconds)] T1 done waiting" >> ~/faf.sh-$faf_sh_version.log
# sleep 2
kill -9 $(pgrep java | tail -1)
# editting client.prefs :
echo "[$(date --rfc-3339=seconds)] T1 editing client.prefs" >> ~/faf.sh-$faf_sh_version.log
if [ -d ~/.steam/steam/SteamApps ]
then
    steamapps="SteamApps"
else
    steamapps="steamapps"
fi
if $default_dir
then
    installationPath="~/.steam/steam/$steamapps/common/Supreme Commander Forged Alliance"
    normalpath="~/.steam/steam/$steamapps/common/Supreme Commander Forged Alliance"
    preferencesFile="~/.steam/steam/$steamapps/compatdata/9420/pfx/drive_c/users/steamuser/Local Settings/Application Data/Gas Powered Games/Supreme Commander Forged Alliance/Game.prefs"
else
    installationPath="$directory/$steamapps/common/Supreme Commander Forged Alliance"
    normalpath="$directory/$steamapps/common/Supreme Commander Forged Alliance"
    preferencesFile="$directory/$steamapps/compatdata/9420/pfx/drive_c/users/steamuser/Local Settings/Application Data/Gas Powered Games/Supreme Commander Forged Alliance/Game.prefs"
fi
jq --arg installationPath "$installationPath" --arg normalpath "$normalpath" --arg preferencesFile "$normalpath"  --arg user_path "~" '
    .forgedAlliance += {
        installationPath: ($installationPath),
        path: ($normalpath),
        preferencesFile: ($preferencesFile),
        executableDecorator: (~ + "/faf/run \"%s\"")
    }' ~/.faforever/client.prefs > ~/.faforever/client.prefs.tmp
mv ~/.faforever/client.prefs.tmp ~/.faforever/client.prefs

gtk-launch steam
gtk-launch faforever
# gallium-nine block
#python3 -m pip install --user pipx
#~/.local/bin/pipx ensurepath
#eval "$(cat .bashrc | tail -n +10)"
#pipx install protontricks
#pipx upgrade protontricks
#protontricks 9420 galliumnine
# gallium-nine block end
echo "Finished thread one (proton/downlord/open-jdk/bashrc) without issue..."
echo "[$(date --rfc-3339=seconds)] T1 Finished thread one. (proton/downlord/open-jdk/bashrc)" >> ~/faf.sh-$faf_sh_version.log
