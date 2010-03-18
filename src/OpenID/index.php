<?php
require_once "common.php";

global $pape_policy_uris;
?>
<html>
  <head><title>PHP OpenID Authentication Example</title></head>
  <body<?php if (isset($success)) { 
        print " onload='window.opener.handleOpenIDResponse(\"$openid\");window.close();'"; 
      
} ?>>
    <h1>Logging In...</h1>
  </body>
</html>
