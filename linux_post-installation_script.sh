#!/bin/sh

## Get OS and Version
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

## Get Desktop session
DSKTP=$DESKTOP_SESSION
# Check if it is WSL
if [ "${DSKTP}" = "" ]; then
	RELCMD=`uname -r`
	if [[ "${RELCMD}" =~ "WSL" ]]; then
		DSKTP="WSL"
	fi
fi

## Installation found
echo "Found an installation of '${OS}' (version ${VER}) with the '${DSKTP}' desktop environment"

## Ask for confirmation
read -p "Is this the correct configuration? " -n 1 -r
echo

## YES
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then

	## Ubuntu Desktop
	if [ "${OS}" = "Ubuntu" ] && [ "${DSKTP}" = "ubuntu" ]; then
		sudo apt purge -y libreoffice*
		sudo apt update && sudo apt dist-upgrade -y
		sudo apt install -y openssh-server # samba smbclient
		sudo apt install -y ttf-mscorefonts-installer fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode
		#sudo apt install -y ubuntu-restricted-extras
		#sudo apt install -y steam
		sudo apt autoclean && sudo apt clean && sudo apt autoremove
		## Ask for snap vs flatpak
		read -p "Do you want to go with snaps (otherwise flatpak will be enabled)? " -n 1 -r
		if [[ "${REPLY}" =~ ^[Yy]$ ]]; then
			sudo snap install onlyoffice-desktopeditors spotify vlc telegram-desktop gnome-boxes # kdenlive libreoffice bitwarden thunderbird brave steam
			sudo snap install shotcut --classic
		else
			sudo snap remove firefox snap-store
			sudo add-apt-repository -y ppa:flatpak/stable
			sudo apt update && sudo apt install -y flatpak
			flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
			sudo apt install --no-install-recommends gnome-software gnome-software-plugin-flatpak
			flatpak install flathub -y org.mozilla.firefox
			sudo apt purge -y gnome-clocks eog gnome-calculator gnome-contacts gnome-calendar gnome-weather
			flatpak install flathub -y org.gnome.clocks org.gnome.Loupe org.gnome.Calculator org.gnome.Contacts org.gnome.Calendar org.gnome.Weather org.gnome.Maps org.gnome.Totem org.gnome.Evolution org.gnome.Boxes
			flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut com.valvesoftware.Steam # org.kde.kdenlive org.libreoffice.LibreOffice com.bitwarden.desktop org.mozilla.Thunderbird com.brave.Browser com.vivaldi.Vivaldi
		fi

	## Ubuntu WSL
	elif [ "${OS}" = "Ubuntu" ] && [ "${DSKTP}" = "WSL" ]; then
		sudo apt update && sudo apt dist-upgrade -y
		sudo apt autoclean && sudo apt clean && sudo apt autoremove
		sudo apt install -y python3-full python3-pip python3-venv
		sudo apt install -y git
		wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
		sudo add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
		sudo apt install -y --no-install-recommends r-base r-base-dev

	## Kubuntu Desktop
	elif [ "${OS}" = "Ubuntu" ] && [ "${DSKTP}" = "plasma" ]; then
		sudo add-apt-repository ppa:kubuntu-ppa/backports
		sudo add-apt-repository ppa:kubuntu-ppa/backports-extra
		sudo apt update && sudo apt dist-upgrade -y
		sudo apt install -y kontact kalendar
		sudo apt install -y fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode
		sudo apt install -y kubuntu-restricted-extras
		sudo apt autoclean && sudo apt clean && sudo apt autoremove
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.kde.kdenlive org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut
		flatpak install flathub -y org.gnome.Boxes
	
	## Pop!_OS
	elif [ "${OS}" = "Pop!_OS" ] && [ "${DSKTP}" = "pop" ]; then
		sudo apt purge libreoffice* geary*
		sudo apt update && sudo apt full-upgrade -y
		sudo apt install -y fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode
		#sudo apt install -y ubuntu-restricted-extras
		sudo apt autoclean && sudo apt clean && sudo apt autoremove
		flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.kde.kdenlive org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut
		flatpak install flathub -y org.gnome.Boxes
	
	## KDE neon
	elif [ "${OS}" = "KDE neon" ] && [ "${DSKTP}" = "plasma" ]; then
		sudo pkcon refresh && sudo pkcon update -y
		sudo pkcon install -y kontact
		sudo pkcon install -y fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode
		sudo apt install -y fonts-open-sans ttf-mscorefonts-installer #it does not work with pkcon
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.kde.kdenlive org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut
		flatpak install flathub -y org.gnome.Boxes
	
	## Fedora workstation
	elif [ "${OS}" = "Fedora Linux" ] && [ "${DSKTP}" = "gnome" ]; then
		sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
		sudo dnf groupupdate -y core
		sudo dnf remove -y libreoffice*
		sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
		sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
		sudo dnf groupupdate -y sound-and-video
		sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-plugin-libav --exclude=gstreamer1-plugins-bad-free-devel
		sudo dnf install -y lame\* --exclude=lame-devel
		sudo dnf group upgrade --with-optional -y Multimedia
		# sudo dnf install libva-intel-driver
		sudo dnf install -y simple-scan loupe gnome-tweaks gnome-boxes gnome-calculator gnome-contacts gnome-calendar gnome-weather gnome-maps gnome-clocks evolution # samba-client samba epiphany soundconverter mp3gain
		sudo dnf install -y xorg-x11-fonts-Type1 google-roboto* mozilla-fira* overpass-fonts overpass-mono-fonts redhat-text-fonts redhat-display-fonts google-carlito-fonts google-crosextra-caladea-fonts
		sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
		sudo dnf install -y gnome-extensions-app gnome-shell-extension-appindicator gnome-shell-extension-drive-menu gnome-shell-extension-places-menu gnome-shell-extension-caffeine
		sudo dnf clean all && sudo dnf upgrade --refresh -y
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		# flatpak install flathub -y org.gnome.Extensions # de.haeckerfelix.Fragments
		flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut com.valvesoftware.Steam # org.kde.kdenlive org.libreoffice.LibreOffice com.bitwarden.desktop org.mozilla.Thunderbird com.brave.Browser
		# flatpak install flathub -y org.gnome.Boxes
	
	## Fedora KDE
	elif [ "${OS}" = "Fedora Linux" ] && [ "${DSKTP}" = "plasma" ]; then
		sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
		sudo dnf groupupdate -y core
		sudo dnf remove -y libreoffice*
		sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
		sudo dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
		sudo dnf groupupdate -y sound-and-video
		sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-plugin-libav --exclude=gstreamer1-plugins-bad-free-devel
		sudo dnf install -y lame\* --exclude=lame-devel
		sudo dnf group upgrade --with-optional -y Multimedia
		# sudo dnf install libva-intel-driver
		sudo dnf install -y skanpage kid3 # samba-client samba
		sudo dnf install -y xorg-x11-fonts-Type1 google-roboto* mozilla-fira* overpass-fonts overpass-mono-fonts redhat-text-fonts redhat-display-fonts google-carlito-fonts google-crosextra-caladea-fonts
		sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
		sudo dnf clean all && sudo dnf upgrade --refresh -y
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.kde.kdenlive org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut com.valvesoftware.Steam
		flatpak install flathub -y org.gnome.Boxes
	
	## openSUSE Tumbleweed KDE
	elif [ "${OS}" = "openSUSE Tumbleweed" ] && [ "${DSKTP}" = "default" ]; then
		# on Leap
		#sudo zypper ar -f -p 75 https://download.opensuse.org/repositories/KDE:/Qt5/openSUSE_Leap_$releasever KDE-Qt5
		#sudo zypper ar -f -p 75 https://download.opensuse.org/repositories/KDE:/Frameworks5/openSUSE_Leap_$releasever KDE-Frameworks
		#sudo zypper ar -f -p 75 https://download.opensuse.org/repositories/KDE:/Applications/KDE_Frameworks5_openSUSE_Leap_$releasever KDE-Applications
		#sudo zypper ar -f -p 75 https://download.opensuse.org/repositories/KDE:/Extra/KDE_Applications_openSUSE_Leap_$releasever KDE-Extra
		#sudo zypper ar -f -p 75 https://download.opensuse.org/repositories/Kernel:/stable:/Backport/standard/ kernel
		#sudo zypper addrepo -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$releasever/ packman
		#sudo zypper ar -f -p 75 http://download.opensuse.org/repositories/M17N:/fonts/openSUSE_Leap_$releasever Fonts
		sudo zypper addrepo -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
		sudo zypper refresh && sudo zypper -v dup --allow-vendor-change -y
		sudo zypper install --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs
		sudo zypper install kio-fuse kdenlive
		sudo zypper install noto-sans-fonts noto-serif-fonts google-roboto-fonts
		sudo zypper install fetchmsttfonts
		sudo zypper install ibm-plex-sans-fonts ibm-plex-serif-fonts ibm-plex-mono-fonts
	
	## Tuxedo OS
	elif [ "${OS}" = "Tuxedo OS" ] && [ "${DSKTP}" = "plasma" ]; then
		sudo apt purge libreoffice*
		sudo apt update && sudo apt dist-upgrade -y
		sudo apt install -y kmail kalendar
		sudo apt install -y fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode
		sudo apt install -y fonts-open-sans ttf-mscorefonts-installer
		sudo apt autoclean && sudo apt clean && sudo apt autoremove
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.kde.kdenlive org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut com.valvesoftware.Steam
		flatpak install flathub -y org.gnome.Boxes
	
	fi

else
echo "Aborting..."
fi