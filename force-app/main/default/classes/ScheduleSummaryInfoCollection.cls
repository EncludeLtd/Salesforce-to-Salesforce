/*
Author: Eamon Kelly, Enclude
Purpose: Collect the summary info
Called from: Scheduler
*/
global class ScheduleSummaryInfoCollection implements Schedulable
{
   global void execute(SchedulableContext SC) 
   {
        CollectSummaryInfo csi = new CollectSummaryInfo ();
        csi.CollectNow();
   }
}