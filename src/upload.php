<?php

require_once("xml2json.php");

$file = utf16_to_utf8(file_get_contents($_FILES['file']['tmp_name']));

if(isPlist($_FILES['file']['name']))
{
	$postArgs = addFilenameAndType(xml2json::transformXmlStringToJson($file), $_FILES['file']['name'], "plist");
}
else if(isStrings($_FILES['file']['name']))
{
	$postArgs = transformStringsToJson($file, $_FILES['file']['name']);
}
else if(isZip($_FILES['file']['name']))
{
	$postArgs = archiveToJson($file);
}

header("Content-Type: text/json");

// temporary fix
echo $postArgs;

function archiveToJson($zipFileContents)
{
	$aFileName = "tmpArchive".time().".zip";
	$theFile = fopen($aFileName, "w");
	fwrite($theFile, $zipFileContents);
	fclose($theFile);
	
	exec("unzip $aFileName");
	
	exec("rm $aFileName");
	exec("rm -rf __MACOSX");
	
	// do stuff here
	$appName = str_replace(".zip", "", $_FILES['file']['name']);
	$englishBundle = opendir("$appName/Contents/Resources");
	$files = array();
	$files_resources = array();
	
	while(false !== ($file = readdir($englishBundle))) {
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
	
	closedir($englishBundle);
	
	exec("rm -rf \"$appName\"");
	
	$value = "({fileType: \"zip\", fileName: \"$appName\", resourcebundles: [";
	
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
	$json = "({fileName: \"" . $fileName . "\", fileType: \"strings\", dict: {";
	$lines = split("\n", $data);
	$keys = array();
	$values = array();
	$comments = array();
	$current_comment = "";
	$commenting = false;
	
	foreach($lines as $line)
	{
		if(preg_match("/^\s*$/", $line))
		{
			continue;
		}
		
		if($commenting)
		{
			if(preg_match("/(.*)\*\//", $line, $regs))
			{
				$commenting = false;
				$current_comment .= $regs[1];
			}
			else
			{
				$current_comment .= $line;
			}
			continue;
		}
		else if(preg_match("/((?:\/\*(.*)(?:[^*]|(?:\*+[^*\/]))*\*+\/)|(?:\/\/(.*)))/", $line, $regs))
		{
			if($regs[2] != "")
			{
				$current_comment = $regs[2];
			}
			else
			{
				$current_comment = $regs[3];
			}
			continue;
		}
		else if(preg_match("/\/\*(.*)/", $line, $regs))
		{
			$current_comment = $regs[1];
			$commenting = true;
			continue;
		}
		
		preg_match("/\"(.+)\"\s*=\s*\"(.+)\";/", $line, $regs);
		$keys[] = $regs[1];
		$values[] = $regs[2];
		$comments[] = $current_comment;
		$current_comment = "";
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
	
	$json .= "]}, comments_dict: {";
	
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
	for($i = 0; $i < count($comments); $i++)
	{		
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

