import {firestore} from "firebase-admin";

// enable short hand for console.log()
// function log(message: string) { console.log(`FirestoreCollectionHandler | ${message}`); }

/**
 * A class that helps with getting firestore collections
 */
export class FirestoreManager {
    db: firestore.Firestore;

    constructor(
        db: firestore.Firestore,
    ) {
      this.db = db;
    }

    getUserSummaryStatisticsDocument(uid: string) {
      return this.db.collection("users").doc(uid).collection("statistics").doc("summaryStats");
    }

    createMoneyTransferDocument() {
      return this.db.collection("transfers").doc();
    }

    // ///////////////////////////////////////////////////////////
    // Functions used in fakeDataPopulator

    async createUserDocument(data: any, docId = ""): Promise<string> {
      if (docId != "") {
        const docRef = this.db.collection("users").doc(docId);
        await docRef.set(data);
        return docId;
      } else {
        const docRef = await this.db.collection("users").add(data);
        return docRef.id;
      }
    }

    async createUserStatistics(userId: string, stats: any) {
      const docRef = this.db.collection("users").doc(userId).collection("statistics").doc("summaryStats");
      await docRef.set(stats);
    }

    async addUid(userId: string) {
      await this.db.collection("users").doc(userId).update({"uid": userId});
    }
}