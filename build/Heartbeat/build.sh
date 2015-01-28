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

PROG=Heartbeat-3-0-STABLE
VER=3.0.5
PKG=cluster/Heartbeat
SUMMARY="Heartbeat is a daemon that provides cluster infrastructure (communication and membership) services to its clients."
DESC="$SUMMARY"

BUILDARCH=32
NO_PARALLEL_MAKE=1

BUILD_DEPENDS_IPS="cluster/glue"
RUN_DEPENDS_IPS="cluster/glue"

function bootstrap() {
    logmsg "Running bootstrap"
    pushd $TMPDIR/$BUILDDIR > /dev/null
    logcmd ./bootstrap || logerr "Failed to run bootstrap"
    popd > /dev/null
}

function install_service_scripts() {
    logcmd install -d -m 755 ${DESTDIR}/lib/svc/method/
    logcmd install -m 755 svc-heartbeat.sh ${DESTDIR}/lib/svc/method/svc-heartbeat
}

init
download_source $PROG $PROG $VER
patch_source
bootstrap
prep_build
build
install_service_scripts
install_service system heartbeat.xml
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
