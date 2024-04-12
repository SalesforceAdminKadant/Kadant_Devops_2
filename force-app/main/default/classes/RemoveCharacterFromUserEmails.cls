public class RemoveCharacterFromUserEmails {

    //Define the character to remove from emails
        private static final String CHAR_TO_REMOVE = '.invalid';
        
            public static void removeCharFromEmails() {
                //Get a list of all user records(emails) that has the ".invalid"
                    List<User> users = [SELECT Id, Name, Email, UserName From User
                                            WHERE Email Like '%invalid%'
                                                AND ProfileId ='00e60000001BgSxAAK'];
                                            
                         System.debug(users);
                         
                    //Loop through the User records and update the email addresses
                    for (User u : users) {
                        String oldEmail = u.Email;
                        String newEmail = oldEmail.replace(CHAR_TO_REMOVE, '');
                        
                        System.debug(oldEmail);
                        System.debug(newEmail);
                            
                            if (!newEmail.equals(oldEmail)) {
                                    u.Email = newEmail;
                            }
                    }
                    
                    //Update the user records
                        if (users.size() > 0) {
                            update users;
                        }
            }
}