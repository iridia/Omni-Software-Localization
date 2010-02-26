<?php

function replace_old_locales_with_new($resourceName, $newLanguageName) {
    $result = $resourceName;
    $result = str_replace("English", $newLanguageName, $result);
    $result = str_replace("French", $newLanguageName, $result);
    $result = str_replace("German", $newLanguageName, $result);
    $result = str_replace("Japanese", $newLanguageName, $result);
    $result = str_replace("Chinese", $newLanguageName, $result);
    $result = str_replace("Spanish", $newLanguageName, $result);
    $result = str_replace("Italian", $newLanguageName, $result);
    $result = str_replace("Swedish", $newLanguageName, $result);
    $result = str_replace("Portuguese", $newLanguageName, $result);
    $result = str_replace("Dutch", $newLanguageName, $result);
    return $result;
}

if($HTTP_RAW_POST_DATA == "")
{
    $HTTP_RAW_POST_DATA = file_get_contents("php://input");
}

$ch = curl_init(); 
curl_setopt($ch, CURLOPT_URL, "http://localhost:5984/project/" . $HTTP_RAW_POST_DATA); 
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$output = curl_exec($ch);
curl_close($ch);

$value = json_decode($output);
// print_r($value);

mkdir($value->OLProjectNameKey);
mkdir($value->OLProjectNameKey . "/Contents");
mkdir($value->OLProjectNameKey . "/Contents/Resources");

chmod($value->OLProjectNameKey, 0777);
chmod($value->OLProjectNameKey . "/Contents", 0777);
chmod($value->OLProjectNameKey . "/Contents/Resources", 0777);

for($i = 0; $i < count($value->OLProjectResourceBundlesKey); $i++)
{
    $languageName = $value->OLProjectResourceBundlesKey[$i]->OLResourceBundleLanguageKey->OLLanguageShortNameKey;
    mkdir($value->OLProjectNameKey . "/Contents/Resources/" . $languageName . ".lproj");
    chmod($value->OLProjectNameKey . "/Contents/Resources/" . $languageName . ".lproj", 0777);
    
    for($j = 0; $j < count($value->OLProjectResourceBundlesKey[$i]->OLResourceBundleResourcesKey); $j++)
    {
        $resource = $value->OLProjectResourceBundlesKey[$i]->OLResourceBundleResourcesKey[$j];
        $resourceName = $resource->OLResourceFileNameKey;

        $resourceName = replace_old_locales_with_new($resourceName, $languageName);
   
        $fileHandle = fopen($resourceName, 'w') or die("can't open file");
        
        for($k = 0; $k < count($resource->OLResourceLineItemsKey); $k++)
        {
            $lineItem = $resource->OLResourceLineItemsKey[$k];
            $comment = $lineItem->OLLineItemCommentKey;
            $identifier = $lineItem->OLLineItemIdentifierKey;
            $lineItemValue = $lineItem->OLLineItemValueKey;
            
            fwrite($fileHandle, "/* " . $comment . " */\n");
            
            fwrite($fileHandle, "\"" . $identifier . "\" = \"" . $lineItemValue . "\"\n\n");
        }
        
        fclose($fileHandle);
    }
}

exec("zip -r \"" . $value->OLProjectNameKey . ".zip\" \"" . $value->OLProjectNameKey ."\"");

?>