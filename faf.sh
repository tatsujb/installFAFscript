#!/bin/bash
  faf_sh_version=2.6

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
real_user=$(echo $HOME | cut -c 7-)
work_dir=/tmp/faf_script_workdir
mkdir -p $work_dir
faf_log_file="$work_dir/faf.sh-$faf_sh_version.log"
echo $faf_log_file
touch $faf_log_file &>/dev/null
cd $work_dir

to_log()
{
    echo -e "[$(date --rfc-3339=seconds)] T1 $@" >> $faf_log_file
}

log_separator()
{
    echo "_______________________________________________________________________________________________________" >> $faf_log_file
}

log_separator
# DETERMINE OS BASE :
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
to_log "New log file. fafSTACK version "$faf_sh_version" running : "$unameOut  ;;
    Darwin*)
echo "Mac / Apple Macintosh is not supported yet though it could technically be; as evidenced by previous examples of people running FA and even FAF on mac. Feel free to contribute at : https://github.com/tatsujb/installFAFscript"
to_log "New log file. fafSTACK version "$faf_sh_version". FAILIURE. MAC UNSUPPORTED. "$unameOut
exit 1;;
    CYGWIN*)
echo "Hello, you can go straight to : www.faforever.com and click on \"Download Client\". This script exists in order to help linux users achieve the same thing you can do out-of-the-box on your operating system. You have not the remotest use for this script :) be free, wild bird!"
to_log "New log file. fafSTACK version "$faf_sh_version". FAILIURE. WINDOWS UNSUPPORTED. "$unameOut
exit 1;;
    MINGW*)
echo "Hello, are can on MinGW you cannot run Forged Alliance, this script is of no use to you."
to_log "New log file. fafSTACK version "$faf_sh_version". FAILIURE. MINGW UNSUPPORTED. "$unameOut
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
elif type lsb_release &>/dev/null; then
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

echo "Distribution name + version + kernel version + architecture : "$operating_system" "$os_version" "$(uname -rm) >> "$faf_log_file"
log_separator
echo "Hard storage setup :" >> "$faf_log_file"
log_separator
lsblk_ouput=$(lsblk | grep -v 'loop')
echo "$lsblk_ouput" >> "$faf_log_file"
dfh_ouput=$(df -h --total | grep -v 'loop')
echo "$dfh_ouput" >> "$faf_log_file"
log_separator
echo "" >> "$faf_log_file"

# Get the name and execute switch for a useful terminal emulator
#
# Sets $gxtpath to the emulator path or empty
# Sets $gxttitle to the "title" switch for that emulator
# Sets $gxtexec to the "execute" switch for that emulator
# May clobber $gtx*
# gnome-terminal and mate-terminal use -e differently to other emulators
# in the case of gnome-terminal ALWAYS use the options before $gxtexec
# Terminals organised in decreasing order of reliability and
# compatibility with the script
gxtpredetected="$(ps -p $(ps -p $(ps -p $$ -o ppid=) -o ppid=) o args= | awk '{print $1}' )"
for gxti in "gnome-terminal --title -- --tab --active" \
                "xterm -T -e" \
                "urxvt -T -e" \
                "konsole --title -e" \
                "mate-terminal --title -x" \
                "rxvt -T -e"; do
    set $gxti
    case "$gxtpredetected" in *$1*)
        gxtdetected="$1";;
    esac
    gxtpath="`which $1 2>/dev/null`"
    case "$gxtpath" in ?*)
        gxttitle=$2
        gxtexec=$3
        gxtoptions="$4 $5 $6 $7 $8"
        break
	;;
    esac
done

if [ -z "$gxtdetected" ]; then 
    to_log "User terminal unrecognised or unrecommended $gxtpredetected in favor of $gxtpath."
else 
    to_log "User terminal detected as $gxtdetected"
fi
to_log "Used terminal is $gxtpath."

