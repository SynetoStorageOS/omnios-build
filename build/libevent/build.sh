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
# Copyright 2014 S.C. Syneto S.R.L.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=libevent
VER=2.0.21-stable
PKG=library/libevent
SUMMARY="Libevent - an event notification library"
DESC="$SUMMARY"

DEPENDS_IPS="SUNWcs"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
strip_install
VER=$(echo ${VER} | sed -e 's/-stable//')
make_package
clean_up
