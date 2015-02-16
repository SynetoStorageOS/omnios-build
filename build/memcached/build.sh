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
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=memcached
VER=1.4.21
PKG=system/memcached
SUMMARY="Distributed memory object caching system"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="library/libevent network/netcat"

DEPENDS_IPS="SUNWcs"


add_service() {
	ginstall -d -m 755 ${DESTDIR}/lib/svc/method/
	ginstall -d -m 755 ${DESTDIR}/lib/svc/manifest/application/database/
	ginstall -m 755 svc/memcached ${DESTDIR}/lib/svc/method/
	ginstall -m 755 svc/memcached.xml ${DESTDIR}/lib/svc/manifest/application/database/
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
add_service
strip_install
make_package
clean_up
