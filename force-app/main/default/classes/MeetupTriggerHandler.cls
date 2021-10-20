public with sharing class MeetupTriggerHandler {

    private static integer registrationCodeFieldLength = 8;

    public MeetupTriggerHandler() {}

    public void OnBeforeInsert(List<Meetup__c> newMeetups) {
        for (Meetup__c meetup : newMeetups) {
            meetup.RegistrationCode__c = getRandomRegistrationCode();
        }
    }

    @TestVisible
    private static string getRandomRegistrationCode() {
        string registrationCode = '';

        while (registrationCode.length() < registrationCodeFieldLength) {
            registrationCode += getRandomAlphaNumericCharacter();
        }

        return registrationCode;
    }

    @TestVisible
    private static string getRandomAlphaNumericCharacter() {
        integer randomNumber = integer.valueOf(Math.random() * 3);
        string randomChar = '';

        switch on randomNumber {
            when 0 {
                randomChar = getRandomNumber();
            }
            when 1 {
                randomChar = getRandomUpperCase();
            }
            when 2 {
                randomChar = getRandomLowerCase();
            }
        }

        return randomChar;
    }

    @TestVisible
    private static string getRandomNumber() {
        integer randomNumber = integer.valueOf(Math.random() * 9);
        return String.valueOf(randomNumber);
    }

    @TestVisible
    private static string getRandomUpperCase() {
        // ASCII Upper Case 65 - 90
        integer randomUpperCaseAscii = integer.valueOf(Math.random() * 26 + 65);
        return String.fromCharArray(new List<integer> { randomUpperCaseAscii });
    }

    @TestVisible
    private static string getRandomLowerCase() {
        // ASCII Lower Case 97 - 122
        integer randomLowerCaseAscii = integer.valueOf(Math.random() * 26 + 97);
        return String.fromCharArray(new List<integer> { randomLowerCaseAscii });
    }
}