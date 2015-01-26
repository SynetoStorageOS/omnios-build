#!/usr/bin/bash
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

PROG=expect
VER=5.45
PKG=runtime/expect
SUMMARY="Expect is a tool for automating interactive applications such as telnet, ftp, passwd, fsck, rlogin, tip, etc."
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="runtime/tcl-8"
DEPENDS_IPS="runtime/tcl-8"

BUILDDIR=$PROG$VER

REMOVE_PREVIOUS=1
BUILDARCH=64

save_function configure64 configure64_orig
configure64(){
    CC="$CC -m64"
    CXX="$CXX -m64"
    export CC
    export CXX
    CONFIGURE_OPTS="--mandir=$PREFIX/share/man"
    configure64_orig
}

init
download_source $PROG $PROG$VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up
