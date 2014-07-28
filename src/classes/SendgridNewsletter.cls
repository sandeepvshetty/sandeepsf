global class SendgridNewsletter{ 

  private static String api_user = NewsNow__c.getInstance().SendGrid_com_Username__c;
  private static String api_key = NewsNow__c.getInstance().SendGrid_com_Password__c;
  private static String newsletter_endpoint = 'https://sendgrid.com/api/newsletter';
  private static String newsletter_identity_endpoint = newsletter_endpoint+'/identity';
  
  webService static String makeNewsletter(Id id) { 
        Newsletter__c n = [SELECT Id, Subject__c, HTML_Content__c, Text_Content__c FROM Newsletter__c WHERE Id = :id];
        List<String> ids = getIdentities();
        return null;
  }
  
  webService static List<String> getIdentities() {
  	List<String> ids = new List<String>();
  	String res = callOutSendGrid(null,newsletter_identity_endpoint+'/list.json','GET');
  	JSONParser parser = JSON.createParser(res);
  	while (parser.nextToken() != null) {
        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'identity')) {
            // Get the value. 
            parser.nextToken();
			ids.add(parser.getText());
        }
    }
    return ids;
  }
  
  webService static String getIdentity(String Id) {
  	String res = callOutSendGrid(null,newsletter_identity_endpoint+'/get.json?identity='+Id,'GET');
  	System.debug('==========================='+res);
    return res;
  }
  
  webService static Boolean identityExists(String Id) {
  	String res = callOutSendGrid(null,newsletter_identity_endpoint+'/list.json?identity='+Id,'GET');
  	if(res=='[]') {
  		return false;
  	} else {
    	return true;
  	}
  }
  
  webService static String createIdentity(Id Id) {
  	String res = '';
  	Identity__c i = [SELECT Old_Identity__c, Identity__c, Name__c, Email__c, Address__c, City__c, State__c, Zip__c, Country__c FROM Identity__c WHERE Id = :id];
  	String body  = 'name='+EncodingUtil.urlEncode(i.Name__c, 'UTF-8');
  		   body += '&email='+EncodingUtil.urlEncode(i.Email__c, 'UTF-8');
  		   body += '&address='+EncodingUtil.urlEncode(i.Address__c, 'UTF-8');
  		   body += '&city='+EncodingUtil.urlEncode(i.City__c, 'UTF-8');
  		   body += '&state='+EncodingUtil.urlEncode(i.State__c, 'UTF-8');
  		   body += '&zip='+EncodingUtil.urlEncode(i.Zip__c, 'UTF-8');
  		   body += '&country='+EncodingUtil.urlEncode(i.Country__c, 'UTF-8');
  		   body += '&identity='+EncodingUtil.urlEncode(i.Old_Identity__c, 'UTF-8');
  		   
  	if(identityExists(i.Old_Identity__c)) {	   
  		body += '&newidentity='+EncodingUtil.urlEncode(i.Identity__c, 'UTF-8');
  		res = callOutSendGrid(body,newsletter_identity_endpoint+'/edit.json','POST');	
  	} else {
  		res = callOutSendGrid(body,newsletter_identity_endpoint+'/add.json','POST');
  	}
  	
  	i.Old_Identity__c = i.Identity__c;
  	update i;
  	
    return res;
  }
  
  private static String callOutSendgrid(String body, String apiMethod, String httpMethod) {
  	Http h = new Http();
  	HttpRequest req = new HttpRequest();
  	
  	List<String> parts = apiMethod.split('\\?');
  	
  	if(body!=null) {
  		req.setBody(body);
  	}	
  	req.setEndpoint(parts[0] + '?api_user=' + api_user + '&api_key=' + api_key + (parts.size()==2 ? '&'+parts[1] : ''));
  	req.setMethod(httpMethod);
  	
  	HttpResponse res = h.send(req);
  	return res.getBody();
  }
}