//
// Generated by JSON2Apex http://json2apex.herokuapp.com/
//

public class PartsOnHandWrapper {

	public class ReturnObj {
		public List<PartOnHandWhse> partOnHandWhse;
	}

	public class PartOnHandWhse {
		public String Plant;
		public String WarehouseDesc;
		public String AllocQty;
		public String IUM;
		public String QuantityOnHand;
		public String IsPrimaryWarehouse;
	}

	public ReturnObj returnObj;

	
	public static PartsOnHandWrapper parse(String json) {
		return (PartsOnHandWrapper) System.JSON.deserialize(json, PartsOnHandWrapper.class);
	}
}