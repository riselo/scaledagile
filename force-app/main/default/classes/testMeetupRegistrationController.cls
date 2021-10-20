@isTest(SeeAllData=false)
public class testMeetupRegistrationController {
    @TestSetup
    static void init() {
        Meetup__c openMeetup = new Meetup__c (
            Name = 'Nuggets Game 1',
            Status__c = 'Open',
            RegistrationLimit__c = 1
        );

        Meetup__c closedMeetup = new Meetup__c (
            Name = 'Nuggets Game 2',
            Status__c = 'Closed',
            RegistrationLimit__c = 1
        );

        Meetup__c fullMeetup = new Meetup__c (
            Name = 'Nuggets Game 3',
            Status__c = 'Open',
            RegistrationLimit__c = 0
        );

        insert openMeetup; 
        insert closedMeetup;
        insert fullMeetup;
    }

    @isTest
    static void testGetMeetupByCode_NoMeetupFoundWithRegistraionCode_ThrowsException() {
        Test.startTest();
        
            try {
                Meetup__c meetup = MeetupRegistrationController.getMeetupByCode('');
            } catch (Exception ex) {
                System.assertEquals('No meetup with registration code: ', ex.getMessage());
            }

        Test.stopTest();
    }

    @isTest
    static void testGetMeetupByCode_SelectedMeetupIsClosed_ThrowsException() {
        Test.startTest();
        
            try {
                Meetup__c closedMeetup = [SELECT RegistrationCode__c FROM Meetup__c WHERE Name = 'Nuggets Game 2'];
                Meetup__c meetup = MeetupRegistrationController.getMeetupByCode(closedMeetup.RegistrationCode__c);
            } catch (Exception ex) {
                System.assertEquals('The selected meetup has a status of \'Closed\'', ex.getMessage());
            }

        Test.stopTest();
    }

    @isTest
    static void testGetMeetupByCode_SelectedMeetupIsFull_ThrowsException() {
        Test.startTest();
        
            try {
                Meetup__c fullMeetup = [SELECT RegistrationCode__c FROM Meetup__c WHERE Name = 'Nuggets Game 3'];
                Meetup__c meetup = MeetupRegistrationController.getMeetupByCode(fullMeetup.RegistrationCode__c);
            } catch (Exception ex) {
                System.assertEquals('The selected meetup has no space remaining' , ex.getMessage());
            }

        Test.stopTest();
    }

    @isTest
    static void testGetMeetupByCode_SelectedMeetupIsAvailabled_ReturnsMeeetup() {
        Test.startTest();

            Meetup__c openMeetup = [SELECT Id, RegistrationCode__c FROM Meetup__c WHERE Name = 'Nuggets Game 1'];
            Meetup__c actualMeetup = MeetupRegistrationController.getMeetupByCode(openMeetup.RegistrationCode__c);

            System.assertEquals(openMeetup.Id, actualMeetup.Id);

        Test.stopTest();
    }
}