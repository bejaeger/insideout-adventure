import {firestore} from "firebase-admin";
import {FirestoreManager} from "./firestoreManager";

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
}
