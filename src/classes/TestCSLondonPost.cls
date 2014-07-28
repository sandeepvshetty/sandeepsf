public class TestCSLondonPost {
    
    @future(callout=true)
    public static void postOpportunity(String id) {
       
        Id oppId = (Id)id;
       
        Opportunity opp = [SELECT Account.name, Id, Amount FROM Opportunity WHERE Id = :oppId LIMIT 1];
        
        JSONGenerator gen = JSON.createGenerator(true);
        
        Http http = new HTTP();
        
        HttpRequest req = new HttpRequest();
        
        String body = '{"Name":"'+opp.account.name+'", "Id":"'+oppId+'", "Amount":"'+opp.Amount+'"}';    
        
        //gen.writeObjectField('Name', opp.account.name);
        //gen.writeObjectField('Id', oppId);
        //gen.writeObjectField('Amount', opp.Amount);
        
        System.debug(body);
        
        req.setHeader('content-type', 'application/json');
        
        req.setMethod('POST');
        req.setHeader('Content-Length', String.valueOf(body.length()));
        req.setEndpoint('http://cs12london.herokuapp.com/');
        req.setBody(body);

        HttpResponse resp = http.send(req);
        
        System.debug('@@@@@@@@@@'+resp.getBody());

    
    }
    
}