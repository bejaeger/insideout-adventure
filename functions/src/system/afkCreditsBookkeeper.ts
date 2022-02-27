import { firestore } from "firebase-admin";
import { FirestoreManager } from "./firestoreManager";

const admin = require("firebase-admin");

// enable short hand for console.log()
function log(message: string) {
  console.log(`AFKCreditsBookkeeper | ${message}`);
}

/**
 * A class that takes care of updating firestore documents
 *  regarding good wallet statistics
 */
export class AFKCreditsBookkeeper {
  db: firestore.Firestore;
  dbManager: FirestoreManager;

  kDollarToAfkCreditsConversionFactor: number = 10;
  kCentsToAfkCreditsConversionFactor: number = this.kDollarToAfkCreditsConversionFactor * 0.01;

  constructor(
    db: firestore.Firestore,
  ) {
    this.db = db;
    this.dbManager = new FirestoreManager(db);
  }

  // update Statistics when user A sends money to user B
  async updateStatsOnSponsor2ExplorerTransfer(batch: any, recipientId: string, amount: string) {
    log("Entering updateStatsOnSponsor2ExplorerTransfer()");

    const increment = admin.firestore.FieldValue.increment(amount);
    const docRefRecipient = this.dbManager.getUserSummaryStatisticsDocument(recipientId);

    // There will probably be more things to update so that's why we keep it in
    // a separate function here
    batch.update(docRefRecipient, {
      availableSponsoring: increment, // increment available sponsoring of explorer
    });
  }

  // update Statistics when a quest has been finished by user with uid uid
  async updateStatsOnFinishedQuest(transaction: any, uid: string, afkCreditsEarned: number) {
    log("Entering updateStatsOnFinishedQuest()");

    // fetch documents
    const userDocRef = this.dbManager.getUserSummaryStatisticsDocument(uid);
    const userDoc = await transaction.get(userDocRef);
    // validate documents
    if (!userDoc.exists) {
      throw Error('Summary statistics document or global stats document does not exist');
    }
    const userStats = userDoc.data();

    // ! This check is crucual!
    if (userStats != null) {
      log('Fetched user statistics document');
      // Validate request (validate whether current amount of GW is enough)
      if (!this.hasEnoughBalance(userStats["availableSponsoring"], afkCreditsEarned)) {
        throw Error(`Current Sponsoring is not enough to earn ${afkCreditsEarned} AFK Credits.`);
      }
    } else {
      throw Error("No data in summary statistics document!");
    }

    const increment = admin.firestore.FieldValue.increment(afkCreditsEarned);
    const incrementNumberQuests = admin.firestore.FieldValue.increment(1);

    // ! This here is very important and needs to be done more properly!
    // ! This is our business model / the conversion between dollar and credits
    // ! availableSponsoring is given in CENTS!
    const decrementSponsoring = admin.firestore.FieldValue.increment(-afkCreditsEarned * 10);

    const docRefRecipient = this.dbManager.getUserSummaryStatisticsDocument(uid);

    // There will probably be more things to update so that's why we keep it in
    // a separate function here
    transaction.update(docRefRecipient, {
      availableSponsoring: decrementSponsoring, // decrement available sponsoring of explorer
      afkCreditsBalance: increment, // increment afk credits balance
      lifetimeEarnings: increment, // increment lifetime earnings
      numberQuestsCompleted: incrementNumberQuests,  // increment number of quests completed
    });
  }



  // update Statistics when a quest has been finished by user with uid uid
  async updateStatsOnGiftCardPurchase(transaction: any, uid: string, amount: number) {
    log("Entering updateStatsOnGiftCardPurchase()");

    // fetch documents
    const userDocRef = this.dbManager.getUserSummaryStatisticsDocument(uid);
    const userDoc = await transaction.get(userDocRef);
    // validate documents
    if (!userDoc.exists) {
      throw Error('Summary statistics document or global stats document does not exist');
    }
    const userStats = userDoc.data();

    const afkCreditsToDeduct = this.kCentsToAfkCreditsConversionFactor * amount;

    // ! This check is crucual!
    if (userStats != null) {
      log('Fetched user statistics document');
      // Validate request (validate whether current amount of GW is enough)
      if (!this.hasEnoughAFKCredits(userStats["afkCreditsBalance"], afkCreditsToDeduct)) {
        throw Error(`Current AFK Credits balance is not enough to buy gift card.`);
      }
    } else {
      throw Error("No data in summary statistics document!");
    }

    // Check whether gift card is already available or needs to be provided manually!

    const increment = admin.firestore.FieldValue.increment(afkCreditsToDeduct);
    const incrementNumberGiftCards = admin.firestore.FieldValue.increment(1);
    const decrement = admin.firestore.FieldValue.increment(-afkCreditsToDeduct);
    const docRefRecipient = this.dbManager.getUserSummaryStatisticsDocument(uid);
    transaction.update(docRefRecipient, {
      afkCreditsBalance: decrement, // increment afk credits balance
      afkCreditsSpent: increment, // increment lifetime earnings
      numberGiftCardsPurchased: incrementNumberGiftCards,  // increment number of quests completed
    });


  }

  // update Statistics when a quest has been finished by user with uid uid
  async updateStatsOnScreenTimePurchase(transaction: any, uid: string, amount: number, hours: number) {
    log("Entering updateStatsOnScreenTimePurchase()");

    // fetch documents
    const userDocRef = this.dbManager.getUserSummaryStatisticsDocument(uid);
    const userDoc = await transaction.get(userDocRef);
    // validate documents
    if (!userDoc.exists) {
      throw Error('Summary statistics document or global stats document does not exist');
    }
    const userStats = userDoc.data();

    const afkCreditsToDeduct = this.kCentsToAfkCreditsConversionFactor * amount;

    // ! This check is crucual!
    if (userStats != null) {
      log('Fetched user statistics document');
      // Validate request (validate whether current amount of GW is enough)
      if (!this.hasEnoughAFKCredits(userStats["afkCreditsBalance"], afkCreditsToDeduct)) {
        throw Error(`Current AFK Credits balance is not enough to buy screen time.`);
      }
    } else {
      throw Error("No data in summary statistics document!");
    }

    // Check whether screen card is already available or needs to be provided manually!
    const increment = admin.firestore.FieldValue.increment(afkCreditsToDeduct);
    const incrementHours = admin.firestore.FieldValue.increment(hours);
    const decrement = admin.firestore.FieldValue.increment(-afkCreditsToDeduct);
    const docRefRecipient = this.dbManager.getUserSummaryStatisticsDocument(uid);
    transaction.update(docRefRecipient, {
      afkCreditsBalance: decrement, // increment afk credits balance
      afkCreditsSpent: increment, // increment lifetime earnings
      numberScreenTimeHoursPurchased: incrementHours,  // increment number of quests completed
    });

  }

  ///////////////////////////////////////////////////////////////
  // Helper and validating functions

  private hasEnoughBalance(currentBalance: number, amountToDeduct: number) {
    log(`amountToDeduct: ${amountToDeduct}`);
    log(`currentBalance: ${currentBalance}`);
    return Math.abs(amountToDeduct) <= currentBalance;
  }

  private hasEnoughAFKCredits(currentCreditBalance: number, amountToDeduct: number) {
    log(`amountToDeduct: ${amountToDeduct}`);
    log(`current AFK Credits Balance: ${currentCreditBalance}`);
    return Math.abs(amountToDeduct) <= currentCreditBalance;
  }
}
