import { LightningElement,track } from 'lwc';

export default class Skills extends LightningElement {
  @track skills=[{
        id:0,
        name:''
    }];

    handleSkillChange(event){
        let index = event.target.dataset.index;
        console.log('index', index);
        //let value = event.target.value;
        this.skills[index].name= event.target.value;
        console.log('this.skills', this.skills);
        console.log('this.skills', this.skills[0]);
        this.updateResume();
    }
    updateResume(){
        let updateskillevt=new CustomEvent('updateskill', {
            detail: this.skills
        });
        this.dispatchEvent(updateskillevt);
    }
    addSkill(){
        let nextIndex = this.skills.length;
        this.skills.push({
            id:nextIndex,
            name:''
        });
    }
}
      