# bengining of find missing dependencies
to_be_installed="lib32gcc1"

if_not_then_install() {
	# $1  is the package to be installed
	# $2  is the condition
	if ! $2 &>/dev/null
	then
                to_log "$1 was not yet installed, installing..."
		to_be_installed="$to_be_installed $1"
	else
		to_log "$1 is already installed, proceeding..."
	fi
}

if_not_then_install "procps" "[ -f /bin/kill ]"
if_not_then_install "xterm" "[ $(command -v xterm) ]"
if_not_then_install "whiptail" "[ $(command -v whiptail) ]"
if_not_then_install "pv" "[ $(command -v pv) ]"
if_not_then_install "curl" "[ $(command -v curl) ]"
if_not_then_install "jq" "[ $(command -v jq) ]"
if_not_then_install "zenity" "[ $(command -v zenity) ]"
[[ "$operating_system" = "Ubuntu" ]] && if_not_then_install "gnome-terminal" "[ $(command -v gnome-terminal) ]" # TODO Deprecated? Redundant?
if_not_then_install "steam" "[ $(command -v steam) ]"
if_not_then_install "steamcmd" "[ $(command -v steamcmd) ]"

# end of find missing dependencies

echo ""
if [ "$to_be_installed" = "" ]
then
    echo "all dependencies met :)"
    to_log "all dependencies met"
else
    to_run_sudo_script="$work_dir/sudo_script.sh --logfile $faf_log_file --operating_system \'$operating_system\'"
    to_log "to be installed : $to_be_installed"
    if [ ! -f sudo_script.sh ]
    then
        wget https://raw.githubusercontent.com/tatsujb/installFAFscript/master/sudo_script.sh
    fi
    chmod +x sudo_script.sh
    $gxtpath $gxtoptions $gxttitle "externalised sudo" $gxtexec $to_run_sudo_script "$to_be_installed"
fi
#rm sudo_script.sh

to_log "start of second thread did not crash first thread"
 
function set_install_dir_function
{
    directory=$(zenity --file-selection --directory --title "$1")
    to_log "folder set to $directory"
} 

