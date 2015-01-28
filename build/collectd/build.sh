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
# Copyright 2015 Syneto Limited.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=collectd
VER=5.4.99
PKG=system/collectd
SUMMARY="Collectd data collection service"
DESC="$SUMMARY"

DEPENDS_IPS="runtime/perl"
BUILD_DEPENDS_IPS="runtime/perl runtime/perl/manual"

CC="gcc -std=gnu99"
CONFIGURE_OPTS="--without-libnetsnmp --enable-write_graphite --mandir=/usr/share/man"

# We need this to find pod2man
export PATH=$PATH:/usr/perl5/5.16.1/bin

save_function configure32 orig_configure32
configure32() {
    logmsg "--- generate configure"
    ./build.sh || \
        logerr "------ Failed generating configure"
    orig_configure32
}
save_function configure64 orig_configure64
configure64() {
    logmsg "--- generate configure"
    ./build.sh || \
        logerr "------ Failed generating configure"
    orig_configure64
}

init
update_git_repo ${UPSTREAM_REPO_CONTAINER}/${PROG} syneto
patch_source
prep_build
build
strip_install
make_isa_stub
install_service system collectd.xml
make_package
clean_up
