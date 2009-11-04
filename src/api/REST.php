<?php

require_once "CouchDB.php";
require_once "REST-config.php";

$url = $_SERVER['REQUEST_URI'];
$req_method = $_SERVER['REQUEST_METHOD'];
$getArgs = $_GET;
$putOrPostArgs = file_get_contents('php://input');
parse_str(file_get_contents('php://input'), $deleteArgs);

$apiCall = str_replace($urlPrefix, "", $url);
$exploded = explode("/",$apiCall);
$dbName = $exploded[0];
$call = str_replace($dbName."/", "", $apiCall);
$db = new CouchDB($dbName);

/* DEBUG
echo $dbName;
echo "<br />";
echo $apiCall;
echo "<br />";
echo $call;
*/

header("Content-Type: application/json" );

if($req_method == "GET")
{
	try
	{
		$response = $db->send($call);
		
		echo $response->getBody();
	}
	catch(Exception $e)
	{
		header("Status: 404");
		header("Content-Type: text/plain" );
	}
}
else if($req_method == "POST")
{
	try
	{
		$response = $db->send($call, "PUT", $putOrPostArgs);
		
		echo $response->getBody();
	}
	catch(Exception $e)
	{
		header("Status: 404");
		header("Content-Type: text/plain" );
	}
	
}
else if($req_method == "PUT")
{
	try
	{	
		$response = $db->send("", "POST", $putOrPostArgs);
		
		echo $response->getBody();		
	}
	catch(Exception $e)
	{
		header("Status: 404");
		header("Content-Type: text/plain" );		
	}
}
else if($req_method == "DELETE")
{
	try
	{
		$response = $db->send($call, "DELETE");
	}
	catch(Exception $e)
	{
		header("Status: 404");
		header("Content-Type: text/plain" );		
	}
}
else
{
	header("Status: 401");
	header("Content-Type: text/plain" );
}	

?>