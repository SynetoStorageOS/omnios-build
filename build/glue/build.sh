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

PROG=glue
VER=1.0.12
PKG=cluster/glue
SUMMARY="Cluster Glue is a set of libraries, tools and utilities suitable for the Heartbeat/Pacemaker cluster stack"
DESC="$SUMMARY"

BUILDARCH=32

CFLAGS="$CFLAGS -DHAVE_NFDS_T"
CONFIGURE_OPTS="--disable-libnet --disable-ansi --disable-fatal-warnings"

BUILD_DEPENDS_IPS="library/libqb"
RUN_DEPENDS_IPS="library/libqb"

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