public class InterviewController {

    public String name { get; set; }
    public List<Account> accts { get; set; }

    public PageReference search() {
        accts = [SELECT Id,Name,createddate FROM ACCOUNT WHERE firstname = :name LIMIT 10];
        return null;
    }

}