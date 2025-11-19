import { LightningElement,api } from 'lwc';

export default class PreviewResume extends LightningElement {

    renderedCallback(){
        console.log('personal Info'+ JSON.stringify(this.personalInfo) );
    }
    @api personalInfo;
    @api summary;
    @api skills;
    @api workExperiences;
    @api educations;
}