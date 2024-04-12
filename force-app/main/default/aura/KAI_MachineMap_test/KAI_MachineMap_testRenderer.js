({
    afterRender: function(component, helper) {
        //var svg = component.find("svg_content");
        //var value = svg.getElement().innerText;
        //value = value.replace("<![CDATA[", "").replace("]]>", "").replace(/a id/g, "a onclick");
        //svg.getElement().innerHTML = value;        
 
        var JSON = component.get("v.JSONDATA");
        
        var objectList = JSON.split('"name"');
        //console.log(objectList);

        var mName = [];        
        var mSource = [];
        var mScale = [];
        var mLoc = [];
        var mLocX = [];
        var mLocY = [];
        var mObjectId = [];
        var mText = [];
        var mRotate = [];
      
        var mRecord = [];

        var counter1 = 0;
        var counter2 = 0;
        
        objectList.forEach(function(entry) {
			mRecord = entry.split(',');
        
            mName[counter1] = '';
            mSource[counter1] = '';
            mScale[counter1] = '';
            mLoc[counter1] = '';
            mLocX[counter1] = '';
            mLocY[counter1] = '';
            mObjectId[counter1] = '';
            mText[counter1] = '';
        	mRotate[counter1] = '';
            
            counter2 = 0;
            mRecord.forEach(function(cellentry) {
                cellentry = cellentry.replaceAll('"','');
                
                if (counter2==0){mName[counter1] = cellentry.replace(/:/g,'');}
                if ( cellentry.includes('source:') ){ mSource[counter1] = cellentry.replace(/source:/g,'').replace(/ /g,''); }
                if ( cellentry.includes('imageScale:') ){ mScale[counter1] = cellentry.replace(/imageScale:/g,'').replace(/ /g,''); }
                if ( cellentry.includes('loc:') ){ mLoc[counter1] = cellentry.replace(/loc:/g,'x=').replace(/ /g,'" y="').replace(/" y="x=/g,''); }
                if ( cellentry.includes('objectId:') ){ mObjectId[counter1] = cellentry.replace(/objectId:/g,'').replace(/ /g,''); }
                if ( cellentry.includes('text:') ){ mText[counter1] = cellentry.replace(/text:/g,''); }
                if ( cellentry.includes('rotate:') ){ mRotate[counter1] = cellentry.replace(/rotate:/g,'').replace(/ /g,''); }
                 
                counter2++;
            });

			counter1++;           
		});
       
        //console.log(mName);        
        console.log(mSource);
        //console.log(mScale);
        //console.log(mLoc);
        //console.log(mObjectId);
        //console.log(mText);
        //console.log(mRotate);

        
        var canvas = document.getElementById('canvas1');
        //console.log(canvas);
		var context = canvas.getContext("2d");
		//context.moveTo(0, 0);
		//context.lineTo(200, 100);
		//context.stroke();
        //context.beginPath();
		//context.arc(95, 50, 40, 0, 2 * Math.PI);
		//context.stroke();
        
        
        //var base_image=[];
        /*
        var x=1;
        //for (var x=1;x<10;x++){
        	base_image[x] = new Image();
  			base_image[x].src = 'https://kadantportal.force.com/psgeagent'+'/resource/1502889118000/Fan_Shower';
        	base_image[x].onload = function(){
  				context.drawImage(base_image[x], 100*x, 100*x);
        	}
        //}
        */
        
        counter1 = 0;
                
        mSource.forEach(function(entry) {
        	//base_image[counter1] = new Image();
  			//base_image[counter1].src = 'https://kadantportal.force.com/psgeagent'+'/resource/1502889118000/Fan_Shower';
        	//base_image[counter1].onload = function(){
  			//	context.drawImage(base_image[counter1], 100, 100);
        	//}
            
            var base_image = new Image();
  			base_image.src = 'https://kadantportal.force.com/psgeagent'+mSource[counter1];
            base_image.on('click', function(){ console.log('image was clicked');});
        	base_image.onload = function(){
  				context.drawImage(base_image, 100, 100);
        	}
            counter1++;
            
        });
		console.log(base_image);
    }
})