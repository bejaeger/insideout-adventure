# Firestore collections and datamodels

TODO: needs updating

## Firestore collections

- **users**/*{id}*/**User/statistics/***summaryStats*/**UserStatistics**
- **>> users**/*{id}*/**User/giftcards/{***giftcardId***}**/**GiftCard**
- **quests**/{id}/**Quest** (resources of possible quests to do)
- **activatedQuests**/{id}/**ActivatedQuest** (quests that are active or for bookkeeping)
- **transfers**/{id}/**MoneyTransfer**
- **users**/*{id}*/**User/screentime/{**screenTimeId**}**/**ScreenTimePurchase**


## Data models
see `lib/datamodels` directory

