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
wget https://gitlab.com/sulix/devel/sources/mklinux/-/raw/master/mklinux.sh -O mklinux
ALLOWROOT=1 bash mklinux -o "$pkgdir" -t linux -c "https://gitlab.com/sulix/devel/sources/mklinux/-/raw/master/config"
