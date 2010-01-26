<?php

require_once "CouchDB.php";
require_once "REST-config.php";

$url = $_SERVER['REQUEST_URI'];
$req_method = $_SERVER['REQUEST_METHOD'];
$getArgs = $_GET;
$putOrPostArgs = file_get_contents('php://input');
parse_str(file_get_contents('php://input'), $deleteArgs);

// Remove everything up to api/
// So this turns this (http://shellder.omnigroup.com/osl/src/api/project/find/all)
// into (project/find/all)
$apiCall = str_replace($urlPrefix, "", $url);

// Get the query string (the part with the ?)
if(preg_match("\?", $apiCall) != 0)
{
    $queryString = strstr($apiCall, "?");
}

// Extract the model name (i.e. project, user, message)
$exploded = explode("/",$apiCall);
$dbName = $exploded[0];

// Remove the model name
$call = str_replace($dbName."/", "", $apiCall);

// Replace find with the actual couch URL necessary
$searchAPIName = "find";
$couchSearchPrefix = "_design/finder/_view";
$call = str_replace($searchAPIName . "/", $couchSearchPrefix . "/", $call);

// Add the query string onto the end
$call .= $queryString;
$db = new CouchDB($dbName);

//  // DEBUG
// echo "Database: " . $dbName;
// echo "\n";
// echo "API call: " . $apiCall;
// echo "\n";
// echo "Couch call: " . $call;
// echo "\n";
// echo "Query string: " . $query;
// echo "\n";


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