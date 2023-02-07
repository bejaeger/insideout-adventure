# Firestore collections and datamodels

TODO: needs updating

## Firestore collections

- **users**/*{id}*/**User/statistics/***summaryStats*/**UserStatistics**
- **>> users**/*{id}*/**User/giftcards/{***giftcardId***}**/**GiftCard**
- **quests**/{id}/**Quest** (resources of possible quests to do)
- **activatedQuests**/{id}/**ActivatedQuest** (quests when people actively do them or afterwards for history)
- **users**/*{id}*/**User/screentime/{**screenTimeId**}**/**ScreenTimePurchase**
- **transfers**/{id}/**MoneyTransfer**


## Data models

- **User**
    
    uid
    
    fullName
    
    email
    
    role (sponsor, child, admin)
    
    sponsorIds (maybe put in other doc for privacy reasons)
    
    childIds (maybe put in other doc for privacy reasons)
    
    fullNameSearch  (for searching database)
    
    newUser (for onboarding dialog)
    
    createdByUserWithId (in case the user was created by a sponsor from within the app)
    
    password (IF account created from sponsor, null otherwise. still needs encryption)
    
- **UserStatistics**
    
    afkCreditsBalance
    
    afkCreditsSpent
    
    availableSponsoring
    
    completedQuestIds (to keep track of what quests are already done)
    
    numberQuestsCompleted
    
    numberGiftCardsPurchased
    
    numberScreenTimeHoursPurchased
    
    lifetimeEarnings (all afk credits ever earned → for achievement board)
    
- **Quest**
    
    name
    
    description
    
    questId
    
    type (enum/String: Hike / Hunt / Search)
    
    startMarker: **Marker** (first marker in 'markers')
    
    finishMarker: **Marker** (last marker in 'markers')
    
    markers: [ {marker1 (**Marker**) }, {marker2}, ... ] (List of all markers (including startMarker and finishMarker))
    
    networkImagePath (for nice visuals)
    
    afkCredits
    
    afkCreditsPerMarker
    
    bonusAfkCreditsOnSuccess
    
    createdBy (if quest is created by parent. to only show quest to supported explorers)
    
- **ActivatedQuest**
    
    quest (of type **Quest)**
    
    markersCollected: [false, false, false, ...] (list of all markers that were collected, initialized to false with the length of markers inside quest)
    
    uids (uids of users doing the quest)
    
    afkCreditsEarned (set at the end of the quest)
    
    timeElapsed (in seconds! set at the end of the quest)
    
    createdAt 
    
    status (active, finished, cancelled)
    
- **ConciseFinishedQuestInfo** (concise version of the above to be used in lists for histories)
    
    name
    
    type
    
    afkCredits
    
    afkCreditsEarned

    


    
    