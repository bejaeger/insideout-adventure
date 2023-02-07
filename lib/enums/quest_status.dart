enum QuestStatus {
  active, // user actively doing the quest
  cancelled, // user did not finish the quest but cancelled it
  success, // user succesfully finished the quest
  incomplete,  // (Intermediate status!) user tries to finish a quest but it would not be a successfull finish (e.g. not all markers were collected)
  internalFailure,
  failed
} 
