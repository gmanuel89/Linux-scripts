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

## Installation found
echo "Found an installation of '${OS}' (version ${VER}) with the '${DESKTOP_SESSION}' desktop environment"

## Ask for confirmation
read -p "Is this the correct configuration? " -n 1 -r
echo

## YES
if [[ "${REPLY}" =~ ^[Yy]$ ]]; then

	## Ubuntu Desktop
	if [ "${OS}" = "Ubuntu" ] && [ "${DESKTOP_SESSION}" = "ubuntu" ]; then
		sudo apt purge -y libreoffice*
		sudo apt update && sudo apt dist-upgrade -y
		sudo apt install -y totem # samba smbclient
		sudo apt install -y fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode
		sudo apt install -y ubuntu-restricted-extras
		sudo apt install -y steam
		sudo apt autoclean && sudo apt clean && sudo apt autoremove
		# sudo snap install -y onlyoffice-desktopeditors spotify kdenlive vlc telegram-desktop gnome-boxes # libreoffice bitwarden thunderbird brave steam
		# sudo snap install -y shotcut --classic
		sudo add-apt-repository -y ppa:flatpak/stable
		sudo apt update && sudo apt install -y flatpak
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.kde.kdenlive org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut # org.libreoffice.LibreOffice com.bitwarden.desktop org.mozilla.Thunderbird com.brave.Browser com.valvesoftware.Steam
		flatpak install flathub -y org.gnome.Boxes

	## Kubuntu Desktop
	elif [ "${OS}" = "Ubuntu" ] && [ "${DESKTOP_SESSION}" = "plasma" ]; then
		sudo add-apt-repository ppa:kubuntu-ppa/backports
		sudo add-apt-repository ppa:kubuntu-ppa/backports-extra
		sudo apt update && sudo apt dist-upgrade -y
		sudo apt install -y kontact kalendar
		sudo apt install -y fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode
		sudo apt install -y kubuntu-restricted-extras
		sudo apt autoclean && sudo apt clean && sudo apt autoremove
	
	## KDE neon
	elif [ "${OS}" = "KDE neon" ] && [ "${DESKTOP_SESSION}" = "plasma" ]; then
	
	## Fedora workstation
	elif [ "${OS}" = "Fedora Linux" ] && [ "${DESKTOP_SESSION}" = "gnome" ]; then
		sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
		sudo dnf groupupdate core
		sudo dnf remove libreoffice*
		sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
		sudo dnf groupupdate sound-and-video
		sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
		sudo dnf install lame\* --exclude=lame-devel
		sudo dnf group upgrade --with-optional Multimedia
		# sudo dnf install libva-intel-driver
		sudo dnf clean all && sudo dnf upgrade -y --refresh
		sudo dnf install -y simple-scan gnome-tweaks gnome-boxes # samba-client samba epiphany soundconverter mp3gain
		sudo dnf install -y xorg-x11-fonts-Type1 google-roboto* mozilla-fira* overpass-fonts overpass-mono-fonts redhat-text-fonts redhat-display-fonts google-carlito-fonts google-crosextra-caladea-fonts
		sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
		sudo dnf clean all && sudo dnf upgrade --refresh
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install flathub -y org.gnome.Extensions org.gnome.TextEditor org.gnome.Weather org.gnome.Contacts org.gnome.Calendar # de.haeckerfelix.Fragments
		flatpak install flathub -y org.onlyoffice.desktopeditors com.spotify.Client org.kde.kdenlive org.videolan.VLC org.telegram.desktop org.shotcut.Shotcut com.valvesoftware.Steam # org.libreoffice.LibreOffice com.bitwarden.desktop org.mozilla.Thunderbird com.brave.Browser
		flatpak install flathub -y org.gnome.Boxes
	
	
	## Fedora KDE
	elif [ "${OS}" = "Fedora Linux" ] && [ "${DESKTOP_SESSION}" = "plasma" ]; then
		sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
		sudo dnf groupupdate core
		sudo dnf remove libreoffice*
		sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
		sudo dnf groupupdate sound-and-video
		sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
		sudo dnf install lame\* --exclude=lame-devel
		sudo dnf group upgrade --with-optional Multimedia
		# sudo dnf install libva-intel-driver
		sudo dnf clean all && sudo dnf upgrade -y --refresh
		sudo dnf install -y skanpage kid3 # samba-client samba
		sudo dnf install -y xorg-x11-fonts-Type1 google-roboto* mozilla-fira* overpass-fonts overpass-mono-fonts redhat-text-fonts redhat-display-fonts google-carlito-fonts google-crosextra-caladea-fonts
		sudo dnf install -y curl cabextract xorg-x11-font-utils fontconfig https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
		sudo dnf clean all && sudo dnf upgrade --refresh
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	
	fi

else
echo "Aborting..."
fi