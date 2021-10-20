public with sharing class MeetupRegistrationController {
    
    @AuraEnabled
    public static Meetup__c getMeetupByCode(String registrationCode) {
        Meetup__c meetup;

        try {
            meetup = [SELECT Id, Name, Status__c, RegistrationLimit__c FROM Meetup__c WHERE RegistrationCode__c =: registrationCode];
        } catch (Exception e) {
            AuraHandledException auraException = new AuraHandledException('No meetup with registration code: ' + registrationCode);
            auraException.setMessage('No meetup with registration code: ' + registrationCode);
            throw auraException;
        }
            
        if (meetup.Status__c == 'Closed') {
            AuraHandledException auraException = new AuraHandledException('The selected meetup has a status of \'Closed\'');
            auraException.setMessage('The selected meetup has a status of \'Closed\'');
            throw auraException;
        }

        if (!validateSpace(meetup)) {
            AuraHandledException auraException = new AuraHandledException('The selected meetup has no space remaining');
            auraException.setMessage('The selected meetup has no space remaining');
            throw auraException;            
        }

        return meetup;
    }

    @AuraEnabled
    public static List<MeetupRegistration__c> getMeetupRegistrationEmails(String meetupId) {
        List<MeetupRegistration__c> registrations = [SELECT Email__c FROM MeetupRegistration__c WHERE Meetup__c =: meetupId];

        return registrations;
    }

    @TestVisible
    private static Boolean validateSpace(Meetup__c meetup) {
        Integer count = [SELECT COUNT() FROM MeetupRegistration__c WHERE Meetup__c =: meetup.Id];

        return meetup.RegistrationLimit__c > count;
    }
}