import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getMeetupByCode from '@salesforce/apex/MeetupRegistrationController.getMeetupByCode';
import getMeetupRegistrationEmails from '@salesforce/apex/MeetupRegistrationController.getMeetupRegistrationEmails';

import MEETUP_REGISTRATION_OBJECT from '@salesforce/schema/MeetupRegistration__c';
import MEETUP_FIELD from '@salesforce/schema/MeetupRegistration__c.Meetup__c';
import FIRST_NAME_FIELD from '@salesforce/schema/MeetupRegistration__c.FirstName__c';
import LAST_NAME_FIELD from '@salesforce/schema/MeetupRegistration__c.LastName__c';
import EMAIL_FIELD from '@salesforce/schema/MeetupRegistration__c.Email__c';

export default class MeetupRegistation extends LightningElement {
    
    currentPageReference;
    meetupName;
    meetup;
    registeredEmails = [];

    @track firstName = '';
    @track lastName = '';
    @track email = '';

    @wire(CurrentPageReference)
    receivePageReference(result) {
        this.currentPageReference = result;

        if (this.currentPageReference.state.c__registrationcode) {
            getMeetupByCode({ registrationCode: this.currentPageReference.state.c__registrationcode })
                .then(result => {
                    this.meetup = result;
                    this.meetupName = result.Name;
                    this.populateAlreadyRegisteredEmails(result.Id);
                })
                .catch(error => {
                    this.showError(error)
                });
        }
    }

    register() {
        if (!this.isDuplicateEmail()) {
            const fields = this.getFields();
            const recordInput = { apiName: MEETUP_REGISTRATION_OBJECT.objectApiName, fields };

            createRecord(recordInput)
                .then(() => {
                    this.firstName = '';
                    this.lastName = '';
                    this.email = '';
                    this.showSuccess();
                })
                .catch(error => {
                    this.showError(error);
                });
        } else {
            this.showError({body: new Error(`${this.email} is already registered for this meetup`)});
        }
    }

    isDuplicateEmail() {
        return this.registeredEmails.includes(this.email);
    }

    populateAlreadyRegisteredEmails(meetupId) {
        getMeetupRegistrationEmails({ meetupId: meetupId })
            .then(registrations => {
                this.registeredEmails = registrations.map(registration => registration.Email__c);
            });
    }

    getFields() {
        const fields = {};

        fields[MEETUP_FIELD.fieldApiName] = this.meetup.Id;
        fields[FIRST_NAME_FIELD.fieldApiName] = this.firstName;
        fields[LAST_NAME_FIELD.fieldApiName] = this.lastName;
        fields[EMAIL_FIELD.fieldApiName] = this.email;

        return fields;
    }

    updateFirstName(event) {
        this.firstName = event.target.value;
    }

    updateLastName(event) {
        this.lastName = event.target.value;
    }

    updateEmail(event) {
        this.email = event.target.value;
    }

    showError(error) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message,
                mode: 'sticky'
            })
        );
    };

    showSuccess() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Sucessfuly Registered',
                variant: 'success'
            })
        );
    };

    get buttonDisabled() {
        return !(this.firstName.length > 0 && this.firstName.length < 40 &&
            this.lastName.length > 0 && this.lastName.length < 80 &&
            this.email.length > 0);
    }
}