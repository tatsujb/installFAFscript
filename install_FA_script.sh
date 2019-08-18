#!/bin/bash

VERBOSE=false
DEBUG=false
already_fa=false
faf_log_file=""
tmpfile="./tmpInstallFA"
real_user=""
default_dir=""
fa_path=""
supcom="Supreme Commander Forged Alliance"

parse=$(getopt -o vDf:i:m:l:u:d: \
               --long verbose,debug,already-fa:,install-fa:,logfile:,fa_path:,faf_path:,real_user:\
               -n "$0" -- "$@")
while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true; shift ;;
    -D | --debug )   DEBUG=true; shift ;;
    --default_dir )  default_dir=true; 
                     fa_path="default"; shift ;;
    -f | --already-fa | --fa_path ) already_fa=true;
                                    fa_path="$2"; shift 2 ;;
    -i | --install-fa ) already_fa=false; 
                        install_fa_path="$2"; shift 2 ;;
    -l | --logfile ) faf_log_file="$2"; shift 2 ;;
    -u | --real_user ) real_user="$2"; shift 2 ;;
    --faf_path ) faf_path="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

$DEBUG && echo -e "Parsed arguments from the command line :\n$parse"

to_log() { echo -e "[$(date --rfc-3339=seconds)] T3 $*" >> "$faf_log_file"; }
to_log "#################### install FA script ####################"
to_log " --verbose $VERBOSE"
to_log " --debug $DEBUG"
to_log " --default_dir $default_dir"
to_log " --already_fa $fa_path"
to_log " --install_fa $install_fa_path"
to_log " --logfile $faf_log_file"
to_log " --real_user $real_user"
to_log " --fa_path $fa_path"

if $default_dir || [ "$install_fa_path" = "default" ]; then
    default_dir=true
    origin="$HOME/.steam/steam"
elif [ ! -z "$install_fa_path" ]; then
    origin="$install_fa_path"
elif [ ! -z "$fa_path" ]; then
    origin=$(dirname $(dirname $(dirname $fa_path)))
else
    to_log "Err -- Invalid input"
    exit 2
fi

printf "waiting for steam to finish installing... "
i=1
sp='/-\|'
while ! command -v steam &>/dev/null; do
    printf "\b${sp:i++%${#sp}:1}"
    sleep 1
done
echo ""

if $default_dir; then
    for _steamapps in "steamapps" "SteamApps"; do
        [ -d "$HOME/.steam/steam/$_steamapps" ] && \
        steamapps=$_steamapps && \
        break
    done
    [ "$steamapps" = "" ] && \
        to_log "Err -- neither steamapps nor SteamApps was found in home dir. exiting" && \
        exit 1
else
    steamapps="steamapps"
fi
[ -z "$fa_path" ] && fa_path="$origin/$steamapps/common/$supcom"
compatdata="$origin/$steamapps/compatdata/9420/pfx/drive_c/users/steamuser"

to_log "Putting compatdata and fa_install_dir in tmpfile."
echo -e "compatdata\n$compatdata\nfa_path\n$fa_path" >> $tmpfile

bind 'TAB: accept-line' &>/dev/null
while [ -z "$steam_username" ]; do
    echo "steam user name :"
    IFS= read -e -r steam_username
done
while [ -z "$steam_password" ]; do
    echo "steam password :"
    IFS= read -e -r -s steam_password
done
to_log "Steam credentials entrusted to script"

# NOTE THAT THIS IS NOT MY IDEAL SOLUTION BUT I HAVENT YET FOUND BETTER
launch_options_file="$HOME/Paste this into the Forged Alliance steam launch options"
launch_options='PROTON_NO_ESYNC=1, PROTON_DUMP_DEBUG_COMMANDS=1 %command%'
echo "$launch_options" > "$launch_options_file"

echo "### Two necessary manual steps needed to continue ###"
echo "1. Enable Proton for all games in the steam settings."
echo -e "2. Type/copy pasta this line into the Forged Alliances Launch options\n"
echo -e " $launch_options\n"
echo "You can also find a file in you HOME folder with the content to be pasted."

if ! $already_fa; then
    echo -e "\n\n\n"
    to_log "running steam"
    steam -login "$steam_username" "$steam_password"
    to_log "Installing FA to $fa_path"
    if $default_dir
    then
        while [ ! -d "$fa_path" ]; do
            steamcmd +login "$steam_username" "$steam_password" \
                     +@sSteamCmdForcePlatformType windows \
		     $( $default_dir || echo "+force_install_dir \"$origin\"") \
                     +app_update 9420 +quit
        done
    else
        while [ ! -d "$fa_path/bin" ]; do
            steamcmd +login "$steam_username" "$steam_password" \
                     +@sSteamCmdForcePlatformType windows \
                     +force_install_dir "$origin" \
                     +app_update 9420 +quit
        done
        mkdir -p "$fa_path/steamapps/common/$supcom"
        mv "$fa_path"/* "$fa_path/steamapps/common/$supcom" 2>/dev/null
    fi
    to_log "FA installed condition met"
fi

[ ! -d "$compatdata" ] && \
    to_log "neither steamapps nor SteamApps compatdata was found. exiting" && \
    exit 1

if [ ! -f "$compatdata/Local Settings/Application Data/Gas Powered Games/$supcom/Game.prefs" ]; then
    to_log "Game.prefs not detected - launching FA"
    steam -login "$steam_username" "$steam_password" -applaunch 9420 &>/dev/null &
    echo -e "\n\n\n\n\nWaiting for Forged Alliance to be run, Game.prefs to exist"
    echo "and for Forged Alliance to be shut down."
    echo "You may also type \"c\" (and enter/return) to exit this loop"
    echo "if you feel the conditions for continuing sucessfully"
    echo -n "have already been adequately met... "
    i=1
    sp='/-\|'
    no_config=true
    while { pidof SupremeCommande 1>/dev/null || \
            [ ! -f "$compatdata/Local Settings/Application Data/Gas Powered Games/$supcom/Game.prefs" ]; } && \
          [ "$typed_continue" != "c" ]
    do
        printf "\b${sp:i++%${#sp}:1}"
        read -s -r -t 1 typed_continue
    done
fi

if ! $already_fa
then
    to_log "copying over run file"
    cp -f "/tmp/proton_$real_user/run" "$faf_path"
fi


echo "FA installation finished succesfully"
[ -f "$faf_path/downlords-faf-client" ] || printf "Waiting for the FAF client to finish installing ... "
while [ ! -f "$faf_path/downlords-faf-client" ]; do
    spin
    sleep 1
done
to_log "starting T4 and exiting T3"
"$faf_path"/downlords-faf-client

