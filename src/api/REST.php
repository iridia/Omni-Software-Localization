<?php

require_once "CouchDB.php";

$urlPrefix = "/osl/src/api/"; // should be /api/ in 
$couchDbBaseURL = "http://localhost:5984/";

$url = $_SERVER['REQUEST_URI'];
$req_method = $_SERVER['REQUEST_METHOD'];
$getArgs = $_GET;
$postArgs = $_POST;
parse_str(file_get_contents('php://input'), $putArgs);
parse_str(file_get_contents('php://input'), $deleteArgs);

$apiCall = str_replace($urlPrefix, "", $url);
$db = new CouchDB('test');

if($req_method == "GET")
{
	try
	{
		$response = $db->send($apiCall);
		
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
		$response = $db->send($apiCall, "POST", $postArgs);
		
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
		$response = $db->send($apiCall, "PUT", $putArgs);
		
		echo $response->getBody();		
	}
	catch
	{
		header("Status: 404");
		header("Content-Type: text/plain" );		
	}
}
else if($req_method == "DELETE")
{
	try
	{
		$response = $db->send($apiCall, "DELETE");
	}
	catch
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