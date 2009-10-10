<?php

$filename = $_GET['fileName'];
$data = file_get_contents($filename);
//$data = parse($data);
print $data;

?>