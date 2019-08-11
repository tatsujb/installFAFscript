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

[ $1 = "DEBUG" ] && DEBUG=true || DEBUG=false

real_user=$(logname)
cur_dir="$(pwd)"
faf_path="$HOME/.local/share/faforever"
faf_config_dir="$HOME/.faforever"
work_dir=/tmp/faf_script_workdir
faf_log="$work_dir/faf.sh-$faf_sh_version.log"
installFAtmpfile="$work_dir/tmpInstallFA"
#spinner vars
i=1
sp='/-\|'
mkdir -p $work_dir 2>/dev/null
echo "Find the logfile here : $faf_log"
touch $faf_log &>/dev/null

to_log() { echo -e "[$(date --rfc-3339=seconds)] T1 $*" >> $faf_log; }
echolog() { echo -e $1 ; to_log $1; }

log_separator() { echo "_______________________________________________________________________________________________________" >> $faf_log; }

spin() { printf "\b${sp:i++%${#sp}:1}"; }

$DEBUG && cp ./sudo_script.sh ./install_FA_script.sh "$work_dir" \
       && to_log "DEBUG -- copied sudo and install_FA scripts into workdir $work_dir"

log_separator
# DETERMINE OS BASE :
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
        to_log "New log file. fafSTACK version $faf_sh_version running : $unameOut";;
    Darwin*)
        echo "Mac / Apple Macintosh is not supported yet though it could technically be; as evidenced by previous examples of people running FA and even FAF on mac. Feel free to contribute at : https://github.com/tatsujb/installFAFscript"
        to_log "New log file. fafSTACK version $faf_sh_version. FAILURE. MAC UNSUPPORTED. $unameOut"
        exit 1;;
    CYGWIN*)
        echo "Hello, you can go straight to : www.faforever.com and click on \"Download Client\". This script exists in order to help linux users achieve the same thing you can do out-of-the-box on your operating system. You have not the remotest use for this script :) be free, wild bird!"
        to_log "New log file. fafSTACK version $faf_sh_version. FAILURE. WINDOWS UNSUPPORTED. $unameOut"
        exit 1;;
    MINGW*)
        echo "Hello, are can on MinGW you cannot run Forged Alliance, this script is of no use to you."
        to_log "New log file. fafSTACK version $faf_sh_version. FAILURE. MINGW UNSUPPORTED. $unameOut"
        exit 1;;
esac
# DETERMINE LINUX DISTRO AND RELEASE :
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd (Ubuntu 18.04+)
    . /etc/os-release
    operating_system=$NAME
    os_version=$VERSION_ID
    is_plasma="$(echo $XDG_DATA_DIRS | grep -Eo 'plasma')"
    if [ "$is_plasma" = "plasma" ] || \
       [ "$VERSION_ID" = "Ubuntu" ]; then
        operating_system=Kubuntu
    fi
    [ -z "$os_version" ] && os_version=$(lsb_release -sr)
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

echo "Distribution name + version + kernel version + architecture : $operating_system $os_version $(uname -rm)" >> "$faf_log"
log_separator
# Logging available system resources
echo "Hard storage setup :" >> "$faf_log"
log_separator
df -h --total | grep -E 'Filesystem|sd.[0-9]' >> "$faf_log"
log_separator
echo "" >> "$faf_log"

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
    if ! $2 &>/dev/null; then
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
if_not_then_install "steam" "[ $(command -v steam) ]"
if_not_then_install "steamcmd" "[ $(command -v steamcmd) ]"

# end of find missing dependencies

echo ""
if [ "$to_be_installed" = "" ]
then
    echo "all dependencies met :)"
    to_log "all dependencies met"
else
    to_log "to be installed : $to_be_installed"
    if [ ! -f $work_dir/sudo_script.sh ]
    then
        wget https://raw.githubusercontent.com/tatsujb/installFAFscript/master/sudo_script.sh -O $work_dir/sudo_script.sh
    fi
    chmod +x $work_dir/sudo_script.sh
    $gxtpath $gxtoptions $gxttitle "Configure and Install Dependencies" \
             $gxtexec $work_dir/sudo_script.sh \
                      --logfile $faf_log \
                      --operating_system "$operating_system" \
                      $to_be_installed &
    sleep 1
fi

to_log "start of second thread did not crash first thread"

function set_fa_path
{
    if (whiptail --title "Install Forged Alliance to default dirrectory? (SDA)" \
                 --yesno "Current install dir : ~/.steam/steam/steamapps/common/Supreme Commander Forged Alliance\n(default)" 12 85 --fb)
    then
        echo "default"
        to_log "default FA install path chosen"
    else
        to_log "non-standart dir chosen"
        _title="Choose your desired Forged Alliance installation directory/folder"
        echo "$(zenity --file-selection --directory --title "$_title")"
    fi
    return 0
}

function install_faf_function
{
# Download & install FAF client
echo "now moving on to installing Downlord's FAF..."

to_log "installing DOWNLORD"
cd $work_dir
case "$operating_system" in
    Arch*|Manjaro*)
        curl https://aur.archlinux.org/cgit/aur.git/snapshot/downlords-faf-client.tar.gz
        tar -xf downlords-faf-client.tar.gz
        cd downlords-faf-client
        makepkg -si
        # cd
        # ln -s $faf_config_dir/user
        ;;
    *)
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
        if [ -d $faf_path/jdk-10.0.2 ]
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
            # /end Download & install java 10 open jdk
        fi
        ! grep -q 'INSTALL4J_JAVA_HOME' $HOME/.profile > /dev/null && \
            echo "\n# INSTALL4J_JAVA_HOME is used to run FAForever" >> $HOME/.profile && \
            echo "export INSTALL4J_JAVA_HOME=$faf_path/jdk-10.0.2" >> $HOME/.profile && \
            $(tail -n 1 $HOME/.profile) # make the Java env var available immediatly ?
        ;;
esac
# /end Java install block
# make faf .desktop runner
if [ ! -f $HOME/.local/share/icons/faf.png ]
then
    mkdir -p $HOME/.local/share/icons 2>/dev/null
    to_log "getting desktop launcher icon"
    wget https://github.com/tatsujb/FAFICON/raw/master/faf.png -O $HOME/.local/share/icons/faf.png
fi
if [ ! -f $HOME/.local/share/applications/faforever.desktop ]
then
    to_log "making desktop launcher"
    cd $HOME/.local/share/applications
    echo '#!/usr/bin/env xdg-open' >> faforever.desktop
    echo "[Desktop Entry]" >> faforever.desktop
    echo "Version=$faf_version" >> faforever.desktop
    echo "Type=Application" >> faforever.desktop
    echo "Exec=$faf_path/downlords-faf-client" >> faforever.desktop
    echo "Name=FAF" >> faforever.desktop
    echo "Comment=Forged Alliance Forever Client" >> faforever.desktop
    echo "Icon=$HOME/.local/share/icons/faf.png" >> faforever.desktop
    chmod +x faforever.desktop
fi
# /end make faf .desktop runner
}

function auto_detect_fa_path
{
    steam_def_folders=("$HOME/.local/share/Steam/steamapps/common"
                       "$HOME/.steam/steam/steamapps/common"
                       "$HOME/.steam/steam/SteamApps/common")
    for f in ${steam_def_folders[*]}
    do
        if [ -d "$f/Supreme Commander Forged Alliance" ]
        then
            echo "$f/Supreme Commander Forged Alliance"
            return 0
        fi
    done
    return 1 # no folder found
}

function extract_fa_path {
    # Tries to find the FA install dir from $1
    # in case the user selects the SupCom dir directly
    # Echoes the full path of the installed dir if found
    # Echoes "" if not
    child_path="steamapps/common/Supreme Commander Forged Alliance"
    tmp_path=$1
    while [ ! -d "$tmp_path/$child_path" ]
    do
        if [ "$tmp_path" = "/" ] || [ "$tmp_path" = "" ]
        then
            to_log "Warning -- FA install dir not found"
            break
        else
            tmp_path=$(dirname "$tmp_path")
        fi
    done
    if [ -d "$tmp_path/$child_path" ]
    then
        echo "$tmp_path/$child_path"
        return 0
    else
        echo ""
        return 1
    fi
}

wait_for_steam_install() {
    no_steam=true
    printf "waiting for steam to finish installing... "
    while ! command -v steam &>/dev/null; do
        spin
        sleep 1
    done
    return 0
}

function run_fa_script {
    # $@ - extra arguments to pass to the script
    wait_for_steam_install
    if [ ! -f $work_dir/install_FA_script.sh ]; then
        wget https://raw.githubusercontent.com/tatsujb/installFAFscript/master/install_FA_script.sh \
             -O $work_dir/install_FA_script.sh
    fi
    chmod +x $work_dir/install_FA_script.sh
    # TODO Couldn't the closing line be given as an extra command when passing args to the terminal?
    # Example $gxtpath [ run fa_script ] ; $gxtpath $gxtoptions $gxttitle '(FAF)' $gxtexec $HOME/faf/downlords-faf-client
    # isn't downlords-faf-client supposed to be launched as just a normal binary though?
    _default_args=""
    $gxtpath $gxtoptions $gxttitle "install & run steam, steamcmd and FA" \
             $gxtexec $work_dir/install_FA_script.sh \
             -l $faf_log \
             -u $real_user \
             --faf_path "$faf_path" \
             $@
}


