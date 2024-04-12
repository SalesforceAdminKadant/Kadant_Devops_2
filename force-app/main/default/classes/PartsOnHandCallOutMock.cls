@isTest
global class PartsOnHandCallOutMock implements HTTPCalloutMock {
    // Creating a fake response
    global HTTPResponse respond(HTTPRequest request) {
        HTTPResponse response = new HTTPResponse();
        // Setting the response body
        response.setBody('{'+
		'  \"returnObj\": {'+
		'    \"PartOnHandWhse\": ['+
		'      {'+
		'        \"Plant\": \"MfgSys\",'+
		'        \"WarehouseDesc\": \"I made this up\",'+
		'        \"AllocQty\": 0,'+
		'        \"IUM\": \"EA\",'+
		'        \"QuantityOnHand\": 0,'+
		'        \"IsPrimaryWarehouse\": \"\"'+
		'      }'+
		'    ]'+
		'  }'+
		'}');
        // Setting the response header
        response.setHeader('Content-Type', 'application/json');
        // Setting the response code
        response.setStatusCode(200);        
        // Returning the response
        return response;
    }
}