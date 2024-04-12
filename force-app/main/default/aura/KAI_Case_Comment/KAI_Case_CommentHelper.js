({
    getData : function(cmp) {
        var caseId = cmp.get("v.recordId");
		console.log('entered casecomments1 getData, caseId - '+ caseId);		       
        var action = cmp.get('c.getCaseComments');
        action.setParams({
            "caseId": caseId
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var commentslist = response.getReturnValue();				
                var element;
                for (var i = 0; i < commentslist.length; i++) {
                    element = commentslist[i];
                    element.createByName = element.CreatedBy.Name;
					//console.log('commentslist CreatedBy- '+ element.CreatedBy.Name);
				}                
                cmp.set("v.commentsdata", commentslist);
            } else if (state === "ERROR") {
                console.log('state - '+ state);
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
    getComment : function(cmp, commentId) {
		console.log('Get Case Comment, CommentId - '+ commentId);
        var updateCommentAction = cmp.get("c.getCaseComment");
            updateCommentAction.setParams({
                "commentId": commentId
        });
        updateCommentAction.setCallback(this, $A.getCallback(function (response) {
            var updateState = response.getState();
            if (updateState === "SUCCESS") {
                let caseComment = response.getReturnValue();
                console.log('Comments: ' + caseComment.CommentBody);                
                cmp.set("v.theComment", caseComment.CommentBody);                    
                cmp.set("v.commentId", commentId); 
            } else if (updateState === "ERROR") {
                console.log('state - '+ updateState);
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(updateCommentAction);       
    },
    
    saveComment : function(cmp, commentId, caseComment) {
		console.log('Save Case Comment, CommentId - '+ commentId);
        console.log('comment: ' + caseComment);
        var saveCommentAction = cmp.get("c.updateCaseComment");
            saveCommentAction.setParams({
                "commentId": commentId,
                "commentBody": caseComment
        });
        // Configure the response handler for the action
        saveCommentAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('saved');
            }
            else if (state === "ERROR") {
                console.log('Problem saving comment, response state: ' + state);
            }
            else {
                console.log('Unknown problem, response state: ' + state);
            }            
        });        
        // Send the request to save the comment
        $A.enqueueAction(saveCommentAction);         
    },
    
    addComment : function(cmp, caseComment) {
        console.log('AddComment Parent ID: ' + cmp.get("v.recordId"));        
        // Prepare the action to create new case comment
        var addCommentAction = cmp.get("c.addCaseComment");
        addCommentAction.setParams({
            "commentBody": caseComment,
            "caseId": cmp.get("v.recordId")
        });        
        // Configure the response handler for the action
        addCommentAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log('added');
            }
            else if (state === "ERROR") {
                console.log('Problem saving contact, response state: ' + state);
            }
            else {
                console.log('Unknown problem, response state: ' + state);
            }
             $A.get("e.force:closeQuickAction").fire() 
        });        
        // Send the request to create the new comment
        $A.enqueueAction(addCommentAction);        
    }
})