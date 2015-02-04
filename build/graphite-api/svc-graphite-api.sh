#!/bin/env bash

. /lib/svc/share/smf_include.sh

export PATH=$PATH
export GRAPHITE_API_CONFIG=/etc/graphite-api.yaml
export PYTHONPATH=/usr/lib/python2.6/vendor-packages

function get_graphite_pid {
	ps awwx | grep graphite_api | grep -v grep | awk '{print $1}'
}

function start {
	/usr/bin/gunicorn -w2 graphite_api.app:app &
}

function stop {
	graphite_pids=$(get_graphite_pid)
	/usr/gnu/bin/kill ${graphite_pids} 2>/dev/null
}

case "$1" in
	start)
		start
		RETVAL=$?
		;;
	restart)
		stop
		start
		RETVAL=$?
		;;
	stop)
		stop
		RETVAL=0
		;;
	*)
		echo "usage: $0 [start|stop|restart]"
		;;
esac

if [ $RETVAL -eq 0 ]; then
	exit $SMF_EXIT_OK
fi

exit $SMF_EXIT_ERR_FATAL