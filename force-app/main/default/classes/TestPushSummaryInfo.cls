/*
	Author: Eamon Kelly, Enclude
	Purpose: Push all summary info objects created since last push
*/
@isTest
private class TestPushSummaryInfo {

    static testMethod void TestPush() 
    {
    	Summary_Information__c push1 = new Summary_Information__c (Groups_in_community_pillar__c=2, Date__c=system.today());
    	insert push1;
    	
    	PushSummaryInfo pushSums = new PushSummaryInfo(); 
      	pushSums.PushNow();
    	
    	list<Summary_Information__c>pushed = [select Pushed__c from Summary_Information__c where Pushed__c = true];
     }
}