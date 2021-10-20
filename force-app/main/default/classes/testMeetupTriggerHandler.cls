@isTest(SeeAllData=false)
public class testMeetupTriggerHandler {

    @isTest
    static void testGetRandomRegistrationCode_ReturnsStringOfLengthEight() {
        integer expectedLength = 8;

        Test.startTest();
        
            integer actualLength = MeetupTriggerHandler.getRandomRegistrationCode().length();   
            System.assertEquals(expectedLength, actualLength);

        Test.stopTest();
    }

    @isTest
    static void testGetRandomAlphaNumericCharacter_ReturnsARandomAlphanumricCharacter() {
        String expepectedPossibleValues = '0123456789ABCDEFGHIJKLMNOPQRXSTUVWXYZabcdefghijklmnopqrstuvwxyz';

        Test.startTest();
        
            String actualRandomCharacter = MeetupTriggerHandler.getRandomAlphaNumericCharacter();
            System.assert(expepectedPossibleValues.contains(actualRandomCharacter));

        Test.stopTest();
    }


    @isTest
    static void testGetRandomNumber_ReturnsAStringValueOfRandomNumberBetweenZeroAndNine() {
        String expepectedPossibleValues = '0123456789';

        Test.startTest();
        
            String actualRandomNumber = MeetupTriggerHandler.getRandomNumber();
            System.assert(expepectedPossibleValues.contains(actualRandomNumber));

        Test.stopTest();
    }

    @isTest
    static void testGetRandomUpperCaseValue_ReturnsAUpperCaseCharacter() {
        String expepectedPossibleValues = 'ABCDEFGHIJKLMNOPQRXSTUVWXYZ';

        Test.startTest();
        
            String actualUpperCaseCharacter = MeetupTriggerHandler.getRandomUpperCase();
            System.assert(expepectedPossibleValues.contains(actualUpperCaseCharacter));

        Test.stopTest();
    }

    @isTest
    static void testGetRandomLowerCaseValue_ReturnsALowerCaseCharacter() {
        String expepectedPossibleValues = 'abcdefghijklmnopqrstuvwxyz';

        Test.startTest();
        
            String actualLowerCaseCharacter = MeetupTriggerHandler.getRandomLowerCase();
            System.assert(expepectedPossibleValues.contains(actualLowerCaseCharacter));

        Test.stopTest();
    }
}