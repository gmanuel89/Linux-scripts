#### UBUNTU
## Enable SSH access
sudo apt install -y openssh-server # samba smbclient
## Install and remove base packages
sudo apt install -y ttf-mscorefonts-installer fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode fonts-inter
sudo apt purge -y libreoffice*
## Upgrade and cleanup
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean && sudo apt clean && sudo apt autoremove
#sudo apt install -y ubuntu-restricted-addons
## Remove snap (and prevent from being re-enabled)
snap list | awk 'NR > 1 { print $1 }' | xargs -I{} sudo snap remove --purge {} # iterate more times to remove all snaps
sudo systemctl stop snapd.service snapd.socket && sudo systemctl disable snapd.service snapd.socket && sudo systemctl mask snapd.service snapd.socket # disable snap services
sudo apt purge snapd -y # purge package
sudo apt-mark hold snapd # hold package
sudo tee /etc/apt/preferences.d/nosnap.pref <<EOF
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
rm -rf ~/snap
sudo rm -rf /snap
sudo rm -rf /var/snap
sudo rm -rf /var/lib/snapd
## Add flatpak support
sudo add-apt-repository -y ppa:flatpak/stable
sudo apt update && sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo apt install -y gnome-software gnome-software-plugin-flatpak
## Replace native DEB packages with flatpaks
sudo apt purge -y papers gnome-clocks loupe gnome-calculator gnome-contacts gnome-calendar gnome-weather gnome-maps showtime
flatpak install flathub -y org.gnome.clocks org.gnome.Loupe org.gnome.Papers org.gnome.Calculator org.gnome.Contacts org.gnome.Calendar org.gnome.Weather org.gnome.Maps org.gnome.Showtime org.gnome.Evolution org.gnome.Boxes
## Set Software to prefer flatpak
# gsettings get org.gnome.software packaging-format-preference
gsettings set org.gnome.software packaging-format-preference "['flatpak:flathub', 'flatpak', 'deb', 'snap']"


### Release Upgrade
# Temporarily lift the Snap block before upgrading
sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt-mark unhold snapd
# Run the Ubuntu release upgrade normally
sudo do-release-upgrade # or use the graphical Software Updater prompt
# Re-run the Snap cleanup and pin script
