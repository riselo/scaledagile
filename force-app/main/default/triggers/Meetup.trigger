trigger Meetup on Meetup__c (before insert) {
    MeetupTriggerHandler handler = new MeetupTriggerHandler();
    handler.OnBeforeInsert(trigger.New);
}

