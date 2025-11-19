import { LightningElement,api,wire} from 'lwc';
import getTrainings  from '@salesforce/apex/TrainingServices.getTrainings';
import markTrainingComplete from '@salesforce/apex/TrainingServices.markTrainingComplete';

export default class TrainingList extends LightningElement {
    
    @api recordId;
    @api trainings;
    @wire(getTrainings,{recordId:'$recordId'})
    getTrainings(result){
        
        if(result.data){
            this.trainings=result.data;
        }
        if(result.error){
            console.log('error'+result.error);
        }
    }
    
    handleTraining(event){
        const trainingId=event.target.dataset.id;
        markTrainingComplete({trainingId:this.trainingId}).then(result=>{
            console.log('result'+result);
        }).catch(error=>{
            console.log('error'+error);
        });
}
}