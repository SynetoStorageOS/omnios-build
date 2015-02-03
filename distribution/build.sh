#!/usr/bin/env bash

DIR=`dirname $0`
CUSTOM_SCRIPT=`readlink -f $DIR/scripts/customize.sh`
exec > >(tee build.log)
exec 2>&1

if ! pkg info distribution-constructor >/dev/null 2>&1; then
	sudo pkg install -v distribution-constructor
fi

if [ ! -e text-install-images-build.xml ]; then
	cp -a text-install-images.xml text-install-images-build.xml
fi
sed -i -r 's/(.*syneto-storage-[0-9\.]+-)([0-9]+)(.*)/printf "%s%d%s" "\1" "$((\2+1))" "\3"/ge' ${DIR}/text-install-images-build.xml

time sudo distro_const build text-install-images-build.xml

if [ $? -eq 0 ]; then
	echo "Done"
else
	echo "Error. Something went wrong. Check build.log"
fi
