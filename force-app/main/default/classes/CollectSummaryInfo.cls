/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a summary info object with a snapshot of the current state
	Called from: Batch process and CreateSummaryInfo VF page
	Tested in: TestCollectSummaryInfo
*/
public with sharing class CollectSummaryInfo 
{
    public CollectSummaryInfo ()
	{
		
	}
    
    public pageReference CollectNow ()
    {
    	try
    	{
	    	Summary_Information__c si = new Summary_Information__c ();
	    	si.Number_of_PPN_Members__c = [select count() from Account where Active__c = 'Yes'];
	    	CollectPeopleNumbers (si);
	    	CollectGroups (si);
	    	CollectCauses (si);
	    	CollectStructures (si);
	    	si.Date__c = system.today();
	    	insert si;
    	}
    	catch (Exception e)
		{
			Summary_Information__c errorInfo = new Summary_Information__c (Error__c='In CollectNow ' + e.getMessage());
			insert errorInfo;
		}
    	
    	return null;
    }
    
    public void CollectPeopleNumbers (Summary_Information__c si)
    {
    	AggregateResult[] summedResults = [SELECT SUM(Number_of_members_in_org__c) members, SUM(Number_of_other_staff_in_org__c) others, 
    		SUM(Number_of_paid_staff_in_org__c) paid, SUM(Number_of_volunteers_in_org__c) volunteers FROM Account where Active__c = 'Yes'];
		si.NumberofmembersinOrg__c = (Decimal)summedResults[0].get('members');
		si.NumberofOtherstaffinOrg__c = (Decimal)summedResults[0].get('others');
		si.NumberofPaidStaffinOrg__c = (Decimal)summedResults[0].get('paid');
		si.NumberofVolunteersinOrg__c = (Decimal)summedResults[0].get('volunteers');
    }
    
    public void CollectGroups (Summary_Information__c si)
    {
    	AggregateResult[] pillars = [select Group_Pillar__c, count(id) pillarCount from Account where Active__c = 'Yes' Group By Group_Pillar__c];
    	for (AggregateResult ar: pillars)
    	{
    		if ((String)ar.get('encppn1__Group_Pillar__c') == 'Community')
    		{
    			si.Groups_in_community_pillar__c = (Decimal)ar.get('pillarCount');
    		}
    		else if ((String)ar.get('encppn1__Group_Pillar__c') == 'Environment')
    		{
    			si.Groups_in_environment_pillar__c = (Decimal)ar.get('pillarCount');
    		}
    		else if ((String)ar.get('encppn1__Group_Pillar__c') == 'Social Inclusion')
    		{
    			si.Groups_in_social_inclusion_pillar__c = (Decimal)ar.get('pillarCount');
    		}
    	}
    }

    public void CollectCauses (Summary_Information__c si)
    {
    	map <String, String> causeLabelsToFields = getSummaryFieldsMap ('encppn1__Causes');
    	AggregateResult[] causes = [select What_is_the_main_cause_of_your_group__c, count(id) causeCount from Account where Active__c = 'Yes' Group By What_is_the_main_cause_of_your_group__c];
    	for (AggregateResult ar: causes)
    	{
    		String summaryLabel = (String)ar.get('encppn1__What_is_the_main_cause_of_your_group__c');
    		if (summaryLabel != null && summaryLabel != '')
    		{
    			String fieldName = causeLabelsToFields.get(summaryLabel);
    			if (fieldName != null)
    			{
    				si.put(fieldName, (Decimal)ar.get('causeCount'));
    			}
    		}
     	}
    }

    public void CollectStructures (Summary_Information__c si)
    {
    	map <String, String> structureLabelsToFields = getSummaryFieldsMap ('encppn1__Structures');
    	AggregateResult[] structures = [select Group_s_structure__c, count(id) structureCount from Account where Active__c = 'Yes' Group By Group_s_structure__c];
    	for (AggregateResult ar: structures)
    	{
    		String summaryLabel = (String)ar.get('encppn1__Group_s_structure__c');
    		if (summaryLabel != null && summaryLabel != '')
    		{
    			String fieldName = structureLabelsToFields.get(summaryLabel);
    			if (fieldName != null)
    			{
    				si.put(fieldName, (Decimal)ar.get('structureCount'));
    			}
    		}
     	}
    }

    public map <String, String> getSummaryFieldsMap(String fieldSetName) 
    {
    	Schema.FieldSet fs1 = Schema.SObjectType.Summary_Information__c.fieldSets.getMap().get(fieldSetName);
    	map <String, String> fieldLabelsToNames = new map <String, String>();
    	for (Schema.FieldSetMember oneField : fs1.getFields())
    	{
    		fieldLabelsToNames.put (oneField.getLabel(), oneField.getFieldPath());
    	}
    	return fieldLabelsToNames;
    }
    
}