var ec = {url:'null'};

$(document).bind("mobileinit", function() {
	$.mobile.page.prototype.options.addBackBtn = false;
});

$(document).ready(function() {
	
	
	$('#paid').live('pageshow',function(e) {
		// I'm using a STATIC value of '123' for the user id, you would want to generate a unique ID 
		// for each user. I'm assuming they've logged in or will create a user acct prior to purchase
		// they would login in the future so you could authenticate their subscription.
		var profile = $.parseJSON(localStorage.getItem('123'));
	
		$.mobile.showPageLoadingMsg();
		
		// PROFILE ALREADY EXISTS, VERIFY IT.
		if(profile !== null)
		{
			if (profile['PROFILESTATUS'] === 'ActiveProfile')
			{
				$.ajax({
					url: 'subscriptions.cfc',
					data: 'method=GetRecurringPaymentsProfileDetails&profileid=' + profile['PROFILEID'],
					success: function(data){
						var obj = $.parseJSON(data);
						
						displayPremiumContent(obj);
						
						$.mobile.hidePageLoadingMsg();
					},
					error: function(request, textStatus, error){
						
						$.mobile.hidePageLoadingMsg();
					}
				});	
			
			}
			
		} else {
			
			// NO PROFILE, and NOT REDIRECTING from PAYPAL
			if(ec['url']['token'] === undefined)
			{
				
				$('#paidContent').html('To access our premium content, please subscribe for only $19.99 a year.<a href="#" id="subscribe" data-role="button">Subscribe via PayPal</a>');
				
				$('#paid').page('destroy').page();
				
				$.mobile.hidePageLoadingMsg();
			// REDIRECTING FROM PAYPAL GET DETAILS
			} else {
						
				$.ajax({
					url: 'subscriptions.cfc',
					data: 'method=GetExpressCheckoutDetails&token=' + ec['url']['token'],
					success: function(data){
						var obj = $.parseJSON(data);
						detail = obj;
						
						$('#amt').html('Our premium 1 year subscription costs $' + obj['response']['AMT']);
						$('#confirmMsg').html('<a href="#" id="confirm" data-role="button">Confirm Your Subscription</a>');
						$('#paid').page('destroy').page();
						
						$.mobile.hidePageLoadingMsg();
		
					},
					error: function(request, textStatus, error){
						$.mobile.hidePageLoadingMsg();
					}
				});	
						
			}
		}
	});
	
	
	
	$('#subscribe').live('click',function(e)
	{
		$.mobile.showPageLoadingMsg();
		
		$.ajax({
			url: 'subscriptions.cfc',
			data: 'method=setExpressCheckout',
			success: function(data){
				var obj = $.parseJSON(data);
				window.location = obj['redirecturl']
				
			},
			error: function(request, textStatus, error){
				$.mobile.hidePageLoadingMsg();
			}
		});	
		
	});
	
	$('#confirm').live('click',function(e) {
		
		$.mobile.showPageLoadingMsg();
		
		$.ajax({
			url: 'subscriptions.cfc',
			data: 'method=CreateRecurringPaymentsProfile&token=' +  detail['response']['TOKEN'],
			success: function(data){
				var obj = $.parseJSON(data);
				profile = obj['response'];;
				
				localStorage.setItem('123',JSON.stringify(profile));
				
				displayPremiumContent(obj);

				$.mobile.hidePageLoadingMsg();
			},
			error: function(request, textStatus, error){
				$.mobile.hidePageLoadingMsg();
			}
		});	
		
	});
	
	
	
	
	
	function displayPremiumContent(obj)
	{
		$('#paidContent').hide();
		
		$('#confirmMsg').fadeOut(250, function() {
			$('#paidContent').html(obj['premium']);
			$('#paidContent').fadeIn(500);
		});
	}
	
});

 