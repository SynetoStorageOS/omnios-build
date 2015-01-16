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
# Copyright 2011-2013 OmniTI Computer Consulting, Inc.  All rights reserved.
# Copyright 2015 Syneto SRL.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions

. ../../lib/functions.sh

PROG=tcl
VER=8.6.3
PKG=runtime/tcl-8
SUMMARY="$PROG - a very powerful but easy to learn dynamic programming language"
DESC="$SUMMARY"

# We compile inside a subdir of the actual extracted dir. Changing builddir to
# pretend that this dir is the extracted dir is hacky, but works.
# Note - if we ever apply patches (triggering automatic removal of the build
# dir) then this may need to be changed so that tcl1.2.3 is deleted instead of
# tcl1.2.3/unix
BUILDDIR=$PROG$VER/unix

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
download_source $PROG $PROG$VER-src
patch_source
prep_build
build
make_isa_stub
make_package
clean_up
