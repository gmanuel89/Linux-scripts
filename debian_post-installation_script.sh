#### DEBIAN (GNOME)
## Enable SSH access
sudo apt install -y openssh-server # samba smbclient
## Install and remove base packages
sudo apt install -y ttf-mscorefonts-installer fonts-noto fonts-crosextra-carlito fonts-crosextra-caladea fonts-croscore fonts-firacode fonts-inter
sudo apt purge -y libreoffice*
sudo apt install -y vim
sudo apt purge -y firefox-esr*
sudo apt install -y gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly libavcodec-extra
## Upgrade and cleanup
sudo apt update && sudo apt dist-upgrade -y
sudo apt clean && sudo apt autoclean && sudo apt autoremove
## Only for MacBook Pro
sudo apt install dkms broadcom-sta-dkms mbpfan
## Login theme
sudo apt install -y plymouth plymouth-themes
sudo plymouth-set-default-theme -R bgrt
sudo vi /etc/default/grub
# add "quiet splash" to GRUB_CMDLINE_LINUX_DEFAULT
# set GRUB_TIMEOUT_STYLE to "hidden"
# set GRUB_TIMEOUT to 0
sudo update-grub
## Add flatpak support
sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
sudo apt install -y gnome-software-plugin-flatpak
## Add GNOME Shell extensions
sudo apt install -y gnome-shell-extension-appindicator gnome-shell-extension-desktop-icons-ng gnome-shell-extension-manager #gnome-shell-extension-arc-menu gnome-shell-extension-caffeine gnome-shell-extension-dash-to-panel gnome-shell-extension-drive-menu gnome-shell-extension-places-menu gnome-shell-extension-weather
## Replace native DEB packages with flatpaks
sudo apt purge -y papers gnome-clocks loupe gnome-calculator gnome-contacts gnome-calendar gnome-weather gnome-maps showtime
flatpak install flathub -y org.gnome.clocks org.gnome.Loupe org.gnome.Papers org.gnome.Calculator org.gnome.Contacts org.gnome.Calendar org.gnome.Weather org.gnome.Maps org.gnome.Showtime org.gnome.Evolution org.gnome.Boxes
## Set Software to prefer flatpak
# gsettings get org.gnome.software packaging-format-preference
gsettings set org.gnome.software packaging-format-preference "['flatpak:flathub', 'flatpak', 'deb']"