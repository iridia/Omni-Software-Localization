<?php

require_once("xml2json.php");

$file = utf16_to_utf8(file_get_contents($_FILES['file']['tmp_name']));
$log = fopen("log.txt", "a");
// fwrite($log, "starting\n");
// fwrite($log, "##" . $_FILES['file']['name'] . "##\n");

if(isPlist($_FILES['file']['name']))
{
    // fwrite($log, "is a plist\n");
	$postArgs = addFilenameAndType(xml2json::transformXmlStringToJson($file), $_FILES['file']['name'], "plist");
}
else if(isStrings($_FILES['file']['name']))
{
    // fwrite($log, "is a strings\n");
	$postArgs = transformStringsToJson($file, $_FILES['file']['name']);
}
else if(isZip($_FILES['file']['name']))
{
    // fwrite($log, "is a zip\n");
	$postArgs = archiveToJson($file, $log);
}

fclose($log);

header("Content-Type: text/json");

// temporary fix
echo $postArgs;

function archiveToJson($zipFileContents, $log)
{
	$aFileName = "tmpArchive".time().".zip";
	$theFile = fopen($aFileName, "w");
	
	
    // fwrite($log, "opened archive\n");
	
	fwrite($theFile, $zipFileContents);
	fclose($theFile);
	
	
    // fwrite($log, "rewrote archive, about to unzip\n");
    
	exec("unzip $aFileName");
	
    // fwrite($log, "unzipped, removing\n");
	
	exec("rm $aFileName");
	exec("rm -rf __MACOSX");
	
    // fwrite($log, "removed, starting parsing\n");
	
	$appName = str_replace(".zip", "", $_FILES['file']['name']);
	$englishBundle = opendir("$appName/Contents/Resources");
	$files = array();
	$files_resources = array();
	
    // fwrite($log, "starting file by file parsing\n");
	
	while(false !== ($file = readdir($englishBundle))) {
        // fwrite($log, $file);
		if(isLProj($file)) {
			$files[] = $file;
			
			$bundle = opendir("$appName/Contents/Resources/$file");
			
			$resources = array();
			
			while(false !== ($anotherFile = readdir($bundle))) {
				if(isStrings($anotherFile)) {
					$fileLocation = "$appName/Contents/Resources/$file/".$anotherFile;
					$resources[] = transformStringsToJson(utf16_to_utf8(file_get_contents($fileLocation)), $fileLocation);
				}
			}
			
			$files_resources[] = $resources;
			
			closedir($bundle);
		}
	}
	
	
    // fwrite($log, "parsed file by file\n");
	
	closedir($englishBundle);
	
	exec("rm -rf \"$appName\"");
	
	$value = "({\"fileType\": \"zip\", \"fileName\": \"$appName\", \"resourcebundles\": [";
	
    // fwrite($log, "returning value\n");
	
	$i = 0; 
	foreach($files as $file)
	{
		$value = $value . "{name: \"$file\", resources: [" . implode(",", $files_resources[$i]) . "]}";
		$i += 1;
		if($i != count($files))
		{
			$value = $value . ",";
		}
	}
	
    // fwrite($log, $value);
	
	return $value . "]})";
}


function addFilenameAndType($original, $fileName, $fileType)
{
	$search = "{\"plist\":{\"@attributes\":{\"version\":\"1.0\"},";
	$replacement = "{\"fileName\":\"" . $fileName . "\", \"fileType\":\"" . $fileType . "\",";
	$modified = str_replace($search, $replacement, $original); 
	
	return substr($modified, 0, strlen($modified)-1);
}

function isLProj($name)
{
	return preg_match("/.lproj/", $name);
}

function isPlist($name)
{
	return preg_match("/.plist/", $name);
}

function isStrings($name)
{
	return preg_match("/.strings/", $name);
}

function isZip($name)
{
	return preg_match("/.zip/", $name);
}

