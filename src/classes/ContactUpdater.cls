public class ContactUpdater {

  @Future(callout=true)
  public static void sendContactData(String json) {

        HttpRequest req = new HttpRequest();
 
        //Set HTTPRequest Method
        req.setMethod('POST');
   
  //Set HTTPRequest header properties
  req.setHeader('Content-Type', 'application/json');
  req.setHeader('Content-Length',String.valueOf(json.length()));
  req.setHeader('Host','forceminihack.herokuapp.com');
  req.setEndpoint('http://forceminihack.herokuapp.com');
   
  //Set the HTTPRequest body 
  req.setBody(json); 
   
  Http http = new Http();
   
        //Execute web service call here      
        HTTPResponse res = http.send(req);   
   
        //Helpful debug messages
        System.debug(res.toString());
        System.debug('Body:'+res.getBody());
        System.debug('STATUS:'+res.getStatus());
        System.debug('STATUS_CODE:'+res.getStatusCode());
    
  }

}