import { LightningElement,track } from 'lwc';

export default class EductionDetail extends LightningElement {
    @track educations=[{
        id:0,
        degree:'',
        institute:'',
        year:''
    }];
    handleEducationDetailsChange(event){
        let index = event.target.dataset.index;
        let fieldName = event.target.dataset.field;
        let fieldValue = event.target.value;
        console.log('fieldName', fieldName);
        console.log('fieldValue', fieldValue);
        this.educations[index][fieldName] = fieldValue;
        console.log('this.educations', this.educations);
    
        // if(fieldName=='degree'){
        //     this.educations[index].degree= event.target.value;
        // }
        // if(fieldName=='institute'){
        //     this.educations[index].institute= event.target.value;
        // }
        // if(fieldName=='year'){
        //     this.educations[index].year= event.target.value;
        // }

        this.updateResume();

    }
    updateResume(){
        let updateduevt=new CustomEvent('updateeducation', {
            detail: this.educations
        });
        this.dispatchEvent(updateduevt);
    }
    addEducations(){
        let nextIndex = this.educations.length;
        this.educations.push({
            id:nextIndex,
            degree:'',
            institute:'',
            year:''
        });
    }
    
    
        
}