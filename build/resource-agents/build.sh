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

PROG=resource-agents
VER=3.9.5
PKG=cluster/resource-agents
SUMMARY="A standardized interface for a cluster resource."
DESC="$SUMMARY"
BUILDARCH=32

PATH="/usr/gnu/bin:$PATH"
# CFLAGS="$CFLAGS -D_POSIX_PTHREAD_SEMANTICS"
# LDFLAGS="-L/usr/gnu/lib"
# CONFIGURE_OPTS="--prefix=/usr --disable-ansi --disable-fatal-warnings --with-heartbeat --with-corosync=no"
CONFIGURE_OPTS="--prefix=/usr --disable-libnet"

export CONFIG_SHELL="/usr/bin/bash"

function autogen() {
    logmsg "Running autogen.sh"
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logcmd ./autogen.sh || logerr "Failed to run autogen.sh"
    popd > /dev/null
}

init
download_source $PROG $PROG $VER
patch_source
autogen
prep_build
build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
