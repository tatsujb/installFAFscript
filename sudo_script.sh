#!/bin/bash

VERBOSE=false
DEBUG=false
logfile="/tmp/faf.sh.log"
operating_system="Ubuntu"
tmp_sudo=will_sudo_this.sh

parse=$(getopt -o hvDfl:o: \
               --long help,verbose,debug,logfile:,operating_system: \
               -n "$0" -- "$@")

if [ $parse != 0 ] ; then echo " Terminating..." >&2 ; exit 1 ; fi
eval set -- "$parse"
while true; do
  case "$1" in
    -h | --help )
      echo "$0 [OPTIONS] package [package ...]"
      echo "OPTIONS"
      echo "  -h, --help             Display this message and exit"
      echo "  -v, --verbose          enable verbose output"
      echo "  -D, --debug            enable the DEBUG symbol"
      echo "  -l, --logfile          location of the logfile (default: $logfile)"
      echo "  -o, --operating_system OS for which to install the packages for (default : $operating_system)"
      exit 1;;
    -v | --verbose ) VERBOSE=true; shift ;;
    -D | --debug ) DEBUG=true; shift ;;
    -l | --logfile ) logfile=$2; shift 2 ;;
    -o | --operating_system ) operating_system=$2; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
to_be_installed=$*

to_log() { echo -e "[$(date --rfc-3339=seconds)] T2 $*" >> "$logfile"; }

sudolog() {
    echo "$@" >> "$tmp_sudo"
}

rm ./$tmp_sudo

to_log "#################### sudo (install X packages) script ####################"
to_log " --verbose $VERBOSE"
to_log " --debug $DEBUG"
to_log " --logfile $logfile"
to_log " --operating_system $operating_system"

to_log "preparing installs - checking sources & misc."
case "$operating_system" in
    Debian*)
        if grep -q "debian.org/debian/ stretch main contrib non-free" /etc/apt/sources.list > /dev/null
        then
            to_log "editing debian sources : stretch already correct"
        else
            to_log "editing debian sources : stretch edited"
            sudolog "sed -i \"s_debian.org/debian/ stretch main contrib_debian.org/debian/ stretch main contrib non-free_\" /etc/apt/sources.list"
        fi
        if grep -q "http://security.debian.org/debian-security stretch/updates main contrib non-free" /etc/apt/sources.list > /dev/null
        then
            to_log "editing debian sources : stretch/updates already correct"
        else
            to_log "editing debian sources : stretch/updates edited"
            sudolog "sed -i \"s_http://security.debian.org/debian-security stretch/updates main contrib_http://security.debian.org/debian-security stretch/updates main contrib non-free_\" /etc/apt/sources.list"
        fi
        if grep -q "debian.org/debian/ stretch-updates main contrib non-free" /etc/apt/sources.list > /dev/null
        then
            to_log "editing debian sources : stretch-updates already correct"
        else
            to_log "editing debian sources : stretch-updates edited"
            sudolog "sed -i \"s_debian.org/debian/ stretch-updates main contrib_debian.org/debian/ stretch-updates main contrib non-free_\" /etc/apt/sources.list"
        fi
        if grep -q "deb http://ftp.*.debian.org/debian/ stretch-proposed-updates main contrib non-free" /etc/apt/sources.list > /dev/null
        then
            to_log "editing debian sources : proposed already present"
        else
            download_country=$(grep "deb http://ftp." /etc/apt/sources.list | head -1 | cut -d. -f2)
            to_log "editing debian sources : added proposed"
            sudolog "echo \"deb http://ftp.$download_country.debian.org/debian/ stretch-proposed-updates main contrib non-free\" >> /etc/apt/sources.list"
        fi
        if grep -Fxq "# deb http://archive.canonical.com/ubuntu cosmic partner" /etc/apt/sources.list
        then
            to_log "enabled partners"
            sudolog "sed -i \"s/# deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/g\" /etc/apt/sources.list"
        else
            to_log "did not enable partners, hoping it was already enabled."
        fi
        ;;
    *);;
esac
if [ ! -z "$to_be_installed" ]; then
    to_log "begining install of $to_be_installed"
    case "$operating_system" in
        Arch* | Manjaro* | Antergos*)
            sudolog pacman -Syu --noconfirm
            sudolog pacman -Syy --noconfirm
            sudolog pacman -Scc --noconfirm
            sudolog pacman -Suu --noconfirm
            sudolog pacman -S --noconfirm $to_be_installed;;
        Fedora* | Mageia*)
            sudolog dnf distro-sync -y
            sudolog dnf install -y $to_be_installed
            sudolog dnf clean all -y
            sudolog dnf autoremove -y;;
        CentOS*)
            sudolog yum -y upgrade
            sudolog yum -y install $to_be_installed
            sudolog yum -y clean all;;
        Ubuntu* | Debian* | *)
            sudolog apt update -y
            sudolog apt full-upgrade -y
            sudolog apt install -y $to_be_installed
            sudolog apt autoremove -y
            sudolog apt autoclean;;
    esac
fi
to_log "post-install - Configurations"

case "$operating_system" in
    Ubuntu*)
        for _s in "steam" "steamcmd"
        do
            if [ ! $(command -v $_s) ]
            then
                sudolog "echo $_s steam/question select \"I AGREE\" | sudo debconf-set-selections"
                sudolog "echo $_s steam/license note '' | sudo debconf-set-selections"
            fi
        done;;
    Debian*)
        sudolog usermod -a -G video,audio "$(logname)"
        sudolog dpkg --add-architecture i386
        if   echo $to_be_installed | grep steamcmd >/dev/null \
          && getent passwd steam &>/dev/null
        then
            echo "steam home already exists"
        else
            sudolog useradd -m steam
            sudolog ln -s /usr/games/steamcmd /home/steam/steamcmd
        fi;;
esac

if [ ! -f ./$tmp_sudo ]; then
    to_log "No sudo commands need to be run :)"
    to_log "---- Exiting ----"
    exit 0
fi

echo 'If you wish for this script to be able to do its task
you must elevate it to sudo and it will install the needed
dependencies.

Fortunately all sudo commands have been centralized to this
one window and you can know ahead of time all the sudo
commands that will be run. At your own discretion, you may
copy them, exit the script by closing all the terminal
windows and execute them yourself.

This window should not appear if you choose to run the
install script again.

If you trust the script, you may type in your password and
this script will install all the needed dependencies.

Pending ROOT priveledges, this windows will run the following
commands as ROOT user:
'

cat $tmp_sudo

echo '
If you wish to cancel installing the dependencies or run
the commands yourself, please press Ctrl+C without
entering your password
'

sudo bash ./$tmp_sudo && \
    rm ./$tmp_sudo && \
    to_log "finished succesfully"
