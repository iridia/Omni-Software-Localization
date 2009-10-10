<?php

$randomNumber = rand(1, 500000);
$filename = "temp" + $randomNumber + ".data";
$handle = fopen($filename, "w");
$data = $_POST['file'];
$numbytes = fwrite($handle, $data);
fclose($handle);
print "$filename\n";

?>