import { LightningElement } from 'lwc';

export default class Summary extends LightningElement {
     Summary='';
    handleSummary(event){
       // let fieldName = event.target.dataset.field;
        this.Summary = event.target.value;
        
        console.log('this.Summary', this.Summary);
        this.updateResume();
    }

    updateResume(){
        let updatesummaryevt=new CustomEvent('updatesummary', {
            detail: this.Summary
        });
        this.dispatchEvent(updatesummaryevt);
    }
}