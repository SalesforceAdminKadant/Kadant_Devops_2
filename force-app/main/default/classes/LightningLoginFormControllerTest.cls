@IsTest(SeeAllData = true)
public with sharing class LightningLoginFormControllerTest {
    
    @IsTest
    static void testLoginWithInvalidCredentials() {
        System.assertEquals(null, LightningLoginFormController.login('testUser', 'fakepwd', null));
    }
    
    @IsTest
    static void LightningLoginFormControllerInstantiation() {
        LightningLoginFormController controller = new LightningLoginFormController();
        System.assertNotEquals(controller, null);
    }
    
    @IsTest
    static void testIsUsernamePasswordEnabled() {
        System.assertEquals(false, LightningLoginFormController.getIsUsernamePasswordEnabled());
    }
    
    @IsTest
    static void testIsSelfRegistrationEnabled() {
        System.assertEquals(false, LightningLoginFormController.getIsSelfRegistrationEnabled());
    }
    
    @IsTest
    static void testGetSelfRegistrationURL() {
        System.assertEquals(null, LightningLoginFormController.getSelfRegistrationUrl());
    }
    
    @IsTest
    static void testAuthConfig() {
        Auth.AuthConfiguration authConfig = LightningLoginFormController.getAuthConfig();
        System.assertNotEquals(null, authConfig);
    }
    @IsTest
    static void testGetForgotPasswordUrl() {
        LightningLoginFormController.getForgotPasswordUrl();
    }
    @IsTest
    static void testSetExperienceId() {
        LightningLoginFormController.setExperienceId(null);
    }
}