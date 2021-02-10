/*
	Author: Eamon Kelly, Enclude
	Purpose: Create a summary info object with a snapshot of the current state
*/
@isTest
private class TestCollectSummaryInfo 
{
    static testMethod void collectionGroupTest() 
    {
        Account ac1 = new Account(Name = 'Test1', Group_Pillar__c='Community', Group_s_structure__c='Affiliated', Active__c='Yes');
        insert ac1;
        Account ac2 = new Account(Name = 'Test2', Group_Pillar__c='Community', Group_s_structure__c='Charity', Active__c='Yes');
        insert ac2;
        Account ac3 = new Account(Name = 'Test3', Group_Pillar__c='Environment', Group_s_structure__c='Charity', Active__c='Yes');
        insert ac3;
        Account ac4 = new Account(Name = 'Test4', Group_Pillar__c='Social Inclusion', Active__c='Yes');
        insert ac4;
        CollectSummaryInfo csi = new CollectSummaryInfo ();
        csi.CollectNow();
        
        Summary_Information__c siCreated = [select Number_of_PPN_Members__c, Groups_in_community_pillar__c, Groups_in_environment_pillar__c, Groups_in_social_inclusion_pillar__c, Date__c, Source__c from Summary_Information__c limit 1];
        system.assertEquals (4, siCreated.Number_of_PPN_Members__c);
        system.assertEquals (2, siCreated.Groups_in_community_pillar__c);
        system.assertEquals (1, siCreated.Groups_in_environment_pillar__c);
        system.assertEquals (1, siCreated.Groups_in_social_inclusion_pillar__c);
        system.assertEquals (system.today(), siCreated.Date__c);
        system.assert (siCreated.Source__c != null);
    }

    static testMethod void collectionStructureTest() 
    {
        Account ac1 = new Account(Name = 'Test1', Group_s_structure__c='Affiliated', Active__c='Yes');
        insert ac1;
        Account ac2 = new Account(Name = 'Test2', Group_s_structure__c='Charity', Active__c='Yes');
        insert ac2;
        Account ac3 = new Account(Name = 'Test3', Group_s_structure__c='Charity', Active__c='Yes');
        insert ac3;
        Account ac4 = new Account(Name = 'Test4', Group_s_structure__c='Charity', Active__c='No');
        insert ac4;
        CollectSummaryInfo csi = new CollectSummaryInfo ();
        csi.CollectNow();
        
        Summary_Information__c siCreated = [select Affiliated__c, Animals__c, Charity__c from Summary_Information__c];
        system.assertEquals (0, siCreated.Animals__c);
        system.assertEquals (2, siCreated.Charity__c);
        system.assertEquals (1, siCreated.Affiliated__c);
    }
    
    static testMethod void collectionCauseTest() 
    {
        Account ac1 = new Account(Name = 'Test1', What_is_the_main_cause_of_your_group__c='Homelessness/ Housing', Active__c='Yes');
        insert ac1;
        Account ac2 = new Account(Name = 'Test2', What_is_the_main_cause_of_your_group__c='LGBT', Active__c='Yes');
        insert ac2;
        Account ac3 = new Account(Name = 'Test3', What_is_the_main_cause_of_your_group__c='LGBT', Active__c='Yes');
        insert ac3;
        Account ac4 = new Account(Name = 'Test4', What_is_the_main_cause_of_your_group__c='LGBT', Active__c='No');
        insert ac4;
        CollectSummaryInfo csi = new CollectSummaryInfo ();
        csi.CollectNow();
        
        Summary_Information__c siCreated = [select HomelessnessHousing__c, CrimeSafety__c, LGBT__c from Summary_Information__c];
        system.assertEquals (0, siCreated.CrimeSafety__c);
        system.assertEquals (2, siCreated.LGBT__c);
        system.assertEquals (1, siCreated.HomelessnessHousing__c);
    }
    
    static testMethod void collectionPeopleNumbersTest() 
    {
        Account ac1 = new Account(Name = 'Test1', Number_of_members_in_org__c=20, Number_of_other_staff_in_org__c=10, Number_of_paid_staff_in_org__c=5, Number_of_volunteers_in_org__c=40, Active__c='Yes');
        insert ac1;
        Account ac2 = new Account(Name = 'Test2', Number_of_members_in_org__c=20, Number_of_other_staff_in_org__c=10, Number_of_paid_staff_in_org__c=5, Number_of_volunteers_in_org__c=40, Active__c='Yes');
        insert ac2;
        Account ac3 = new Account(Name = 'Test3', Number_of_members_in_org__c=20, Number_of_other_staff_in_org__c=10, Number_of_paid_staff_in_org__c=5, Number_of_volunteers_in_org__c=40, Active__c='Yes');
        insert ac3;
        Account ac4 = new Account(Name = 'Test4', Number_of_members_in_org__c=20, Number_of_other_staff_in_org__c=10, Number_of_paid_staff_in_org__c=5, Number_of_volunteers_in_org__c=40, Active__c='No');
        insert ac4;
        Account ac5 = new Account (Name='NullTest', Active__c='Yes');
        insert ac5;
        
        CollectSummaryInfo csi = new CollectSummaryInfo ();
        csi.CollectNow();
        
        Summary_Information__c siCreated = [select NumberofmembersinOrg__c, NumberofOtherstaffinOrg__c, NumberofPaidStaffinOrg__c, NumberofVolunteersinOrg__c from Summary_Information__c];
        system.assertEquals (60, siCreated.NumberofmembersinOrg__c);
        system.assertEquals (30, siCreated.NumberofOtherstaffinOrg__c);
        system.assertEquals (15, siCreated.NumberofPaidStaffinOrg__c);
        system.assertEquals (120, siCreated.NumberofVolunteersinOrg__c);
    }
}