//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//		
@IsTest
public class TestPartsOnHandWrapper {
	
	static testMethod void testParse() {
		String json = '{'+
		'  \"returnObj\": {'+
		'    \"PartOnHandWhse\": ['+
		'      {'+
		'        \"Plant\": \"MfgSys\",'+
		'        \"WarehouseDesc\": \"Expedition Vitry\",'+
		'        \"AllocQty\": 0,'+
		'        \"IUM\": \"EA\",'+
		'        \"QuantityOnHand\": 0,'+
		'        \"IsPrimaryWarehouse\": \"\"'+
		'      }'+
		'    ]'+
		'  }'+
		'}';
		PartsOnHandWrapper obj = PartsOnHandWrapper.parse(json);
		System.assert(obj != null);
	}
}