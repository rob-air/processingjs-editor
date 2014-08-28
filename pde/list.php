<?php

$ignore = array('.', '..', basename(__FILE__), 'default.pde');

exit(json_encode(getDir(getcwd())));


function getDir($path) {
	global $ignore;
	$data = array();

	if($handle = opendir($path)) {
		while(false !== ($entry = readdir($handle))) {
			if (in_array($entry, $ignore)) continue;
			if (is_dir($entry)) {
				$data[$entry] = getDir($path.DIRECTORY_SEPARATOR.$entry);
			} else {
				$data[] = $entry;
			}
		}
	}

	return $data;
}
