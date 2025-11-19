import { LightningElement, track } from 'lwc';

export default class PersonalInformations extends LightningElement {
    @track handlePersonlInformation={};
    handlePersonlInfoChange(event){
        let fieldName = event.target.dataset.field;
        let fieldValue = event.target.value;
        console.log('fieldName', fieldName);
        console.log('fieldValue', fieldValue);
        this.handlePersonlInformation[fieldName] = fieldValue;
        console.log('this.handlePersonlInformation'+ JSON.stringify(this.handlePersonlInformation));
        this.updateResume();
    }

    updateResume(){
        let updateRsm=new CustomEvent('updateresume', {
            detail: this.handlePersonlInformation
        });
        this.dispatchEvent(updateRsm);
    }

}