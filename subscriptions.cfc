<cfcomponent>
	<cfscript>
		
		// create our objects to call methods on
		callerService = createObject("component","lib.services.CallerService");
		
		serverName = SERVER_NAME;
		serverPort = CGI.SERVER_PORT;
		contextPath = GetDirectoryFromPath(#SCRIPT_NAME#);
		protocol = CGI.SERVER_PROTOCOL;
			
	</cfscript>
    

   <cffunction name="setExpressCheckout" access="remote" returntype="any" returnFormat="JSON">
		
        <cfscript>
			var responseStruct="";
			var returnObj = StructNew();
		
			try {	
				// create our objects to call methods on
				
				data = StructNew();
				
				data.METHOD = "SetExpressCheckout";
				data.USER = request.UID;
				data.PWD = request.PASSWORD;
				data.SIGNATURE = request.SIG;
				data.METHOD = "SetExpressCheckout";
				data.VERSION = request.VER;
				data.URLBASE = request.URLBASE;
				data.USEPROXY = false;
				
				data.PAYMENTREQUEST_0_CURRENCYCODE="USD";
				data.L_BILLINGTYPE0 ="RecurringPayments";
				data.L_BILLINGAGREEMENTDESCRIPTION0 ="Full access to content on foo.com";
				data.ITEMAMT="19.99";
				data.amt = data.ITEMAMT;
				
				// set url info
				data.serverName = SERVER_NAME;
				data.serverPort = CGI.SERVER_PORT;
				data.contextPath = GetDirectoryFromPath(#SCRIPT_NAME#);
				data.protocol = CGI.SERVER_PROTOCOL;
				var cancelPage = "index.html";
				var returnPage = "paid.cfm?1=1";
				
	
					
				data.cancelURL = "http://" & serverName & ":" & serverPort & contextPath & cancelPage;	
				data.returnURL = "http://" & serverName & ":" & serverPort & contextPath & returnPage & "&amt=#data.amt#&currencycode=#data.PAYMENTREQUEST_0_CURRENCYCODE#";
			
				response = callerService.doHttppost(data);
				
				responseStruct = callerService.getNVPResponse(#URLDecode(response)#);
			
				if (responseStruct.Ack is not "Success")
				{
					Throw(type="InvalidData",message="Response:#responseStruct.Ack#, ErrorCode: #responseStruct.L_ERRORCODE0#, Message: #responseStruct.L_LONGMESSAGE0#"); 	
				
				} else {
					token = responseStruct.token;
				}
				
				/*	cfhttp.FileContent returns token and other response value from the server.
				We need to pass token as parameter to destination URL which redirect to return URL*/
				redirecturl = request.URLREDIRECT & token;
					
				returnObj['success'] = true;
				returnObj['redirecturl'] = redirecturl;	
				
			}
			
			catch(any e) 
			{
				returnObj['success'] = true;
				returnObj['error'] = e.message;
			}
			
			
			
			return serializeJSON(returnObj);
		</cfscript>
		
	</cffunction>
    
   
   <cffunction name="GetExpressCheckoutDetails" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="token" default="" required="true">
	
	  	<cfscript>
            var responseStruct = "";
			var returnObj = StructNew();
		
            try {
                
                  
                data = StructNew();
                data.method = "GetExpressCheckoutDetails";
                data.token = url.token;
				data.USER = request.UID;
				data.PWD = request.PASSWORD;
				data.SIGNATURE = request.SIG;
				data.VERSION = request.VER;
				data.URLBASE = request.URLBASE;
				data.USEPROXY = false;
	
                response = callerService.doHttppost(data);
                
                responseStruct = StructNew();
                responseStruct = callerService.getNVPResponse(#URLDecode(response)#);
				
				redirecturl = request.URLREDIRECT & token;
					
				returnObj['success'] = true;
				returnObj['response'] = responseStruct;	
                           
            }
        
            catch(any e) 
			{
				returnObj['success'] = true;
				returnObj['error'] = e.message;
			}
			
			return serializeJSON(returnObj);
		</cfscript>
		
	</cffunction>
    
    
    
    <cffunction name="CreateRecurringPaymentsProfile" access="remote" returntype="any" returnFormat="JSON">
		<cfargument name="token" default="" required="true">
        <cfargument name="payerid" default="" required="true">
			
			
            <cfscript>
                var responseStruct = StructNew();
				var returnObj = StructNew();	
                
                try {
                    
                    data = StructNew();
                    data.method = "CreateRecurringPaymentsProfile";
					data.token = url.token;
					data.USER = request.UID;
					data.PWD = request.PASSWORD;
					data.SIGNATURE = request.SIG;
					data.VERSION = request.VER;
					data.URLBASE = request.URLBASE;
					data.USEPROXY = false;
                        
                    data.BillingPeriod="Month";
                    data.BillingFrequency="1";
                    data.desc="Full access to content on foo.com";
                    data.PROFILESTARTDATE="2011-12-05T03:00:00";
                    data.token = arguments.token;
					data.amt = '19.99';
					
                    response = callerService.doHttppost(data);
                    responseStruct = callerService.getNVPResponse(#URLDecode(response)#);
                    returnObj['success'] = true;
					returnObj['response'] = responseStruct;	
					returnObj['premium'] = 'This is is all the premium content';
                
                           
                }
            
                catch(any e) 
				{
					returnObj['success'] = true;
					returnObj['error'] = e.message;
				}
				
				return serializeJSON(returnObj);
            </cfscript>
	</cffunction>
    
    
    <cffunction name="GetRecurringPaymentsProfileDetails" access="remote" returntype="any" returnFormat="JSON">
	   <cfargument name="profileid" default="" required="true">
			
			
            <cfscript>
                var responseStruct = StructNew();
				var returnObj = StructNew();	
                
                try {
                    
                    data = StructNew();
                    data.method = "GetRecurringPaymentsProfileDetails";
					data.USER = request.UID;
					data.PWD = request.PASSWORD;
					data.SIGNATURE = request.SIG;
					data.VERSION = request.VER;
					data.URLBASE = request.URLBASE;
					data.USEPROXY = false;
					data.profileid= url.profileid;
           
                    response = callerService.doHttppost(data);
                    responseStruct = callerService.getNVPResponse(#URLDecode(response)#);
                    returnObj['success'] = true;
					returnObj['response'] = responseStruct;	
					returnObj['premium'] = 'This is is all the premium content';
                           
                }
            
                catch(any e) 
				{
					returnObj['success'] = true;
					returnObj['error'] = e.message;
				}
				
				return serializeJSON(returnObj);
            </cfscript>
	</cffunction>
    
</cfcomponent>