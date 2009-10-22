<?php

require_once("xml2json.php");

$file = file_get_contents($_FILES['file']['tmp_name']);

echo xml2json::transformXmlStringToJson($file);

?>

