({
	init: function (cmp, event, helper) {
        var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' }
        ];
        
        cmp.set('v.RLcolumns', [
            {label: 'Comment', fieldName: 'CommentBody', type: 'text', wrapText: true},
            {label: 'Created Date', fieldName: 'CreatedDate', type: 'date',
             typeAttributes: {year:'numeric', month:'numeric', day:'numeric', hour:'2-digit', minute:'2-digit'}, initialWidth:'200'},
            {label: 'Created By', fieldName: 'createByName', type: 'text', initialWidth:'200'},
            {type:  'action', typeAttributes: { rowActions: actions } }
        ]);
        helper.getData(cmp);
    },
    
	displayAddComment: function (cmp, event, helper) { 
        cmp.set("v.isEdit", false);
        cmp.set("v.isModalOpen", true);
    },
    
   	handleRowAction : function(cmp, event, helper){
    	//var selRows = event.getParam('selectedRows');
       	//let paramStr = JSON.stringify(event.getParams(), null, 4); 
		//console.log(paramStr);
       	var action = event.getParam('action');
       	//console.log('this is the action chosen:' + action);
       	//console.log('selAct -> ' + JSON.stringify(action));
    	var row = event.getParam('row');       
       	//console.log('this is the row:' + row);
       	//console.log('selRows -> ' + JSON.stringify(row));
       	var RowId = row.Id;  
       	var actionname = action.name;
        
        if(actionname === 'edit')  { 
           	//console.log('action name is: ' + actionname + ' record to be edited: ' + RowId);
            // Open the Modal Window to edit the Comments            
            cmp.set("v.isModalOpen", true);
            cmp.set("v.isEdit", true);
            helper.getComment(cmp, RowId);
        } 
        else if (actionname === 'delete')  { 
           	//console.log('action name is: ' + actionname + ' record to be deleted: ' + RowId);
           	var action2 = cmp.get("c.deleteCaseComment");
        	action2.setParams({
            	"commentId": RowId
         	});   
           	action2.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS")
                {
                    console.log("Successfully Removed..");
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Comment by ' + row.CreatedBy.Name + ' was deleted!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
               	}else if (state=="ERROR") {
                	console.log(action2.getError()[0].message);
                }
            });
         	$A.enqueueAction(action2);
        }
        else
        {
            console.log('No Op Action!');
        }
	},
    
    isRefreshed: function(cmp, event, helper) {
        location.reload();
    },
    
    closeModel: function(cmp, event, helper) {
      	// Set isModalOpen attribute to false  
      	cmp.set("v.isModalOpen", false);
        cmp.set("v.isEdit", false);
    },
    
    saveComment: function(cmp, event, helper) {
    	// Set isModalOpen attribute to false  
    	// If isEdit call Save Comment, otherwise create a New Comment
    	let commentBody = cmp.get("v.theComment");
        
        if (cmp.get("v.isEdit"))
        {
            console.log('Saving Comment ID: ' + cmp.get("v.commentId"));
            let id = cmp.get("v.commentId");        
            helper.saveComment(cmp, id, commentBody);
        }
        else
        {
            console.log('Saving Comment: ' + commentBody);
            helper.addComment(cmp, commentBody);
        }
        cmp.set("v.isModalOpen", false);    
        $A.get('e.force:refreshView').fire();
   }
})