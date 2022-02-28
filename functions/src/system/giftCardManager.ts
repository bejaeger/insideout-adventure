import { firestore } from "firebase-admin";
import { FirestoreManager } from "./firestoreManager";

// const admin = require("firebase-admin");

// // enable short hand for console.log()
function log(message: string) {
  console.log(`GiftCardManager | ${message}`);
}

/**
 * A class that takes care of updating firestore documents
 *  regarding good wallet statistics
 */
export class GiftCardManager {
  db: firestore.Firestore;
  dbManager: FirestoreManager;

  kDollarToAfkCreditsConversionFactor: number = 10;

  constructor(
    db: firestore.Firestore,
  ) {
    this.db = db;
    this.dbManager = new FirestoreManager(db);
  }


  async checkForPrepaidGiftCard(transaction: any, categoryId: string) {
    const doc: any = await this.dbManager.getPrePurchasedGiftCard(categoryId);
    if (!doc) {
      return null;
    } else {
      const code = doc.data()["giftCardCode"];
      const docId = doc.ref;
      log(`Found pre-purchased gift card code: ${code} under document with id ${docId}`);
      return { code: code, giftCardDocId: docId };
    } 
    
  }

  static getDefaultReturnObject(transferId: string, needToProvideGiftCard: boolean) {
    return { transferId: transferId, needToProvideGiftCard: needToProvideGiftCard };
  }

}
