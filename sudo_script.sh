#!/bin/bash

VERBOSE=false
DEBUG=false
faf_log_file="/tmp/faf.log"
operating_system="Ubuntu"


TEMP=`getopt -o hvDfl:o: --long help,verbose,debug,logfile:,operating_system: \
             -n "$0" -- "$@"`

if [ $? != 0 ] ; then echo " Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"
while true; do
  case "$1" in
    -h | --help )
      echo "$0 [OPTIONS] package [package ...]"
      echo "OPTIONS"
      echo "  -h, --help             Display this message and exit"
      echo "  -v, --verbose          enable verbose output"
      echo "  -D, --debug            enable the DEBUG symbol"
      echo "  -l, --logfile          location of the logfile"
      echo "  -o, --operating_system Operating system to install the packages for (default : Ubuntu)"
      exit 1;;
    -v | --verbose ) VERBOSE=true; shift ;;
    -D | --debug ) DEBUG=true; shift ;;
    -l | --logfile ) faf_log_file=$2; shift 2 ;;
    -o | --operating_system ) operating_system=$2; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
to_be_installed=$@

to_log() { echo -e "[$(date --rfc-3339=seconds)] $*" >> "$faf_log_file"; }

to_log "####################\nT2 sudo (install X packages) script\n####################"
to_log "  --verbose $VERBOSE"
to_log "  --debug $DEBUG"
to_log "  --logfile $faf_log_file"
to_log "  --operating_system $operating_system"

echo "If you wish for this script to be able to do its task you must elevate it to sudo and it will install the needed dependencies."
echo "Fortunately all sudo commands have been centralized to this one window and you can know ahead of time all the sudo commands that will be run."
echo "At your own discretion, you may copy them, exit the script by closing all the terminal windows and execute them yourself."
echo "Upon re-runing the script this window should not appear and you should not be prompted for sudo priveledges."
echo ""
echo "However, if you trust the script, you may simply type in your admin password and this script will continue."
echo ""
echo "Pending obtaning sudo priveledges, this windows will run the following :"
echo ""
_short_os=$(echo "$operating_system" | cut -c -4)
echo -e "$(grep -A 10 "$_short_os.*\*" $0 | \
	grep -v "$_short_os.*\*" | \
           awk '{if ($0 ~ / {8}.*/) {print $0;}
                 else {exit;}
                }' | \
           sed "s/\$to_be_installed/$to_be_installed/" | \
	   sed 's/^ */  /')"

echo ""
sudo echo ""
to_log "T2 preparing installs - checking sources & misc."
case "$operating_system" in
    Zorin*) 
        for $_s in "steam" "steamcmd"
        do
            if [ ! $(command -v $_s) ]
	    then
                echo $_s steam/question select "I AGREE" | sudo debconf-set-selections
                echo $_s steam/license note '' | sudo debconf-set-selections
	    fi
	done;;
    Debian*)
        if grep -q "debian.org/debian/ stretch main contrib non-free" /etc/apt/sources.list > /dev/null
        then
            to_log "T2 editing debian sources : stretch already correct"
        else
            to_log "T2 editing debian sources : stretch edited"
            sed -i "s_debian.org/debian/ stretch main contrib_debian.org/debian/ stretch main contrib non-free_" /etc/apt/sources.list
        fi
        if grep -q "http://security.debian.org/debian-security stretch/updates main contrib non-free" /etc/apt/sources.list > /dev/null
        then
            to_log "T2 editing debian sources : stretch/updates already correct"
        else
            to_log "T2 editing debian sources : stretch/updates edited"
            sed -i "s_http://security.debian.org/debian-security stretch/updates main contrib_http://security.debian.org/debian-security stretch/updates main contrib non-free_" /etc/apt/sources.list
        fi
        if grep -q "debian.org/debian/ stretch-updates main contrib non-free" /etc/apt/sources.list > /dev/null
        then
            to_log "T2 editing debian sources : stretch-updates already correct"
        else
            to_log "T2 editing debian sources : stretch-updates edited"
            sed -i "s_debian.org/debian/ stretch-updates main contrib_debian.org/debian/ stretch-updates main contrib non-free_" /etc/apt/sources.list
        fi
        if grep -q "deb http://ftp.*.debian.org/debian/ stretch-proposed-updates main contrib non-free" /etc/apt/sources.list > /dev/null
        then
            to_log "T2 editing debian sources : proposed already present"
        else
            donwload_country=$(grep "deb http://ftp." /etc/apt/sources.list | head -1 | cut -d. -f2)
            to_log "T1 editing debian sources : added proposed"
            echo "deb http://ftp.$donwload_country.debian.org/debian/ stretch-proposed-updates main contrib non-free" >> /etc/apt/sources.list
        fi
        if grep -Fxq "# deb http://archive.canonical.com/ubuntu cosmic partner" /etc/apt/sources.list
        then
            to_log "T2 enabled partners"
            sudo sed -i "s/# deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/g" /etc/apt/sources.list
        else
            to_log "T2 did not enable partners, hoping it was already enabled."
        fi;;
    *);;
esac

to_log "T2 begining install of $to_be_installed"
case "$operating_system" in
    Arch* | Manjaro* | Antergos*)
        sudo pacman -Syu --noconfirm
        sudo pacman -Syy --noconfirm
        sudo pacman -Scc --noconfirm
        sudo pacman -Suu --noconfirm
        sudo pacman -S --noconfirm $to_be_installed;;
    Fedora* | Mageia*)
        sudo dnf distro-sync -y
        sudo dnf install -y $to_be_installed
        sudo dnf clean all -y
        sudo dnf autoremove -y;;
    CentOS*)
        sudo yum -y upgrade
        sudo yum -y install $to_be_installed
        sudo yum -y clean all;;
    Ubuntu* | *)
        sudo apt update -y
        sudo apt full-upgrade -y
        [ "$operating_system" = "Debian GNU/Linux" ] && sudo /usr/sbin/usermod -a -G video,audio $real_user
        [ "$operating_system" = "Debian GNU/Linux" ] && sudo dpkg --add-architecture i386
        sudo apt install -y $to_be_installed
        sudo apt autoremove -y
        sudo apt autoclean;;
esac
to_log "T2 finished succesfully"
