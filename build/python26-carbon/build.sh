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

PROG=carbon
VER=0.9.13
PKG=library/python-2/carbon-26
SUMMARY="${PROG}"
DESC="$SUMMARY"

RUN_DEPENDS_IPS="user/admin runtime/python-26 python-2/Twisted-26"
BUILD_DEPENDS_IPS="runtime/python-26"
BUILDARCH=32

PREFIX=/usr/
DATA_ROOT=/var/storage
DATA_DIR=${DATA_ROOT}/statistics
LIBDIR=${PREFIX}/lib/python2.6/vendor-packages

python_build() {
    if [[ -z "$PYTHON" ]]; then logerr "PYTHON not set"; fi
    if [[ -z "$PYTHONPATH" ]]; then logerr "PYTHONPATH not set"; fi
    if [[ -z "$PYTHONLIB" ]]; then logerr "PYTHONLIB not set"; fi
    logmsg "Building using python setup.py"
    pushd $TMPDIR/$BUILDDIR > /dev/null

    ISALIST=i386
    export ISALIST
    pre_python_32
    logmsg "--- setup.py (32) build"
    logcmd $PYTHON ./setup.py build ||
        logerr "--- build failed"
    logmsg "--- setup.py (32) install"
    logcmd $PYTHON \
        ./setup.py install --root=${DESTDIR} --prefix ${PREFIX} --install-lib ${LIBDIR} --install-data ${DATA_DIR} ||
        logerr "--- install failed"
	popd 2>&1 > /dev/null
}

add_smf_service() {
	logcmd install -d -m 755 ${DESTDIR}/var/svc/manifest/system/
	logcmd cp carbon.xml ${DESTDIR}/var/svc/manifest/system/
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
python_build
add_smf_service
make_package
clean_up
