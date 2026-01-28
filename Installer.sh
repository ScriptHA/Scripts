#!/bin/bash
cd
if [ -e "/data/data/com.termux/files/home/storage" ]; then
	rm -rf /data/data/com.termux/files/home/storage
fi
termux-setup-storage
yes | pkg update
. <(curl https://cdn.quanghuynopro.com/store/termux-change-repo.sh)
yes | pkg upgrade
yes | pkg i python
yes | pkg i python-pip
yes | pkg i git xdelta3 wget tsu

wget -O ~/NXMC_INSTALLER https://github.com/NXMC-samehwid/Public/releases/download/base-release/installer
chmod +x ~/NXMC_INSTALLER
su 0 /system/bin/sh -c "setenforce 0"
sudo $(realpath ~/NXMC_INSTALLER)

set -e
URL="https://toilatu.site/TermuxBoot.apk"
FILE="TermuxBoot.apk"
curl -fL --retry 5 --retry-delay 2 -o "$FILE" "$URL" && [ -s "$FILE" ] && pm install -r "$FILE"

mkdir -p ~/.termux/boot

cat <<'EOF' > ~/.termux/boot/start_nxmc.sh
#!/data/data/com.termux/files/usr/bin/bash
tsu /data/NXMC/start_nxmc.sh > /dev/null 2>&1 & disown
EOF

chmod +x ~/.termux/boot/start_nxmc.sh

grep -q start_nxmc.sh ~/.bashrc || cat <<'EOF' >> ~/.bashrc
tsu /data/NXMC/start_nxmc.sh > /dev/null 2>&1 & disown
EOF
