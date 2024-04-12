@isTest
public class SimpleCalculatorTest {
	
    // Test Addition
    @isTest static void testAddition() {
        SimpleCalculator calci = new SimpleCalculator(1, 2);
        Integer sum = 0;
        test.startTest();
        sum = calci.add();
        test.stopTest();
        System.assertEquals(3, sum, 'Sum of 1 & 2 is 3!');
    }
    
    @isTest static void testSubtraction() {
        SimpleCalculator calci = new SimpleCalculator(1, 2);
        Integer result = 0;
        test.startTest();
        result = calci.subtract();
        test.stopTest();
        System.assertEquals(-1, result, 'Subtracting 2 from 1 gives us -1!');
    }
    
    @isTest static void testMultiplication() {
        SimpleCalculator calci = new SimpleCalculator(1, 2);
        Integer result = 0;
        test.startTest();
        result = calci.multiply();
        test.stopTest();
        System.assertEquals(2, result, 'Anything multiplied with 1 will remain the same!');
    }
    
    @isTest static void testDivision() {
        SimpleCalculator calci = new SimpleCalculator(1, 2);
        Decimal result = 0;
        test.startTest();
        result = calci.divide();
        test.stopTest();
        System.assertEquals(0.5, result, '1/2 yields 0.5');
    }
}