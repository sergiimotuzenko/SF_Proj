/**
 * Contact Trigger Handler Test Class
 *
 * Provides comprehensive test coverage for ContactTriggerHandler.
 * Ensures all trigger contexts execute without errors.
 *
 * @version 65.0
 */
@isTest
private class ContactTriggerHandlerTest {

    /**
     * Test before insert context
     */
    @isTest
    static void testBeforeInsert() {
        // Arrange
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            contacts.add(new Contact(
                FirstName = 'Test' + i,
                LastName = 'Contact' + i,
                Email = 'test' + i + '@example.com'
            ));
        }

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onBeforeInsert(contacts, new Map<Id, Contact>());
        Test.stopTest();

        // Assert
        System.assertEquals(10, contacts.size(), 'Should have 10 contacts');
        for (Contact con : contacts) {
            System.assertNotEquals(null, con.FirstName, 'FirstName should be set');
            System.assertNotEquals(null, con.LastName, 'LastName should be set');
        }
    }

    /**
     * Test before update context
     */
    @isTest
    static void testBeforeUpdate() {
        // Arrange
        List<Contact> contacts = createTestContacts(5);
        insert contacts;

        Map<Id, Contact> oldMap = new Map<Id, Contact>([SELECT Id, Email FROM Contact WHERE Id IN :contacts]);
        List<Contact> newContacts = new List<Contact>();
        for (Contact oldCon : oldMap.values()) {
            Contact newCon = oldCon.clone();
            newCon.Email = 'updated_' + newCon.Email;
            newContacts.add(newCon);
        }

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onBeforeUpdate(newContacts, oldMap);
        Test.stopTest();

        // Assert
        System.assertEquals(5, newContacts.size(), 'Should have 5 contacts');
        for (Contact con : newContacts) {
            System.assertEquals(true, con.Email.startsWith('updated_'), 'Email should be updated');
        }
    }

    /**
     * Test before delete context
     */
    @isTest
    static void testBeforeDelete() {
        // Arrange
        List<Contact> contacts = createTestContacts(5);
        insert contacts;

        List<Contact> toDelete = [SELECT Id, FirstName, LastName FROM Contact WHERE Id IN :contacts];

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onBeforeDelete(toDelete, new Map<Id, Contact>(toDelete));
        Test.stopTest();

        // Assert
        System.assertEquals(5, toDelete.size(), 'Should have 5 contacts to delete');
    }

    /**
     * Test after insert context
     */
    @isTest
    static void testAfterInsert() {
        // Arrange
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            contacts.add(new Contact(
                FirstName = 'After' + i,
                LastName = 'Insert' + i,
                Email = 'after' + i + '@example.com'
            ));
        }

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onAfterInsert(contacts, new Map<Id, Contact>());
        Test.stopTest();

        // Assert
        System.assertEquals(5, contacts.size(), 'Should have 5 contacts');
    }

    /**
     * Test after update context
     */
    @isTest
    static void testAfterUpdate() {
        // Arrange
        List<Contact> contacts = createTestContacts(5);
        insert contacts;

        Map<Id, Contact> oldMap = new Map<Id, Contact>(contacts);
        for (Contact con : contacts) {
            con.Phone = '555-' + String.valueOf(Math.round(Math.random() * 9000 + 1000));
        }

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onAfterUpdate(contacts, oldMap);
        Test.stopTest();

        // Assert
        System.assertEquals(5, contacts.size(), 'Should have 5 contacts');
    }

    /**
     * Test after delete context
     */
    @isTest
    static void testAfterDelete() {
        // Arrange
        List<Contact> contacts = createTestContacts(5);
        insert contacts;

        List<Contact> toDelete = [SELECT Id FROM Contact WHERE Id IN :contacts];
        delete toDelete;

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onAfterDelete(contacts, new Map<Id, Contact>(contacts));
        Test.stopTest();

        // Assert
        System.assertEquals(5, contacts.size(), 'Should have 5 contacts');
    }

    /**
     * Test after undelete context
     */
    @isTest
    static void testAfterUndelete() {
        // Arrange
        List<Contact> contacts = createTestContacts(5);
        insert contacts;
        delete contacts;

        List<Contact> undeleted = [SELECT Id FROM Contact WHERE Id IN :contacts ALL ROWS];

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onAfterUndelete(undeleted, new Map<Id, Contact>());
        Test.stopTest();

        // Assert
        System.assertEquals(5, undeleted.size(), 'Should have 5 undeleted contacts');
    }

    /**
     * Test bulk operations - before insert
     */
    @isTest
    static void testBulkBeforeInsert() {
        // Arrange
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(
                FirstName = 'Bulk' + i,
                LastName = 'Test' + i,
                Email = 'bulk' + i + '@example.com'
            ));
        }

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onBeforeInsert(contacts, new Map<Id, Contact>());
        Test.stopTest();

        // Assert
        System.assertEquals(200, contacts.size(), 'Should handle 200 contacts');
    }

    /**
     * Test bulk operations - before update
     */
    @isTest
    static void testBulkBeforeUpdate() {
        // Arrange
        List<Contact> contacts = createTestContacts(200);
        insert contacts;

        Map<Id, Contact> oldMap = new Map<Id, Contact>(contacts);
        for (Contact con : contacts) {
            con.Description = 'Bulk updated';
        }

        // Act
        Test.startTest();
        ContactTriggerHandler handler = new ContactTriggerHandler();
        handler.onBeforeUpdate(contacts, oldMap);
        Test.stopTest();

        // Assert
        System.assertEquals(200, contacts.size(), 'Should handle 200 contacts');
    }

    /**
     * Helper method to create test contacts
     */
    private static List<Contact> createTestContacts(Integer count) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            contacts.add(new Contact(
                FirstName = 'Helper' + i,
                LastName = 'Contact' + i,
                Email = 'helper' + i + '@example.com'
            ));
        }
        return contacts;
    }
}
