@isTest
private class TestSkillsMatrixController {
  static PageReference page;
  static SkillsMatrixController controller;
  static Contact gary, izzy;
  static User garyUser, izzyUser;
  static {
    izzyUser = [ SELECT Id FROM User WHERE Name = 'Izzy Mandalbaum' LIMIT 1 ];
    garyUser = [ SELECT Id FROM User WHERE Name = 'Gary Fogel' LIMIT 1 ];
    init();
  }
  private static void init() {
    gary = new Contact(FirstName = 'Gary', LastName = 'Fogel');
    izzy = new Contact(FirstName = 'Izzy', LastName = 'Barr',
      User__c = izzyUser.Id);
    insert new Contact[] { gary, izzy };
    Skill__c[] skills = new Skill__c[] {
      new Skill__c(Type__c = 'Java', Rating__c = '3',
        Contact__c = izzy.Id) };
    insert skills;
    page = new PageReference('SkillsMatrix');
    Test.setCurrentPage(page);
    controller = new SkillsMatrixController();
  }
  static testMethod void testAsUser() {
    System.runAs(izzyUser) {
      init();
      controller.selectedContactId = gary.Id;
      controller.refresh();
      System.assert(!controller.isEditable);
      controller.selectedContactId = izzy.Id;
      controller.refresh();
      System.assert(controller.isEditable);
    }
  }
  static testMethod void testNoContactForUser() {
    System.runAs(garyUser) {
      init();
      controller.selectedContactId = gary.Id;
      controller.refresh();
      System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
    }
  }
  static testMethod void testNoSkills() {
    controller.getContactOptions();
    controller.selectedContactId = gary.Id;
    controller.refresh();
    System.assert(controller.selectedSkills.size() > 0);
    System.assert(controller.isEditable);
  }
  static testMethod void testWithSkills() {
    controller.getContactOptions();
    controller.selectedContactId = izzy.Id;
    controller.refresh();
    System.assert(controller.selectedSkills.size() > 0);
    System.assert(controller.selectedSkills.get(0).Type__c == 'Java');
  }
  static testMethod void testNoContactSelected() {
    controller.selectedContactId = null;
    PageReference ref = controller.refresh();
    System.assert(ApexPages.hasMessages());
  }
  static testMethod void testSave() {
    final String skillRating = '5 - Expert';
    controller.getContactOptions();
    controller.selectedContactId = gary.Id;
    controller.refresh();
    List<Skill__c> selectedSkills = controller.selectedSkills;
    Skill__c skill = selectedSkills.get(0);
    skill.Rating__c = skillRating;
    String skillType = skill.Type__c;
    controller.save();
    System.assert(ApexPages.hasMessages(ApexPages.Severity.INFO));
    Skill__c savedSkill = [ SELECT Rating__c FROM Skill__c
      WHERE Contact__c = :gary.Id AND
        Type__c = :skillType LIMIT 1 ];
    System.assert(savedSkill != null &&
      savedSkill.Rating__c == skillRating);
  }
}