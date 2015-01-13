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
# Copyright 2011-2013 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2015 Syneto SRL.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=syslog-ng
VER=3.6.2
VERHUMAN=$VER
PKG=logging/syslog-ng
SUMMARY="A flexible and highly scalable system logging application"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="library/glib2 library/eventlog"
DEPENDS_IPS="$BUILD_DEPENDS_IPS"

LDFLAGS64="-L${PREFIX}/lib/$ISAPART64 -R${PREFIX}/lib/$ISAPART64"
LIBS="-lsocket -lnsl"
EVTLOG_CFLAGS="-I${PREFIX}/include/eventlog"
EVTLOG_LIBS="-levtlog"
GLIB_CFLAGS="-I/usr/include/amd64/glib-2.0 -I/usr/lib/amd64/glib-2.0/include -I/usr/include/glib-2.0"
GLIB_LIBS="-lglib-2.0 -lgmodule-2.0 -lgthread-2.0"
PKG_CONFIG_PATH="${PREFIX}/lib/$ISAPART64"
export LIBS EVTLOG_CFLAGS EVTLOG_LIBS GLIB_CFLAGS GLIB_LIBS PKG_CONFIG_PATH

CONFIGURE_OPTS="--enable-amqp --disable-mongodb --without-libmongo-client --disable-sun-streams"
BUILDARCH=64

install_smf_service() {
    logmsg "--- Installing SMF service"
    logcmd install -d -m 755 ${DESTDIR}/lib/svc/manifest/system/
    logcmd install -m 755 syslog-ng.xml ${DESTDIR}/lib/svc/manifest/system/syslog-ng.xml ||
        logerr "--- Could not install syslog-ng.xml SMF service configuration file"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
install_smf_service
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
