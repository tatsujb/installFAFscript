faf_log_file=$1
operating_system=$2
real_user=$3
steam_user_name=$4
steam_password=$5
already_fa=$6
default_dir=$7
directory=$8

if $default_dir
then
    origin="$HOME/.steam/steam"
else
    origin=$directory
fi

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
    echo "[$(date --rfc-3339=seconds)] T3 running steam" >> $faf_log_file
    steam -login $steam_user_name $steam_password
    rm $HOME/the\ contents\ of\ this*
    if $default_dir
    then
        echo "[$(date --rfc-3339=seconds)] T3 installing FA to default dir" >> $faf_log_file
        while [ \( ! -d $origin/steamapps/common/Supreme* \) -a \( ! -d $origin/SteamApps/common/Supreme* \) ]
        do
            steamcmd +login $steam_user_name $steam_password +@sSteamCmdForcePlatformType windows +app_update 9420 +quit
        done
    else
        echo "[$(date --rfc-3339=seconds)] T3 installing FA to custom dir" >> $faf_log_file
        while [ ! -d $directory/bin ]
        do
            steamcmd +login $steam_user_name $steam_password +@sSteamCmdForcePlatformType windows +force_install_dir $directory +app_update 9420 +quit
        done
        cd $directory
        mkdir -p steamapps/common/Supreme\ Commander\ Forged\ Alliance
        mv * steamapps/common/Supreme\ Commander\ Forged\ Alliance/ 2>/dev/null
        cd
    fi
    echo "[$(date --rfc-3339=seconds)] T3 FA installed condition met" >> $faf_log_file
fi
echo "[$(date --rfc-3339=seconds)] T3 launching FA" >> $faf_log_file
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
    if [ \( ! "$(pidof SupremeCommande)" \) -a \
	 \( -f $origin/steamapps/compatdata/9420/pfx/drive_c/users/steamuser/Local\ Settings/Application\ Data/Gas\ Powered\ Games/Supreme\ Commander\ Forged\ Alliance/Game.prefs \) ] || \
       [ "$typed_continue" = "c" ]
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
    echo "[$(date --rfc-3339=seconds)] T3 copying over run file" >> $faf_log_file
    cp -f /tmp/proton_'$real_user'/run $HOME/faf/
fi
echo "[$(date --rfc-3339=seconds)] T3 making symbolic links" >> $faf_log_file

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
    echo "[$(date --rfc-3339=seconds)] T3 neither steamapps nor SteamApps compatdata was found. exiting" >> $faf_log_file \
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
echo "[$(date --rfc-3339=seconds)] T3 starting T4 and exiting T3" >> $faf_log_file
