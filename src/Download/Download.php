<?php

require_once 'JSON.php';

$ch = curl_init(); 
curl_setopt($ch, CURLOPT_URL, "http://localhost:5984/project/" . $HTTP_RAW_POST_DATA); 
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$output = curl_exec($ch);
curl_close($ch);

$json = new Services_JSON();
$value = $json->decode($output);
#print_r($value);

mkdir($value->OLProjectNameKey);
mkdir($value->OLProjectNameKey . "/Contents");
mkdir($value->OLProjectNameKey . "/Contents/Resources");

for($i = 0; $i < count($value->OLProjectResourceBundlesKey); $i++)
{
    $languageName = $value->OLProjectResourceBundlesKey[$i]->OLResourceBundleLanguageKey->OLLanguageNameKey;
    mkdir($value->OLProjectNameKey . "/Contents/Resources/" . $languageName . ".lproj");
    
    for($j = 0; $j < count($value->OLProjectResourceBundlesKey[$i]->OLResourceBundleResourcesKey); $j++)
    {
        $resource = $value->OLProjectResourceBundlesKey[$i]->OLResourceBundleResourcesKey[$j];
        $resourceName = $resource->OLResourceShortNameKey;
        
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