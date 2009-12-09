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

header("Content-Type: text/json");

// temporary fix
echo $postArgs;

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
	$comments = array();
	$current_comment = "";
	
	foreach($lines as $line)
	{
		if(preg_match("/^\s*$/", $line))
		{
			continue;
		}
		
		if(preg_match("/((?:\/\*(?:[^*]|(?:\*+[^*\/]))(.*)*\*+\/)|(?:\/\/.*))/", $line, $regs))
		{
			$current_comment = $regs[1];
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
	$last_item = end($comments);
	for($i = 0; $i < count($comments); $i++)
	{		
		$json .= "\"" . $comments[$i] . "\"";

		if($comments[$i] != $last_item)
		{
			$json .= ",";
		}
	}
	
	$json .= "})";
	
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