function get_user_input_function {
    # $1 : (optional) path to a supcom install directory

fa_path=$(extract_fa_path "$fa_path")
if [ "$(extract_fa_path $1)" = "" ] && [ "$fa_path" = "" ]; then
    fa_path="$(auto_detect_fa_path)"
elif [ "$fa_path" = "" ]; then
    fa_path="$(extract_fa_path "$1")"
fi
if [ -d "$fa_path" ]
then
    what_to_do=$(whiptail --title "Supreme Commander Forged Alliance (FA)" \
        --menu "$error_msg The game's install directory has been detected at $fa_path.\nBefore installing the FAF client, would you like to " 16 60 0 \
        "configure_fa"  "Configure the game for use with FAF, then install FAF" \
        "choose_fa_dir" "Choose an other game install directory (or correct it)" \
        "install_fa"    "Make a 2nd install of FA somewhere else & install FAF" \
        "reinstall_fa"  "Reinstall the game through steam (needs steam login)" \
        "install_faf"   "Skip the FA configuration and ONLY install FAF" \
        --notags --nocancel 3>&1 1>&2 2>&3)
else
    what_to_do=$(whiptail --title "Install Forged Alliance Forever (Multiplayer client)" \
        --menu "$error_msg The Supreme Commander Forged Alliance (FA) install directory wasn't automatically detected.\nWould you like to " 10 80 0 \
        "install_fa"    "Install the Forged Alliance game through steam (needs your steam login)" \
        "choose_fa_dir" "Browse for the Forged Alliance game install directory" \
        "install_faf"   "Skip the installation/configuration of FA and ONLY install the FAF client" \
        --notags --nocancel 3>&1 1>&2 2>&3)
fi
case $what_to_do in
    configure_fa)
        to_log "configure current FA install"
        run_fa_script --already-fa \
                      --fa_base_dir "$fa_path" &
        sleep 1
        ;;
    install_fa)
        to_log "install FA"
        _fa_path="$(set_fa_path)"
        to_log "FA install path set to : $_fa_path"
        if [ "$_fa_path" = "" ]; then
             get_user_input "$fa_path"; return 0
        fi
        run_fa_script --install-fa \
                      --fa_base_dir "$_fa_path" &
        sleep 1
        ;;
    choose_fa_dir)
        _fa_path="$(set_fa_path)"
        to_log "FA install path set to : $_fa_path"
        get_user_input "$_fa_path"
        return;;# stops recursion loop from running the rest of this function
    reinstall_fa)
        to_log "reinstall FA chosen"
        if (whiptail --title "Are you sure you want to delete $fa_path ?"\
                     --yesno "" 12 85 --fb); then
            echo "Removing $fa_path"
            rm -rf "$fa_path"
            _fa_path="$(set_fa_path)"
            to_log "FA install path set to : $_fa_path"
            run_fa_script --install-fa \
                          --fa_base_dir "$_fa_path" &
            sleep 1
        else
            to_log "Cancels deletion of previous install."
            get_user_input "$fa_path"
            return
        fi;;
    install_faf)
        to_log "Skipping to install FAF without configuring FA"
        install_faf_function
        echo "installed faf only, as per user demand, nothing else to do, exiting."
        exit 0;;
    *)
        to_log "Err -- Unexpected Whiptail tag provided : $what_to_do"
        echo "An error has occured. For support, please provide the logfile"
        exit 1;;
esac
}

get_user_input_function

to_log "start of second thread did not crash first thread"

install_faf_function

to_log "$(mv "$work_dir"/faf/* "$faf_path" && echo did || echo didnt) " \
       "successfully move faf dir"

# wait for user to log in
to_log "waiting for user to log into FAF"
printf '
Please switch to opened FAF client.

If FAF is not open yet, please switch to the terminal tab named "install & run steam, steamcmd, FA"

Waiting on user to log in... '
no_login=true
while ! grep --no-messages '"username": "' "$faf_config_dir/client.prefs" 1>/dev/null
do
    spin
    sleep 1
done
echo -e "\nRestarting (FAF)"
to_log "done waiting"
kill -9 "$(pgrep java | tail -1)"
# editting client.prefs :
to_log "editing client.prefs"

# TODO installation_path=$fa_path, unless there is a default install :)

fa_path="$(tail -n 1 $installFAtmpfile)"
compatdata="$(tail -n 3 $installFAtmpfile | head -n 1)"
preferences_file="$compatdata/Local Settings/Application Data/Gas Powered Games/Supreme Commander Forged Alliance/Game.prefs"
user_path="$faf_path/run %s"

jq --arg fa_path "$fa_path"\
   --arg preferences_file "$preferences_file"\
   --arg user_path "$user_path" '
    .forgedAlliance += {
        installationPath: ($fa_path),
        path: ($fa_path),
        preferencesFile: ($preferences_file),
        executableDecorator: ($user_path)
    }' "$faf_config_dir/client.prefs" > "$faf_config_dir/client.prefs.tmp"
mv "$faf_config_dir/client.prefs.tmp" "$faf_config_dir/client.prefs"
if command -v "gtk-launch"; then
    gtk-launch faforever
else
    $faf_path/downlords-faf-client
fi
echo "Finished thread one (proton/downlord/open-jdk/bashrc) without issue..."
to_log "Finished thread one. (proton/downlord/open-jdk/bashrc)"
