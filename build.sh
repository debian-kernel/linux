#!/bin/bash
set -ex
#export VERSION=$(cat debian/changelog | head -n 1 | sed "s/.*(//g" | sed "s/).*//g")
export VERSION=$(curl https://kernel.org/ | grep "downloadarrow_small.png" | sed "s/.*href=\"//g;s/\".*//g;s/.*linux-//g;s/\.tar.*//g")
if echo ${VERSION} | grep -e "\.[0-9]*\.0$" ; then
    export VERSION=${VERSION::-2}
fi
# Stage 0: set version
sed -i "s/9999/${VERSION}/g" debian/changelog
# Stage 1: Get version and fetch source code
# fetch source
wget https://gitlab.com/turkman/devel/sources/mklinux/-/raw/master/mklinux.sh -O mklinux
mkdir -p ./debian/linux
ALLOWROOT=1 bash mklinux -i -o "./debian/linux" -t linux -c "https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/trunk/config" -y 1
# decompress for initramfs-tools
find ./debian/linux -type f -iname "*.ko.zst" -exec zstd -d --rm {} \;
