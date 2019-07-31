#!/bin/bash

VERBOSE=false
DEBUG=false
already_fa=false
faf_log_file=""
operating_system=""
real_user=""
default_dir=""
fa_base_dir=""
supcom="Supreme Commander Forged Alliance"


parse=$(getopt -o vDfm:l:u:d:o: --long verbose,debug,logfile: \
               -n "$0" -- "$@")

if [ $parse != 0 ]; then echo " Terminating..." >&2 ; exit 1 ; fi
eval set -- "$parse"
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
    --faf_path ) faf_path=$2; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

to_log() { echo -e "[$(date --rfc-3339=seconds)] T3 $*" >> "$faf_log_file"; }

to_log "#################### install FA script ####################"
to_log " --verbose $VERBOSE"
to_log " --debug $DEBUG"
to_log " --default_dir $default_dir"
to_log " --already_fa $already_fa"
to_log " --logfile $faf_log_file"
to_log " --operating_system $operating_system"
to_log " --real_user $real_user"
to_log " --fa_base_dir $fa_base_dir"

if $default_dir
then
    origin="$HOME/.steam/steam"
else
    origin=$fa_base_dir
fi

for _steamapps in "steamapps" "SteamApps"; do
    [ -d "$HOME/$_steamapps/.steam/steam/$steamapps" ] && \
    steamapps=$_steamapps
    break
done
[ "$steamapps" = "" ] && \
    to_log "neither steamapps nor SteamApps was found. exiting" && \
    exit 1

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
to_log "Steam credentials entrusted to script"
launch_options_file="$HOME/Paste this into the Forged Alliance steam launch options"
if [ ! -f "$launch_options_file" ]
then
echo 'PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1 %command%' > "$launch_options_file"
fi

echo "expecting you to type in Forged Alliances Launch options"
echo "reminder : look in your home folder, theres a file there with the contents to be pasted"
echo "once thats done edit steam settings in order to enable Proton for all games"

if $already_fa
then
    echo ""
else
    echo -e "\n\n\n"
    to_log "running steam"
    steam -login "$steam_user_name" "$steam_password"
    rm "$launch_options_file"
    if $default_dir
    then
        to_log "installing FA to default dir"
        while [ ! -d "$HOME/.steam/steam/$steamapps/common/$supcom" ]
        do
            steamcmd +login "$steam_user_name" "$steam_password" +@sSteamCmdForcePlatformType windows +app_update 9420 +quit
        done
    else
        to_log "installing FA to custom dir"
        while [ ! -d "$fa_base_dir/bin" ]
        do
            steamcmd +login "$steam_user_name" "$steam_password" +@sSteamCmdForcePlatformType windows +force_install_dir "$fa_base_dir" +app_update 9420 +quit
        done
        mkdir -p "$fa_base_dir/steamapps/common/$supcom"
        mv "$fa_base_dir/*" "$fa_base_dir/steamapps/common/$supcom" 2>/dev/null
    fi
    to_log "FA installed condition met"
fi
to_log "launching FA"
steam -login "$steam_user_name" "$steam_password" -applaunch 9420 &>/dev/null &
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
    if { [ ! "$(pidof SupremeCommande)" ] && \
         [ -f "$compatdata/Local Settings/Application Data/Gas Powered Games/$supcom/Game.prefs" ]; } || \
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
    to_log "copying over run file"
    cp -f "/tmp/proton_$real_user/run" "$faf_path"
fi
to_log "making symbolic links"

for _steamapps in "steamapps" "SteamApps"; do
    [ -d "$origin/$steamapps/common/$supcom"  ] && \
        export fa_install_dir="$origin/$steamapps/common/$supcom"
    [ -d "$origin/$_steamapps/compatdata/9420/pfx/drive_c/users/steamuser" ] && \
    export compatdata="$origin/$_steamapps/compatdata/9420/pfx/drive_c/users/steamuser" && \
    break
done
[ "$compatdata" = "" ] && \
    to_log "neither steamapps nor SteamApps compatdata was found. exiting" && \
    exit 1

rm -rf "$fa_install_dir/{Maps,Mods}"
ln -s "$HOME/My Games/Gas Powered Games/$supcom/Maps/" "$fa_install_dir/Maps"
ln -s "$HOME/My Games/Gas Powered Games/$supcom/Mods/" "$fa_install_dir/Mods"

mkdir -p "$compatdata/My Documents" || \
    rm -rf "$compatdata/My Documents/*"
ln -s "$HOME/My Games/" "$compatdata/My Documents/My Games"


echo "FA installation finished succesfully"
to_log "starting T4 and exiting T3"
