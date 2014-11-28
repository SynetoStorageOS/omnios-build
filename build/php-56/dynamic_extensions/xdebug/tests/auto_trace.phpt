--TEST--
Test with auto-trace
--INI--
xdebug.default_enable=1
xdebug.auto_trace=1
xdebug.trace_options=0
xdebug.trace_output_dir=/tmp
xdebug.collect_params=3
xdebug.collect_return=0
xdebug.collect_assignments=0
xdebug.auto_profile=0
xdebug.profiler_enable=0
xdebug.dump_globals=0
xdebug.show_mem_delta=0
xdebug.trace_format=0
--FILE--
<?php
	$trace_file = xdebug_get_tracefile_name();
	function foo() {
		echo "bar\n";
	}

	foo();
	echo file_get_contents($trace_file);
	unlink($trace_file);
?>
--EXPECTF--
bar
TRACE START [%d-%d-%d %d:%d:%d]
%w%f %w%d   -> {main}() /%s/auto_trace.php:0
%w%f %w%d     -> xdebug_get_tracefile_name() /%s/auto_trace.php:2
%w%f %w%d     -> foo() /%s/auto_trace.php:7
%w%f %w%d     -> file_get_contents('/tmp/%s') /%s/auto_trace.php:8