function transformStringsToJson($data, $fileName)
{
    $data = str_replace("\”", "”", $data);
	$json = "({\"fileName\": \"" . $fileName . "\", \"fileType\": \"strings\", \"dict\": {";
    $characters = preg_split('//', $data, -1, PREG_SPLIT_NO_EMPTY);
	$keys = array();
	$values = array();
	$comments = array();
	
	$current_key = "";
	$current_comment = "";
	$current_value = "";
	$is_comment = false;
	$is_string = false;
	$is_value = false;
	$previous_character = "";
	
	foreach($characters as $char)
	{
	    if($char == "\"" && $previous_character != "\\")
	    {
	        if($is_comment)
	        {
	            // do nothing
	        }
	        else if(!$is_string)
	        {
	            $is_string = true;
	        }
	        else
	        {
	            $is_string = false;
	        }
	    }
	    else if($char == "/" && $previous_character == "*")
	    {
	        $is_comment = false;
	    }
	    else if($char == "*" && $previous_character == "/")
	    {
	        $is_comment = true;
	    }
	    else if($char == "\n")
	    {
	        $is_string = false;
	        $is_value = false;
	        if(!$is_comment)
	        {
	            if(strlen($current_key) > 0)
	            {
	                $values[] = $current_value;
    	            $keys[] = $current_key;
    	            $comments[] = $current_comment;
	            }
	            
	            $current_value = "";
                $current_key = "";
                $current_comment = "";
	        }
	    }
	    else if($char == "=" && !$is_string)
	    {
	        $is_value = true;
	    }
	    else
	    {
	        if($is_string)
	        {
	            if($is_value)
	            {
            	    $current_value .= $char;
                }
                else
                {
    	            $current_key .= $char;
                }
	        }
	        else if($is_comment)
	        {
    	        $current_comment .= $char;
	        }
	    }
	    
	    $previous_character = $char;
	}
	
	$json .= "key:[";
	for($i = 0; $i < count($keys); $i++)
	{		
		$json .= "\"" . $keys[$i] . "\"";

		if($i != count($keys)-1)
		{
			$json .= ",";
		}
	}
	
	$json .= "], string:[";
	for($i = 0; $i < count($values); $i++)
	{		
	    $values[$i] = str_replace("\\&", "&", $values[$i]);
		$json .= "\"" . $values[$i] . "\"";

		if($i != count($values)-1)
		{
			$json .= ",";
		}
	}
	
	$json .= "]}, comments_dict: {";
	
	$json .= "key:[";
	for($i = 0; $i < count($keys); $i++)
	{		
		$json .= "\"" . $keys[$i] . "\"";

		if($i != count($keys)-1)
		{
			$json .= ",";
		}
	}
	
	$json .= "], string:[";
	for($i = 0; $i < count($comments); $i++)
	{		
	    $comments[$i] = str_replace("\"", "\\\"", $comments[$i]);
		$json .= "\"" . $comments[$i] . "\"";

		if($i != count($comments)-1)
		{
			$json .= ",";
		}
	}
	
	$json .= "]}})";
	
	return $json;
}	

function utf16_to_utf8($str) {
    $c0 = ord($str[0]);
    $c1 = ord($str[1]);

    if ($c0 == 0xFE && $c1 == 0xFF) {
        $be = true;
    } else if ($c0 == 0xFF && $c1 == 0xFE) {
        $be = false;
    } else {
        return $str;
    }

    $str = substr($str, 2);
    $len = strlen($str);
    $dec = '';
    for ($i = 0; $i < $len; $i += 2) {
        $c = ($be) ? ord($str[$i]) << 8 | ord($str[$i + 1]) : 
                ord($str[$i + 1]) << 8 | ord($str[$i]);
        if ($c >= 0x0001 && $c <= 0x007F) {
            $dec .= chr($c);
        } else if ($c > 0x07FF) {
            $dec .= chr(0xE0 | (($c >> 12) & 0x0F));
            $dec .= chr(0x80 | (($c >>  6) & 0x3F));
            $dec .= chr(0x80 | (($c >>  0) & 0x3F));
        } else {
            $dec .= chr(0xC0 | (($c >>  6) & 0x1F));
            $dec .= chr(0x80 | (($c >>  0) & 0x3F));
        }
    }
    return $dec;
}

?>

