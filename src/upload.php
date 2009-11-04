<?php

require_once("xml2json.php");
require_once "api/CouchDB.php";

$couchDbBaseURL = "http://localhost:5984/";

$file = file_get_contents($_FILES['file']['tmp_name']);

$db = new CouchDB('test');

if(isPlist($_FILES['file']['name']))
{
	$postArgs = addFilenameAndType(xml2json::transformXmlStringToJson($file), $_FILES['file']['name'], "plist");
}
else if(isStrings($_FILES['file']['name']))
{
	$postArgs = transformStringsToJson($file, $_FILES['file']['name']);
}

// temporary fix
echo $postArgs;
// 
// try
// {
// 	$response = $db->send($apiCall, "POST", $postArgs);
// 	
// 	echo $response->getBody();
// }
// catch(Exception $e)
// {
// 	header("Status: 404");
// 	header("Content-Type: text/plain" );
// }

// Functions. Are called from above.

function addFilenameAndType($original, $fileName, $fileType)
{
	$search = "{\"plist\":{\"@attributes\":{\"version\":\"1.0\"},";
	$replacement = "{\"fileName\":\"" . $fileName . "\", \"fileType\":\"" . $fileType . "\",";
	$modified = str_replace($search, $replacement, $original); 
	
	return substr($modified, 0, strlen($modified)-1);
}

function isPlist($name)
{
	return preg_match("/.plist/", $name);
}

function isStrings($name)
{
	return preg_match("/.strings/", $name);
}

function transformStringsToJson($data, $fileName)
{
	$json = "({fileName: \"" . $fileName . "\", fileType: \"strings\", dict: {";
	$lines = split("\n", $data);	
	$keys = array();
	$values = array();	
	
	foreach($lines as $line)
	{		
		preg_match("/\"(.*)\"\s*=\s*\"(.*)\";/", $line, $regs);
				
		$keys[] = $regs[1];
		$values[] = $regs[2];
	}
	
	$json .= "key:[";
	$last_item = end($keys);
	for($i = 0; $i < count($keys); $i++)
	{		
		$json .= "\"" . $keys[$i] . "\"";

		if($keys[$i] != $last_item)
		{
			$json .= ",";
		}
	}
	
	$json .= "], string:[";
	$last_item = end($values);
	for($i = 0; $i < count($values); $i++)
	{		
		$json .= "\"" . $values[$i] . "\"";

		if($values[$i] != $last_item)
		{
			$json .= ",";
		}
	}
	
	$json .= "]}})";
	
	return $json;
}

?>

