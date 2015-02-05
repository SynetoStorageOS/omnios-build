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

PROG=cairo
VER=1.14.0
PKG=library/cairo
SUMMARY="Cairo is a 2D graphics library with support for multiple output devices. "
DESC="{$SUMMARY}"

DEPENDS_IPS="library/pixman"

save_function build32 build32_orig
build32() {
	PKG_CONFIG_PATH=/usr/lib/pkgconfig
	build32_orig
}

save_function build64 build64_orig
build64() {
	PKG_CONFIG_PATH=/usr/lib/amd64/pkgconfig
	build32_orig
}

init
download_source $PROG $PROG $VER
patch_source
autogen
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
