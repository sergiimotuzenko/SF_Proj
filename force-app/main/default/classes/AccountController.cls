/*
Deploying through MCP
*/

public with sharing class AccountController {
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccounts() {
    return [
      SELECT Id, Name, Industry, Phone, AnnualRevenue, Rating, Account_Status__c
      FROM Account
      ORDER BY CreatedDate DESC
      LIMIT 10
    ];
  }

  @AuraEnabled
  public static Account updateAccount(Account acc) {
    try {
      // Validate required fields
      if (acc.Name == null || acc.Name.trim() == '') {
        throw new AuraHandledException('Account Name is required');
      }

      // Validate Id is present
      if (acc.Id == null) {
        throw new AuraHandledException('Account Id is required');
      }

      // Update the account
      update acc;

      // Re-query to get updated values
      return [
        SELECT
          Id,
          Name,
          Industry,
          Phone,
          AnnualRevenue,
          Rating,
          Account_Status__c
        FROM Account
        WHERE Id = :acc.Id
      ];
    } catch (DmlException e) {
      throw new AuraHandledException(
        'Error updating account: ' + e.getMessage()
      );
    } catch (Exception e) {
      throw new AuraHandledException('Unexpected error: ' + e.getMessage());
    }
  }
}
