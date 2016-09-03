#!/bin/bash
# Date : (2016-03-09)
# Last revision : (2016-03-09 23:22)
# Distribution used to test : Ubuntu 14.04
# Author : Chris Grimmett
# Licence : GPLv3
# WineHQ: https://appdb.winehq.org/objectManager.php?sClass=application&iId=10436
 
# Changelog
# (2016-03-06) 23:22 - Chris Grimmett
#        - Initial commit

 

WINEVERSION="1.9.17-staging"
 
TITLE="League of Legends"
PREFIX="grimtech-league-on-linux"
SHORTCUT_NAME="League of Legends"
 

which glxinfo || POL_Debug_Error "$(eval_gettext 'glxinfo is not installed. Please install mesa-utils package')"

if ! glxinfo | grep -q GL_EXT_texture_compression_s3tc; then
    POL_SetupWindow_message "$(eval_gettext 'Warning! S3TC compression is not available on your system.\n\nIf you have a free driver, you might need to install a proprietary driver \n\nOtherwise, you can enable it by installing libtxc-dxtn0 package or libtxc-dxtn-s2tc0,libtxc-dxtn-s2tc-bin if the first does not work, but you might get slower results')"
    POL_Debug_Warning "S3TC not enabled!"
fi
 
POL_Debug_Init
 
POL_SetupWindow_presentation "League of Legends" "Riot" "http://www.riotgames.com/" "Quentin PÂRIS, BlondVador" "LeagueOfLegends"
 
POL_SetupWindow_InstallMethod "DOWNLOAD,LOCAL"
 
if [ "$INSTALL_METHOD" = "LOCAL" ]; then
    cd "$HOME"
    POL_SetupWindow_browse "$(eval_gettext 'Please select the setup file to run.')" "$TITLE" "" "Windows Executables (*.exe)|*.exe;*.EXE"
 
    if strings "$APP_ANSWER"|grep -q '\(name="Pando Media Booster Downloader"\|Advanced Installer\)'; then
        NOBUGREPORT="TRUE"
        POL_Debug_Fatal "$(eval_gettext 'Cant install using the official downloader, sorry')"
    fi
    FULL_INSTALLER="$APP_ANSWER"
else # DOWNLOAD
    POL_System_TmpCreate "$PREFIX"
 
    # http://forums.na.leagueoflegends.com/board/showthread.php?t=1474419
    POL_SetupWindow_menu "$(eval_gettext 'Select installer to download:')" "$TITLE" "$(eval_gettext 'North America')~$(eval_gettext 'Europe West')~$(eval_gettext 'Europe Nordic and East')" "~"
    case "$APP_ANSWER" in
        "$(eval_gettext 'North America')")
            DOWNLOAD_URL="http://l3cdn.riotgames.com/Installer/SingleFileInstall/LeagueOfLegendsBaseNA.exe"
            DOWNLOAD_MD5="9d44b68bd02d7b5426556f64d86bbd16"
            ;;
        "$(eval_gettext 'Europe West')")
            DOWNLOAD_URL="http://l3cdn.riotgames.com/Installer/SingleFileInstall/LeagueOfLegendsBaseEUW.exe"
            DOWNLOAD_MD5="eb5d7b007b6022ee555c0dd9fd71263e"
            ;;
        "$(eval_gettext 'Europe Nordic and East')")
            DOWNLOAD_URL="http://l3cdn.riotgames.com/Installer/SingleFileInstall/LeagueOfLegendsBaseEUNE.exe"
            DOWNLOAD_MD5="f08d7b70776b0989eabb016bae77fdaa"
            ;;
    esac
    DOWNLOAD_FILE="$POL_System_TmpDir/$(basename "$DOWNLOAD_URL")"
 
    POL_Call POL_Download_retry "$DOWNLOAD_URL" "$DOWNLOAD_FILE" "$DOWNLOAD_MD5" "$TITLE standalone installer"
 
    FULL_INSTALLER="$DOWNLOAD_FILE"
fi
 
POL_System_SetArch "x86"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"
 
POL_Call POL_Install_corefonts
POL_Call POL_Install_vcrun2005
POL_Call POL_Install_vcrun2008
POL_Call POL_Install_d3dx9
 
Set_OS "win7"
 
POL_SetupWindow_message "$(eval_gettext 'Warning: You must not tick the checkbox "Run $TITLE" when setup is done')" "$TITLE"
 
POL_Wine_WaitBefore "$TITLE"
POL_Wine "$FULL_INSTALLER"
 
Set_OS winxp
 
# Set Graphic Card informations keys for wine
POL_Wine_SetVideoDriver
 
POL_Call POL_Function_OverrideDLL builtin,native dnsapi
POL_Shortcut "lol.launcher.admin.exe" "$SHORTCUT_NAME" "$SHORTCUT_NAME.png" "" "Game;RolePlaying;"
 
if [ "$INSTALL_METHOD" = "DOWNLOAD" ]; then
    # Free some disk space
    POL_System_TmpDelete
fi
 
if [ "$POL_OS" = "Linux" ]; then
    if [ "$(cat /proc/sys/net/ipv4/tcp_timestamps)" = "1" ]; then
        FORUM_URL='http://forums.euw.leagueoflegends.com/board/showthread.php?t=2058453'
        POL_SetupWindow_question "$(eval_gettext 'If you get connection errors when attempting to login, try disabling tcp_timestamps in the kernel.')\n$(eval_gettext 'Do you want to read original thread in League of Legends forums?')" "$TITLE"
        [ "$APP_ANSWER" = "TRUE" ] && POL_Browser "${FORUM_URL}"
    fi
fi
 
POL_SetupWindow_Close
exit 0
