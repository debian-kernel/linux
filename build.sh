#!/bin/bash
set -ex
#export VERSION=$(cat debian/changelog | head -n 1 | sed "s/.*(//g" | sed "s/).*//g")
export VERSION=$(curl https://kernel.org/ | grep "downloadarrow_small.png" | sed "s/.*href=\"//g;s/\".*//g;s/.*linux-//g;s/\.tar.*//g")
if echo ${VERSION} | grep -e "\.0$" ; then
    export VERSION=${VERSION::-2}
fi
# Stage 1: Get version and fetch source code
# fetch source
wget -c https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${VERSION}.tar.xz
# extrack if directory not exists
[[ -d linux-${VERSION} ]] || tar -xf linux-${VERSION}.tar.xz
echo 1 > .stage


# Enter source
cd linux-${VERSION}

# Redefine version
#export VERSION=$(cat ../debian/changelog | head -n 1 | sed "s/.*(//g" | sed "s/).*//g")
export VERSION=$(curl https://kernel.org/ | grep "downloadarrow_small.png" | sed "s/.*href=\"//g;s/\".*//g;s/.*linux-//g;s/\.tar.*//g")

# Stage 2: Build & Install source code (Like archlinux)
pkgdir=../debian/linux
mkdir -p "$pkgdir"
wget https://gitlab.com/sulinos/devel/sulin-sources/-/raw/master/mklinux -O mklinux
chmod +x mklinux
bash mklinux "$pkgdir"
