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

PROG=crmsh
VER=2.1.0
PKG=cluster/crmsh
SUMMARY="crmsh is a command-line interface for High-Availability cluster management on GNU/Linux systems."
DESC="$SUMMARY"

BUILDARCH=32

CONFIGURE_OPTS_32="--bindir=$PREFIX/bin"

BUILD_DEPENDS_IPS="cluster/Pacemaker"
RUN_DEPENDS_IPS="cluster/Pacemaker"

function create_modules_link()
{
	ln -s crmsh ${DESTDIR}/usr/lib/python2.6/site-packages/modules
}

init
download_source $PROG $PROG $VER
patch_source
autogen
prep_build
build
create_modules_link
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
