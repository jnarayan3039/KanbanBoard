  
import { LightningElement, api } from 'lwc';

export default class CattRequest extends LightningElement {
    @api task;
    
    get className(){
        return (this.task.status__c == 'In Progress' ? 'draggable card progress':'draggable card complete');
    }

    itemDragStart() {
        const event = new CustomEvent('itemdrag', {
            detail: this.task.Id
        });

        this.dispatchEvent(event);
    }
}