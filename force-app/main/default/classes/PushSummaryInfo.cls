/*
	Author: Eamon Kelly, Enclude
	Purpose: Push all summary info objects created since last push
	Called from: Batch process and PushSummaryInfo VF page
	Tested in: TestPushSummaryInfo
*/
public with sharing class PushSummaryInfo 
{
	public Integer recordsPushed {get;set;}
	public PushSummaryInfo ()
	{
		
	}
	
	public pageReference PushNow ()
	{
		list<Summary_Information__c> sumsReadyToPush = [select Id from Summary_Information__c where Pushed__c = false limit 999];
		list<PartnerNetworkRecordConnection> sumsToPush = new list <PartnerNetworkRecordConnection>();

		list<PartnerNetworkConnection> connMap = [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection where ConnectionStatus = 'Accepted'];
		for (PartnerNetworkConnection oneConn : connMap)
		{
			for (Summary_Information__c oneSum : sumsReadyToPush)
			{
				PartnerNetworkRecordConnection newrecord = new PartnerNetworkRecordConnection();
				newrecord.ConnectionId = oneConn.Id;
				newrecord.LocalRecordId = oneSum.Id;  
				newrecord.SendEmails = false;   
				sumsToPush.add(newrecord);
				oneSum.Pushed__c = true;   
        	}
       }

		try
		{        
	        if (sumsToPush.size()> 0) 
	        {
	        	insert sumsToPush;
	        	update sumsReadyToPush;
	        	recordsPushed = sumsToPush.size();
	        }
	        else recordsPushed = 0;
		}
		catch (Exception e)
		{
			Summary_Information__c errorInfo = new Summary_Information__c (Error__c='In PushNow: ' + e.getMessage());
			insert errorInfo;
		}
        
        return null;
	} 
}