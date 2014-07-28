trigger submitContactData on Contact (after insert) {

  for (Contact c : Trigger.new) {
    
    JSONGenerator generator = JSON.createGenerator(true);   //instantiation of the generator
    generator.writeStartObject();               // Writes the starting marker of a JSON object '{'
    generator.writeStringField('title', 'CEO');   //Writes the # of contacts
    generator.writeStringField('firstName', c.firstname);  
    generator.writeStringField('lastName', c.lastname);  
    generator.writeStringField('email', c.email);  
    generator.writeStringField('msg_type', 'ceo alert');  
    generator.writeEndObject();                 //Writes the ending marker of a JSON object '}'
    String jsonString = generator.getAsString();
        
    System.debug('>>>>'+jsonString);
    
    ContactUpdater.sendContactData(jsonString);
               
    
  }
  
  
  
}