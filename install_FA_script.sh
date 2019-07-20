faf_log_file=$1
operating_system=$2
real_user=$3
steam_user_name=$4
steam_password=$5
already_fa=$6
default_dir=$7
directory=$8

to_log() { echo "[$(date --rfc-3339=seconds)] $@" >> $faf_log_file }
echo "expecting you to type in Forged Alliances Launch options"
echo "reminder : look in your home folder, theres a file there with the contents to be pasted"
echo "once thats done edit steam settings in order to enable Proton for all games"
if $already_fa
then
    echo ""
else
    echo ""
    echo ""
    echo ""
    to_log "T3 running steam" 
    steam -login $steam_user_name $steam_password
    rm $HOME/the\ contents\ of\ this*
    if $default_dir
    then
        to_log "T3 installing FA to default dir" 
        while [ \( ! -d $HOME/.steam/steam/steamapps/common/Supreme* \) -a \( ! -d $HOME/.steam/steam/SteamApps/common/Supreme* \) ]
        do
            steamcmd +login $steam_user_name $steam_password +@sSteamCmdForcePlatformType windows +app_update 9420 +quit
        done
    else
        to_log "T3 installing FA to custom dir" 
        while [ ! -d $directory/bin ]
        do
            steamcmd +login $steam_user_name $steam_password +@sSteamCmdForcePlatformType windows +force_install_dir $directory +app_update 9420 +quit
        done
        cd $directory
        mkdir -p steamapps/common/Supreme\ Commander\ Forged\ Alliance
        mv * steamapps/common/Supreme\ Commander\ Forged\ Alliance/ 2>/dev/null
        cd
    fi
    to_log "T3 FA installed condition met" 
fi
if $default_dir
then
    origin="$HOME/.steam/steam"
else
    origin=$directory
fi
to_log "T3 launching FA" 
steam -login $steam_user_name $steam_password -applaunch 9420 &>/dev/null &
echo ""
echo ""
echo ""
echo ""
echo ""
echo "Waiting for Forged Alliance to be installed, Game.prefs to exits"
echo -n "and for Forged Alliance to be shut down."
#echo "You may also type \"c\" and enter to exit this loop"
#echo "if you feel the conditions for continuing sucessfully"
#echo -n "have already been adequately met... "
i=1
sp='/-\|'
no_config=true
while $no_config
do
    printf "\b${sp:i++%${#sp}:1}";
    if [ \( \( ! "$(pidof SupremeCommande)" \) -a \( -f $origin/steamapps/compatdata/9420/pfx/drive_c/users/steamuser/Local\ Settings/Application\ Data/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Game.prefs \) \) -o \( "$typed_continue" = "c" \) ]
    then
        no_config=false
    fi
    sleep 1
    #read -s -r -t 1 typed_continue
done
echo ""
if $already_fa
then
    echo
else
    to_log "T3 copying over run file" 
    cp -f /tmp/proton_'$real_user'/run $HOME/faf/
fi
to_log "T3 making symbolic links" 
if $default_dir
then
    if [ -d $HOME/.steam/steam/steamapps ]
    then
        if [ -d $HOME/.steam/steam/steamapps/common/Supreme* ]
        then
            cd $HOME/.steam/steam/steamapps/common/Supreme\ Commander\ Forged\ Alliance
            rm -rf Maps
            rm -rf Mods
            ln -s $HOME/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps
            ln -s $HOME/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods
        else
            to_log "T3 steamapps FA folder not found" 
        fi
        if [ -d $HOME/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser ]
        then
            cd $HOME/.steam/steam/steamapps/compatdata/9420/pfx/drive_c/users/steamuser
            rm -rf My\ Documents
            mkdir My\ Documents
            cd My\ Documents
            ln -s $HOME/My\ Games/ My\ Games
        else
            to_log "T3 steamapps FA compatdata folder not found" 
        fi
    elif [ -d $HOME/.steam/steam/SteamApps ]
    then
        to_log "T3 curious case of SteamApps instead of steamapps" 
        if [ -d $HOME/.steam/steam/SteamApps/common/Supreme* ]
        then
            cd $HOME/.steam/steam/SteamApps/common/Supreme\ Commander\ Forged\ Alliance
            rm -rf Maps
            rm -rf Mods
            ln -s $HOME/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps
            ln -s $HOME/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods
        else
            to_log "T3 SteamApps FA folder not found" 
        fi
        if [ -d $HOME/.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser ]
        then
            cd $HOME.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser
            rm -rf My\ Documents
            mkdir My\ Documents
            cd My\ Documents
            ln -s $HOME/My\ Games/ My\ Games
        else
            to_log "T3 SteamApps FA compatdata folder not found" 
        fi
    else
        to_log "T3 neither steamapps nor SteamApps are found. exiting" 
        exit 1
    fi
else
    to_log "T3 symlinking for non-standart install location" 
    cd $directory/steamapps/common/Supreme\ Commander\ Forged\ Alliance
    rm -rf Maps
    rm -rf Mods
    ln -s $HOME/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Maps/ Maps
    ln -s $HOME/My\ Games/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Mods/ Mods
    if [ -d $HOME/.steam/steam/steamapps ]
    then
        if [ -d $directory/steamapps/compatdata/9420/pfx/drive_c/users/steamuser ]
        then
            cd $directory/steamapps/compatdata/9420/pfx/drive_c/users/steamuser
            rm -rf My\ Documents
            mkdir My\ Documents
            cd My\ Documents
            ln -s $HOME/My\ Games/ My\ Games
        fi
    elif [ -d $HOME/.steam/steam/SteamApps ]
    then
        if [ -d $HOME/.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser ]
        then
            cd $HOME/.steam/steam/SteamApps/compatdata/9420/pfx/drive_c/users/steamuser
            rm -rf My\ Documents
            mkdir My\ Documents
            cd My\ Documents
            ln -s $HOME/My\ Games/ My\ Games
        fi
    fi
fi
cd
source .bashrc
eval "$(cat .bashrc | tail -n +10)"
echo "FA installation finished succesfully"
to_log "T3 starting T4 and exiting T3" 
