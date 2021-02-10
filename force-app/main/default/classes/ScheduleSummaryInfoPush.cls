/*
Author: Eamon Kelly, Enclude
Purpose: Send the summary info to the hub
Called from: Scheduler
*/
global class ScheduleSummaryInfoPush implements Schedulable
{
   global void execute(SchedulableContext SC) 
   {
    	PushSummaryInfo pushSums = new PushSummaryInfo(); 
      	pushSums.PushNow();
   }
}