function install_faf_function
{
# Download & install FAF client
echo "now moving on to installing Downlord's FAF..."

to_log "installing DOWNLORD"
cd $work_dir
if [[ "$operating_system" = "Arch" || "$operating_system" = "Manjaro" ]]
then
    curl https://aur.archlinux.org/cgit/aur.git/snapshot/downlords-faf-client.tar.gz
    tar -xf downlords-faf-client.tar.gz
    cd downlords-faf-client
    makepkg -si
    cd
    ln -s $HOME/.faforever/user
else
    faf_version_number=$(curl -v --silent https://api.github.com/repos/FAForever/downlords-faf-client/releases 2>&1 | grep '"tag_name": ' | head -n 1 | cut -f4,4 -d'"')
    faf_version=$( echo ${faf_version_number:1} | tr '.' '_' )
    wget https://github.com/FAForever/downlords-faf-client/releases/download/$faf_version_number/_dfc_unix_$faf_version.tar.gz
    pv _dfc_unix_$faf_version.tar.gz | tar xzp -C $work_dir/faf
    mv downlords-faf-client-${faf_version_number:1}/{.,}* . 2>/dev/null
    rm -rf downlords-faf-client-${faf_version_number:1}
    rm _dfc_unix_$faf_version.tar.gz

    # /end Download & install FAF client
    # Java install block
    echo "Now seeing if Java was already installed by this script..."
    to_log "Now seeing if Java was already installed by this script..."
    if [ -d $work_dir/faf/jdk-10.0.2 ]
    then
        echo "Java is already installed, moving on"
        to_log "Java already installed!"
    else
        # Download & install java 10 open jdk
        echo "Java 10 installation procedure..."
        to_log "Java 10 installing..."
        wget https://download.java.net/java/GA/jdk10/10.0.2/19aef61b38124481863b1413dce1855f/13/openjdk-10.0.2_linux-x64_bin.tar.gz
        pv $work_dir/faf/openjdk-10.0.2_linux-x64_bin.tar.gz | tar xzp -C $work_dir/faf
        rm openjdk-10.0.2_linux-x64_bin.tar.gz
        echo "" >> $HOME/.bashrc
        echo "" >> $HOME/.bashrc
        ! grep -q 'INSTALL4J_JAVA_HOME' $HOME/.bashrc > /dev/null && echo "export INSTALL4J_JAVA_HOME=$HOME/faf/jdk-10.0.2" >> $HOME/.bashrc
        # /end Download & install java 10 open jdk
    fi
fi
# /end Java install block
# make faf .desktop runner
[ ! -d $HOME/.local/share/icons ] && mkdir -p $HOME/.local/share/icons
if [ ! -f $HOME/.local/share/icons/faf.png ]
then
    to_log "getting desktop launcher icon"
    cd $HOME/.local/share/icons
    wget https://github.com/tatsujb/FAFICON/raw/master/faf.png
fi
if [ ! -f $HOME/.local/share/applications/faforever.desktop ]
then
    to_log "making desktop launcher"
    cd $HOME/.local/share/applications
    echo '#!/usr/bin/env xdg-open' >> faforever.desktop
    echo "[Desktop Entry]" >> faforever.desktop
    echo "Version=$faf_version" >> faforever.desktop
    echo "Type=Application" >> faforever.desktop
    echo 'Exec=bash -c "cd $HOME/faf; export INSTALL4J_JAVA_HOME=$HOME/faf/jdk-10.0.2; ./downlords-faf-client"' >> faforever.desktop
    echo "Name=FAF" >> faforever.desktop
    echo "Comment=Forged Alliance Forever Client" >> faforever.desktop
    echo "Icon=$HOME/.local/share/icons/faf.png" >> faforever.desktop
    chmod +x faforever.desktop
fi
cd $work_dir
# /end make faf .desktop runner
}

function get_user_input_function
{
if (whiptail --title "The game Forged Alliance is NOT installed on my system :" --yesno "" 12 85 --fb)
then
    already_fa=false
    if (whiptail --title "Install Forged Alliance to default dirrectory? (SDA)" --yesno "Current install dir : $HOME/.steam/steam/steamapps/common/Supreme Commander Forged Alliance\n(default)" 12 85 --fb)
    then
        default_dir=true
        to_log "default dir chosen"
    else
        default_dir=false
        to_log "non-standart dir chosen"
        set_install_dir_function "choose your desired Forged Alliance installation directory/folder"
    fi
else
    to_log "FA already installed chosen"
    what_to_do=$(whiptail --title "What do you wish to do?" --notags --nocancel --menu "" 12 85 0 "1" "Install another FA somewhere else, then install (FAF)" "2" "Reinstall FA, then install (FAF)" "3" "Use my install of FA and install (FAF)" "4" "FA is configured, I only want (FAF)" "5" "...wait... I messed up!" --fb 3>&1 1>&2 2>&3)
    case $what_to_do in
        1)
            to_log "resintall FA chosen"
            already_fa=false
            if (whiptail --title "Second install of Forged Alliance to default dirrectory? (SDA)" --yesno "Current install dir : $HOME/.steam/steam/steamapps/common/Supreme Commander Forged Alliance\n(default)" 12 85 --fb)
            then
                default_dir=true
                to_log "default dir chosen"
            else
                default_dir=false
                to_log "non-standart dir chosen"
                set_install_dir_function "choose your desired Forged Alliance installation directory/folder"
            fi
        ;;
        2)
            del_directory=$(zenity --file-selection --directory --title "select the folder you want to delete (FA)")
            rm -rf del_directory
            to_log "resintall FA chosen"
            already_fa=false
            if (whiptail --title "ReInstall Forged Alliance to default dirrectory? (SDA)" --yesno "Current install dir : $HOME/.steam/steam/steamapps/common/Supreme Commander Forged Alliance\n(default)" 12 85 --fb)
            then
                default_dir=true
                to_log "default dir chosen"
            else
                default_dir=false
                to_log "non-standart dir chosen"
                set_install_dir_function "choose your desired Forged Alliance installation directory/folder"
            fi
        ;;
        3)
            to_log "keep but configure FA chosen"
            already_fa=true
            default_dir=false
            set_install_dir_function  "Select grandparent folder that contains steamapps/common/Supreme Commander Forged Alliance"
            while [ ! -d "$directory/steamapps/common/Supreme Commander Forged Alliance" ]
            do
                set_install_dir_function "Sorry, that was wrong, Select grandparent folder that contains steamapps/common/Supreme Commander Forged Alliance"
            done
        ;;
        4)
            to_log "keep and dont configure FA chosen"
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
i=1	
sp='/-\|'	
no_steam=true	
echo "waiting for dependencies to be present... "	
while $no_steam	
do	
  printf "\b${sp:i++%${#sp}:1}"	
  [[ $(command -v steam) ]] && no_steam=false	
  sleep 1	
