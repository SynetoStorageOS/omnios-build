#!/sbin/sh
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
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
# Copyright 2011 S.C. Syneto S.R.L.  All rights reserved.
# Use is subject to license terms.
#
# ident	"%Z%%M%	%I%	%E% SMI"

. /lib/svc/share/smf_include.sh

export PATH=/usr/local/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/lib

function get_pengine_pid {
	svcs -pv heartbeat | grep pengine | awk '{print $2}'
}

case "$1" in
	start)
		/etc/init.d/heartbeat start
		RETVAL=$?
		;;
	refresh)
		/etc/init.d/heartbeat reload
		RETVAL=$?
		;;
	restart)
		/etc/init.d/heartbeat restart
		RETVAL=$?
		;;
	stop)
		/etc/init.d/heartbeat stop
		pengine_pid=$(get_pengine_pid)
		/usr/gnu/bin/kill -9 ${pengine_pid} 2>/dev/null
		RETVAL=0
		;;
	*)
		echo "usage: $0 [start|stop|refresh|restart]"
		;;
esac

if [ $RETVAL -eq 0 ]; then
	exit $SMF_EXIT_OK
fi

exit $SMF_EXIT_ERR_FATAL