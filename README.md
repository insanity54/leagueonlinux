# leagueonlinux
Run League of Legends on Linux without depending on playonlinux

## Why this program was made

PlayOnLinux frustrates me. The League of Legends PlayOnLinux install script is owned by an inactive maintainer, so nobody can easily install League of Legends through the program that is supposed to make installing games easy. Instead, players must browse the horribly formatted, information overload that is the [PlayOnLinux League of Legends app page](https://www.playonlinux.com/en/app-1135-League_Of_Legends.html).

Working fixes to the install script are published on the League of Legends app page by community members, but because the script maintainer is inactive, the script available through the PlayOnLinux program remains outdated and broken. Last update was 8 months ago, Ugh.


leagueonlinux is an attempt at making a turnkey solution to installing League of Legends on Linux. CLI installation is a priority, followed by a simple Zenity GUI.



# Process

sudo dpkg --add-architecture i386
sudo add-apt-repository ppa:wine/wine-builds
sudo apt-get update
sudo apt-get install -y xterm wine lib32z1 winetricks wine1.6 gnome-exe-thumbnailer ttf-mscorefonts-installer fonts-horai-umefont fonts-unfonts-core ttf-wqy-microhei winbind
sudo apt-get update

