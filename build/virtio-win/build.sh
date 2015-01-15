#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2015 Syneto SRL.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=virtio-win
VER=0.1.81
PKG=virtualization/virtio-win
SUMMARY="KVM Windows VirtIO Drivers"
DESC="$SUMMARY"

download_source() {
    local DLDIR=$1
    local PROG=$2
    local VER=$3

    pushd $TMPDIR
    logmsg "Checking for source directory"
    if [ ! -f $PROG-$VER.iso ]; then
        get_resource $DLDIR/$PROG-$VER.iso || \
            logerr "--- Failed to download file $DLDIR/$PROG-$VER.iso"
    fi
    popd > /dev/null
}

build() {
    pushd $TMPDIR
    logcmd install -d $DESTDIR/$PREFIX/local/share/virtio/
    logcmd install -m 755 ./$PROG-$VER.iso $DESTDIR/$PREFIX/local/share/virtio/
    popd > /dev/null
}

init
download_source $PROG $PROG $VER
prep_build
build
make_package
clean_up
