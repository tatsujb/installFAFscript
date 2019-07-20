faf_log_file=$1
operating_system=$2
to_be_installed=$3
if [ ! operating_system ]
then 
    operating_system="Ubuntu"
fi

to_log() { echo "[$(date --rfc-3339=seconds)] $@" >> $faf_log_file }

echo "If you wish for this script to be able to do its task you must elevate it to sudo and it will install the needed dependencies."
echo "Fortunately all sudo commands have been centralized to this one window and you can know ahead of time all the sudo commands that will be run."
echo "At your own discretion, you may copy them, exit the script by closing all the terminal windows and execute them yourself."
echo "Upon re-runing the script this window should not appear and you should not be prompted for sudo priveledges."
echo ""
echo "However, if you trust the script, you may simply type in your admin password and this script will continue."
echo ""
echo "Pending obtaning sudo priveledges, this windows will run the following :"
echo ""
echo "sudo apt update -y &&"
echo "sudo apt full-upgrade -y &&"
echo "sudo apt install -y $to_be_installed &&"
echo "sudo apt autoremove -y &&"
echo "sudo apt autoclean"
echo ""
sudo echo ""
to_log "T2 begining install of$to_be_installed" 
if [ ! $(command -v steam) ]
then
    if [ "$operating_system" != "Zorin OS" ]
    then
        echo steam steam/question select "I AGREE" | sudo debconf-set-selections
        echo steam steam/license note '' | sudo debconf-set-selections
    fi
fi
if [ ! $(command -v steamcmd) ]
then
    if [ "$operating_system" != "Zorin OS" ]
    then
        echo steamcmd steam/question select "I AGREE" | sudo debconf-set-selections
        echo steamcmd steam/license note '' | sudo debconf-set-selections
    fi
fi
if [ "$operating_system" = "Debian GNU/Linux" ]
then
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
    else if grep -Fxq "# deb http://archive.canonical.com/ubuntu cosmic partner" /etc/apt/sources.list
    then
        to_log "T2 enabled partners" 
        sudo sed -i "s/# deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/deb http:\/\/archive.canonical.com\/ubuntu cosmic partner/g" /etc/apt/sources.list
    else
        to_log "T2 did not enable partners, hoping it was already enabled." 
    fi
fi
if [ \( "$operating_system" = "Arch"\) -o \( "$operating_system" = "Manjaro" \) ]
then
    sudo pacman -Syu
    sudo pacman -Syy
    sudo pacman -Scc
    sudo pacman -Suu
    sudo pacman -S$to_be_installed
elif [ "$operating_system" = "Fedora" ]
then
    sudo dnf distro-sync
    sudo dnf install -y$to_be_installed
    sudo dnf clean all
    sudo dnf autoremove
elif [ "$operating_system" = "Mageia" ]
then
    sudo dnf distro-sync
    sudo dnf install -y$to_be_installed
    sudo dnf clean all
    sudo dnf autoremove
elif [ "$operating_system" = "CentOS" ]
then
    sudo yum upgrade
    sudo yum install -y$to_be_installed
    sudo yum clean all
else
    sudo apt update -y
    sudo apt full-upgrade -y
    [ "$operating_system" = "Debian GNU/Linux" ] && sudo /usr/sbin/usermod -a -G video,audio $real_user
    [ "$operating_system" = "Debian GNU/Linux" ] && sudo dpkg --add-architecture i386
    sudo apt install -y$to_be_installed
    sudo apt autoremove -y
    sudo apt autoclean
fi
to_log "T2 finished succesfully" 
