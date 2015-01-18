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
# Copyright 2014 Syneto LTD.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=Test-Fatal
VER=0.014
PKG=library/perl/Test-Fatal
SUMMARY="Test::Fatal - incredibly simple helpers for testing code with exceptions"
DESC="$SUMMARY"

DEPENDS_BUILD_IPS="runtime/perl runtime/perl-64 library/perl/Try-Tiny"
DEPENDS_IPS=${DEPENDS_BUILD_IPS}

MAKEFILE_OPTS="${MAKEFILE_OPTS} INSTALLSITEMAN1DIR=/usr/share/man/man1 INSTALLSITEMAN3DIR=/usr/share/man/man3 INSTALLSITELIB=\$(SITELIBEXP)"

init
download_source $PROG $PROG $VER
patch_source
prep_build
buildperl
make_package
clean_up
