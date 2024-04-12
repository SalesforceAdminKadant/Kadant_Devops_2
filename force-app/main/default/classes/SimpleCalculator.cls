public class SimpleCalculator {
    
    Private Integer a;
    Private Integer b;
    
    // Constructor
    public SimpleCalculator(Integer a, Integer b) {
        this.a = a;
        this.b = b;
    }
	
    public Integer add() {
        return this.a + this.b;
    }
    
    public Integer subtract() {
        return this.a - this.b;
    }
    
    public Integer multiply() {
        return this.a * this.b;
    }
    
    public Decimal divide() {
        return Decimal.valueOf(this.a) / Decimal.valueOf(this.b);
    }
}