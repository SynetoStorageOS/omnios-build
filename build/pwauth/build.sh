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
# Copyright 2015 Syneto LTD.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=pwauth
VER=2.3.11
PKG=system/pwauth
SUMMARY="Pwauth is an authenticator designed to support reasonably secure web authentication out of the system password database"
DESC="$SUMMARY"

build32() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logcmd make clean
    logcmd make CC='gcc -m32' pwauth
    logcmd install -d -m 755 ${DESTDIR}/usr/bin/i386
    logcmd install -m 755 pwauth ${DESTDIR}/usr/bin/i386
    popd > /dev/null
}

build64() {
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logcmd make clean
    logcmd make CC='gcc -m64' pwauth
    logcmd install -d -m 755 ${DESTDIR}/usr/bin/amd64
    logcmd install -m 755 pwauth ${DESTDIR}/usr/bin/amd64
    popd > /dev/null
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up
