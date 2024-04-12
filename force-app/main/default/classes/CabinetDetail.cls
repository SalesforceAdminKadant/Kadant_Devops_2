global class CabinetDetail implements Comparable {

    public string OrderNumber;
    public string CabinetId;
    public string OrderProduct;

    // Constructor
    public CabinetDetail(String o, String c, String p) {
        OrderNumber = o;
        CabinetId = c;
        OrderProduct = p;
    }  

    // Implement the compareTo() method
    global Integer compareTo(Object compareTo) {
        CabinetDetail compareToCd = (CabinetDetail)compareTo;
        if (OrderNumber == compareToCd.OrderNumber) return 0;
        if (OrderNumber > compareToCd.OrderNumber) return 1;
        return -1;        
    }     
}