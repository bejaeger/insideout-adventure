// adminMaster: legacy admin account
// admin: admin that people creating quests need to have access to
// superUser: Only used during development to test the app!

enum UserRole {
  guardian,
  ward,
  admin,
  unassigned,
  adminMaster /*legacy*/,
  superUser
}
