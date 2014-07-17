<?php

$data = array();

foreach (glob('*.pde') as $file) {
	$data[] = $file;
}

exit(json_encode($data));