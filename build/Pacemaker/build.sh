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
# Copyright 2015 Syneto SRL.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=pacemaker-Pacemaker
VER=1.1.12
PKG=cluster/Pacemaker
SUMMARY="Pacemaker is an advanced, scalable High-Availability cluster resource manager"
DESC="$SUMMARY"
BUILDARCH=32

PATH="/usr/gnu/bin:$PATH"
CFLAGS="$CFLAGS -D_POSIX_PTHREAD_SEMANTICS"
LDFLAGS="-L/usr/gnu/lib"
CONFIGURE_OPTS_32="$CONFIGURE_OPTS_32 --bindir=${PREFIX}/bin --sbindir=${PREFIX}/sbin --disable-ansi --disable-fatal-warnings --with-heartbeat --with-corosync=no"
export CONFIG_SHELL="/usr/bin/bash"

BUILD_DEPENDS_IPS="cluster/Heartbeat"
RUN_DEPENDS_IPS="cluster/Heartbeat"

function link_lrmd() {
    mkdir -p ${DESTDIR}/usr/lib/heartbeat
    ln -s /usr/libexec/pacemaker/lrmd ${DESTDIR}/usr/lib/heartbeat/lrmd
}

init
download_source $PROG $PROG $VER
patch_source
autogen
prep_build
build
link_lrmd
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et: