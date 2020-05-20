import { LightningElement, track, wire } from 'lwc';
//import { tasks } from 'data/dataService';
import getCattRequests from '@salesforce/apex/CattUtility.getCattRequests';

export default class KanbanBoard extends LightningElement {
    @track error;
    @track leftTasks = [];
    @track rightTasks = [];
    @track draggingid = "";
    
    @track tasklist = [];
    @wire(getCattRequests) 
    getRequests({error, data}) {
        if(data){
            this.tasklist=data;
            this.error=undefined;
            let curLeftTasks = [];
            let curRightTasks = [];
            console.log("Task List:"+this.tasklist.length);
            this.tasklist.forEach(function(t){
                console.log("Status:"+t.Status__c);
                if(t.Status__c === "In Progress") {
                    curLeftTasks.push(t);
                } else {
                    curRightTasks.push(t);
                }
            });

            this.leftTasks = curLeftTasks;
            this.rightTasks = curRightTasks;
        }
        else if (error) {
            this.error = error;
            this.contacts = undefined;
        }
        
    }
        
    /*connectedCallback() {
        this.distributeTasks();
        this.tasklist = tasks;
    }*/

    distributeTasks() {
        let curLeftTasks = [];
        let curRightTasks = [];
        
        this.tasklist.forEach(function(t){
            if(t.Status__c === "In Progress") {
                curLeftTasks.push(t);
            } else {
                curRightTasks.push(t);
            }
        });

        this.leftTasks = curLeftTasks;
        this.rightTasks = curRightTasks;
    }

    handleDragOver(evt) {
        evt.preventDefault();
    }

    handleListItemDrag(evt) {
        console.log('Dragged id is: ' + evt.detail);
        this.draggingid = evt.detail;
    }

    handleItemDrop(evt) {
        console.log(evt);
        let id = this.draggingid;
        let category = evt.detail;
        console.log("category:"+category)
        let tasks1 = this.tasklist.filter((task) => {
			if (task.id === id) {
                task.Status__c = category;           
			}              
			return task;       
		});
        console.log(tasks1);
        this.tasklist = tasks1;
        this.distributeTasks();
    }
}