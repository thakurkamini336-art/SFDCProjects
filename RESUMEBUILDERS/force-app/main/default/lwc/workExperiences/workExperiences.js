import { LightningElement,track } from 'lwc';

export default class WorkExperiences extends LightningElement {
    @track workExperiences=[{
        id:0,
        jobTitle:'',
        company:'',
        startDate:'',
        endDate:''
    }];

    handleWorkExperienceChange(event){
        let index = event.target.dataset.index;
        let fieldName = event.target.dataset.field;
        let fieldValue = event.target.value;
        this.workExperiences[index][fieldName]= fieldValue;
        console.log('this.workExperiences'+ JSON.stringify(this.workExperiences) );
        this.updateResume();
    }
    updateResume(){
        let updateworkexp=new CustomEvent('updateworkexperience', {
            detail: this.workExperiences
        });
        this.dispatchEvent(updateworkexp);
    }
    addExperience(){
        let nextIndex = this.workExperiences.length;
        this.workExperiences.push({
            id:nextIndex,
            jobTitle:'',
            company:'',
            startDate:'',
            endDate:''

        });
    }
}