done	
echo ""	

if [ ! -f install_FA_script.sh ]
then
    wget https://raw.githubusercontent.com/tatsujb/installFAFscript/master/install_FA_script.sh
fi
chmod +x install_FA_script.sh
to_run_faf_script="$work_dir/install_FA_script.sh -l $faf_log_file -o \'$operating_system\' -u $real_user $( $already_fa && echo "-f" ) $( $default_dir && echo "-d" ) --fa_base_dir $directory"
echo "$gxtpath $gxtoptions $gxttitle '(FAF)' $gxtexec $HOME/faf/downlords-faf-client" >> install_FA_script.sh
$gxtpath $gxtoptions $gxttitle "install & run steam, steamcmd and FA" $gxtexec $to_run_faf_script "$to_be_installed"
#rm install_FA_script.sh

to_log "start of second thread did not crash first thread"

install_faf_function

mv "$work_dir/faf/" "$HOME/"
to_log "$([[ -d $HOME/faf ]] && echo did || echo didnt) successfully move faf dir"

# wait for user to log in
to_log "waiting"
echo ""
echo ""
no_login=true
echo "Please switch to opened FAF client, waiting on user to log in"
echo "if FAF is not open yet simply switch to"
echo -n "\"install & run steam, steamcmd, FA\" terminal tab...  "
while $no_login
do
  printf "\b${sp:i++%${#sp}:1}"
  grep --no-messages '"username": "' $HOME/.faforever/client.prefs && no_login=false
  sleep 1
done
echo ""
echo "restarting (FAF)"
to_log "done waiting"
# sleep 2
kill -9 $(pgrep java | tail -1)
# editting client.prefs :
to_log "editing client.prefs"

installation_path="$origin/$steamapps/common/Supreme Commander Forged Alliance"
preferences_file="$origin/$steamapps/compatdata/9420/pfx/drive_c/users/steamuser/Local Settings/Application Data/Gas Powered Games/Supreme Commander Forged Alliance/Game.prefs"
user_path="$HOME/faf/run %s"

jq --arg installation_path "$installation_path" --arg preferences_file "$preferences_file"  --arg user_path "$user_path" '
    .forgedAlliance += {
        installationPath: ($installation_path),
        path: ($installation_path),
        preferencesFile: ($preferences_file),
        executableDecorator: ($user_path)
    }' $HOME/.faforever/client.prefs > $HOME/.faforever/client.prefs.tmp
mv $HOME/.faforever/client.prefs.tmp $HOME/.faforever/client.prefs
gtk-launch faforever

echo "Finished thread one (proton/downlord/open-jdk/bashrc) without issue..."
to_log "Finished thread one. (proton/downlord/open-jdk/bashrc)"
