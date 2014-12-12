#!/usr/bin/env bash

pushd /code/source-repos/caiman
git fetch
git pull
popd
time ./build.sh -bpil
sudo svcadm disable -s nfs/server
sudo svcadm enable -s nfs/server
sudo share -F nfs /code/tmp/build_admin/caiman-151012/caiman
