#!/usr/bin/env bash

SCRIPT_PATH=`realpath $0`
DIR=`dirname $SCRIPT_PATH`
exec > >(tee build.log)
exec 2>&1

sudo pkg update -v distribution-constructor

cp -a text-install-images.xml text-install-images-build.xml
sed -i -r 's/(.*syneto-storage-[0-9\.]+-)([0-9]+)(.*)/printf "%s%d%s" "\1" "$((\2+1))" "\3"/ge' ${DIR}/text-install-images-build.xml
sed -i -e "s#__BUILDPATH__#${DIR}#" ${DIR}/text-install-images-build.xml

time sudo distro_const build text-install-images-build.xml

if [ $? -eq 0 ]; then
	echo "Done"
else
	echo "Error. Something went wrong. Check build.log"
fi
