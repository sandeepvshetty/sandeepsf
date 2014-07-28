public with sharing class AccountPagination {

    private final Account acct;
    public String name { get; set; }


    public AccountPagination(ApexPages.StandardSetController controller) {

    }        
    
    public ApexPages.StandardSetController accountRecords{
        get {return accountRecords;}
        private set;
    }
    
    public void search() {
        accountRecords = new ApexPages.StandardSetController(Database.getQueryLocator(
                [SELECT Id,Name,createddate FROM ACCOUNT WHERE firstname = :name]));
    }
    
    public List<Account> getAccountPagination() {
        if(accountRecords!=null) {
             return (List<Account>) accountRecords.getRecords();
        }
        return null;
    }  

}