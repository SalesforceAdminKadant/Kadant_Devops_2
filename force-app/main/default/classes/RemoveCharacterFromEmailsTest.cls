@isTest
public class RemoveCharacterFromEmailsTest {

    @isTest
    
    static void testRemoveCharFromEmails() {
        // Create a test User record with an email that contains the character to be removed
        User testUser = new User(Email = 'test.invaliduserrmv@kadant.com', Username='testuser123@example.com.invalid', LastName = 'userSurname', Alias = 'tuserS', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US', ProfileId ='00e60000001BgSxAAK');
            insert testUser;

        // Call the removeCharFromEmails method
        RemoveCharacterFromUserEmails.removeCharFromEmails();

        // Verify that the character has been removed from the email
        User updatedUser = [SELECT Email FROM User WHERE Id = :testUser.Id];
        System.assertEquals('testuserrmv@kadant.com', updatedUser.Email);
    }
}