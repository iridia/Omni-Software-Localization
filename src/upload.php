<?php

require_once("xml2json.php");
require_once "api/CouchDB.php";

$couchDbBaseURL = "http://localhost:5984/";

$file = file_get_contents($_FILES['file']['tmp_name']);

$db = new CouchDB('test');

if(isPlist($_FILES['file']['name']))
{
	$postArgs = xml2json::transformXmlStringToJson($file);
}
else if(isStrings($_FILES['file']['name']))
{
	$postArgs = transformStringsToJson($file);
}

try
{
	echo $postArgs;
	
	$response = $db->send($apiCall, "POST", $postArgs);
	
	echo $response->getBody();
}
catch(Exception $e)
{
	header("Status: 404");
	header("Content-Type: text/plain" );
}

// Functions. Are called from above.

function isPlist($name)
{
	return preg_match("/.plist/", $name);
}

function isStrings($name)
{
	return preg_match("/.strings/", $name);
}

function transformStringsToJson($data)
{
	$json = "{";
	$lines = split("\n", $data);
	$last_item = end($lines);	
	
	foreach($lines as $line)
	{		
		preg_match("/\"(.*)\"\s*=\s*\"(.*)\";/", $line, $regs);
				
		$json .= "\"" . $regs[1] . "\":\"" . $regs[2] . "\"";
		
		if($line != $last_item)
		{
			$json .= ",";
		}
	}
	
	$json .= "}";
	
	return $json;
}

?>

