<!DOCTYPE html>  
<html lang="en">
<head> 
<title>PayPal Subscriptions with MEC</title>
    
    <meta name="viewport" content="width=device-width, minimum-scale=1, maximum-scale=1">	

	<link href="http://code.jquery.com/mobile/latest/jquery.mobile.min.css" rel="stylesheet" type="text/css" />
	<script src="http://code.jquery.com/jquery-1.6.4.min.js"></script>

	<cfscript>
        returnObj = StructNew();
        returnObj['url'] = url;
    </cfscript>
    
    <script src="index.js"></script>
    
	<script>
		ec = <cfoutput>#serializeJSON(returnObj)#</cfoutput>;
		
		$(document).bind("mobileinit", function(){
		  $.mobile.ajaxEnabled = false;
		});
	</script>
    
  <script src="http://code.jquery.com/mobile/latest/jquery.mobile.min.js"></script>
  
</head> 
<body> 


<div data-role="page" id="paid"  data-theme="b">

	<div data-role="header" >
    	<a href="index.html" data-role="button" data-direction="reverse" data-icon="home" data-iconpos="notext">Home</a>
		<h1>DigiMag - Paid</h1>
	</div><!-- /header -->

	<div data-role="content">	
    	<div id="confirmMsg">
    		<span id="amt"></span>
         </div>
         
        
        <div id="paidContent">	
    	
		</div>
	</div><!-- /content -->
    
</div><!-- /page -->

</body>
</html>