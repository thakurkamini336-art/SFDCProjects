import { LightningElement,track } from 'lwc';

export default class ResumeBuilder extends LightningElement {
    
    @track personalinfo={};
    handleUpdateResume(event){
        this.personalinfo = event.detail;
        console.log('handleUpdateResume event'+JSON.stringify(event.detail));
    }
     Summary='';
    handleUpdateSummary(event){
        this.Summary = event.detail;
        console.log('event', event.detail);
    }

    @track skills=[];
    handleUpdateSkills(event){
        this.skills = event.detail;
        console.log('event', event.detail);
    }

    @track educations=[];
    handleUpdateEducation(event){
        this.educations = event.detail;
        console.log('event', event.detail);
    }

    @track workExperiences=[];
    handleUpdateWorkExperiences(event){
        this.workExperiences = event.detail;
        console.log('event', event.detail);
    }
}