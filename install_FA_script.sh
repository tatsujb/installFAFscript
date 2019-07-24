#!/bin/bash

VERBOSE=false
DEBUG=false
already_fa=false
faf_log_file=""
operating_system=""
real_user=""
default_dir=""
fa_base_dir=""

TEMP=`getopt -o vDfm:l:u:d:o: --long verbose,debug,logfile: \
             -n "$0" -- "$@"`

if [ $? != 0 ] ; then echo " Terminating..." >&2 ; exit 1 ; fi
eval set -- "$TEMP"
while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -D | --debug ) DEBUG=true; shift ;;
    --default_dir ) default_dir=true; shift ;;
    -f | --already_fa ) already_fa=true; shift ;;
    -l | --logfile ) faf_log_file=$2; shift 2 ;;
    -o | --operating_system ) operating_system=$2; shift 2 ;;
    -u | --real_user ) real_user=$2; shift 2 ;;
    --fa_base_dir ) fa_base_dir=$2; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

to_log()
{
     echo -e "[$(date --rfc-3339=seconds)] $@" >> $faf_log_file
}

to_log "####################T3 install FA script####################"
to_log "T3  --verbose $VERBOSE"
to_log "T3  --debug $DEBUG"
to_log "T3  --default_dir $default_dir"
to_log "T3  --already_fa $already_fa"
to_log "T3  --logfile $faf_log_file"
to_log "T3  --operating_system $operating_system"
to_log "T3  --real_user $real_user"
to_log "T3  --fa_base_dir $fa_base_dir"

if $default_dir
then
    origin="$HOME/.steam/steam"
else
    origin=$fa_base_dir
fi

bind 'TAB: accept-line' &>/dev/null
while [ -z "$steam_user_name" ]
do
    echo "steam user name :"
    IFS= read -e -r steam_user_name
done
while [ -z "$steam_password" ]
do
    echo "steam password :"
    IFS= read -e -r -s steam_password
done

# NOTE THAT THIS IS NOT MY IDEAL SOLUTION BUT I HAVENT YET FOUND BETTER
to_log "T1 Steam credentials entrusted to script"
if [ ! -f $HOME/the\ contents\ of\ this* ]
then
echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1 %command%' > $HOME/"the contents of this file are to be pasted in the forged alliance properties launch options"
fi

echo "expecting you to type in Forged Alliances Launch options"
echo "reminder : look in your home folder, theres a file there with the contents to be pasted"
echo "once thats done edit steam settings in order to enable Proton for all games"
if $already_fa
then
    echo ""
else
    echo -e "\n\n\n"
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
        while [ ! -d $fa_base_dir/bin ]
        do
            steamcmd +login $steam_user_name $steam_password +@sSteamCmdForcePlatformType windows +force_install_dir $fa_base_dir +app_update 9420 +quit
        done
        cd $fa_base_dir
        mkdir -p steamapps/common/Supreme\ Commander\ Forged\ Alliance
        mv * steamapps/common/Supreme\ Commander\ Forged\ Alliance/ 2>/dev/null
        cd
    fi
    to_log "T3 FA installed condition met"
fi
to_log "T3 launching FA"
steam -login $steam_user_name $steam_password -applaunch 9420 &>/dev/null &
echo -e "\n\n\n\n\nWaiting for Forged Alliance to be run, Game.prefs to exist"
echo "and for Forged Alliance to be shut down."
echo "You may also type \"c\" (and enter/return) to exit this loop"
echo "if you feel the conditions for continuing sucessfully"
echo -n "have already been adequately met... "
i=1
sp='/-\|'
no_config=true
while $no_config
do
    printf "\b${sp:i++%${#sp}:1}";
    if [ \( ! "$(pidof SupremeCommande)" \) -a \
	 \( -f $origin/steamapps/compatdata/9420/pfx/drive_c/users/steamuser/Local\ Settings/Application\ Data/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Game.prefs \) ] || \
       [ "$typed_continue" = "c" ]
    then
        no_config=false
    fi
    sleep 1
    read -s -r -t 1 typed_continue
done
echo ""
if ! $already_fa
then
    to_log "T3 copying over run file"
    cp -f /tmp/proton_"$real_user"/run $HOME/faf/
fi
to_log "T3 making symbolic links"

steamapps_list=("steamapps" "SteamApps")

for steamapps in $steamapps_list
do
    # It should always be possible to find this folder
    [ -d "$origin/$steamapps/common/$supcom"  ] && \
    fa_install_dir="$origin/$steamapps/common/$supcom"
    [ -d "$origin/$steamapps/compatdata/9420/pfx/drive_c/users/steamuser" ] && \
    compatdata="$origin/$steamapps/compatdata/9420/pfx/drive_c/users/steamuser" && \
    break
done
[ "$compatdata" = "" ] && \
    to_log "T3 neither steamapps nor SteamApps compatdata was found. exiting" && \
    exit 1

cd "$fa_install_dir"
rm -rf Maps
rm -rf Mods
ln -s $HOME/My\ Games/Gas\ Powered\ Games/$supcom/Maps/ Maps
ln -s $HOME/My\ Games/Gas\ Powered\ Games/$supcom/Mods/ Mods

cd "$compatdata"
rm -rf My\ Documents
mkdir My\ Documents
cd My\ Documents
ln -s $HOME/My\ Games/ My\ Games

cd
source .bashrc
eval "$(cat .bashrc | tail -n +10)"
echo "FA installation finished succesfully"
to_log "T3 starting T4 and exiting T3"
