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

PROG=graphite-api
VER=1.1
PKG=system/graphite-api
SUMMARY="Graphite-web, without the interface. Just the rendering HTTP API."
DESC="This is a minimalistic API server that replicates the behavior of Graphite-web. I removed everything I could and simplified as much code as possible while keeping the basic functionality."

GIT=$(which git)

PREFIX=/usr/
DATA_ROOT=/var/storage
DATA_DIR=${DATA_ROOT}/statistics
LIBDIR=${PREFIX}/lib/python2.6/vendor-packages

RUN_DEPENDS_IPS="user/admin"

install_configuration_files() {
	logcmd install -d -m 755 ${DESTDIR}/${DATA_ROOT}
	logcmd install -d -m 755 ${DESTDIR}/${DATA_DIR}
	logcmd install -d -m 755 ${DESTDIR}/${DATA_DIR}/graphite
	logcmd install -d -m 755 ${DESTDIR}/${DATA_DIR}/graphite/whisper
	logcmd install -d -m 755 ${DESTDIR}/etc
}

install_service_script() {
 	logcmd install -m 755 svc-${PROG}.sh ${DESTDIR}/lib/svc/method/svc-${PROG}
}

init
update_git_repo ${UPSTREAM_REPO_CONTAINER}/${PROG}
prep_build
python_build
install_configuration_files
install_service_script
install_service system ${PROG}.xml
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
