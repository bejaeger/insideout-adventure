import {firestore} from "firebase-admin";
import * as faker from "faker";
import {FirestoreManager} from "./firestoreManager";
import admin = require("firebase-admin");
import {Constants} from "./constants";

// enable short hand for console.log()
function log(message: string) {
  console.log(`FakeDataPopulator | ${message}`);
}

/**
 * A class that helps with populating a local firestore database
 */
export class FakeDataPopulator {
  /**
   * The database to populat
   */
  db: firestore.Firestore;
  dbManager: FirestoreManager;

  constructor(
      db: firestore.Firestore,
  ) {
    faker.seed(123);
    this.db = db;
    this.dbManager = new FirestoreManager(db);
  }

  async generateFakeData() {
    log("generateFakeData");

    const generateDocument = await this.getGenerateDocument().get();

    if (!generateDocument.exists) {
      await this.createGenerateDocument();
      await this.generateUsers();
      // create test user to sign in with it!
      const auth = admin.auth();
      await auth.createUser({
        email: Constants.TEST_SPONSOR_EMAIL,
        uid: Constants.TEST_SPONSOR_ID,
        password: Constants.TEST_SPONSOR_PASSWORD,
      })
          .then((userRecord) => {
            console.log("Successfully created new user:", userRecord.uid);
          })
          .catch((error) => {
            console.log("Error creating new user:", error);
          });
    }
  }

  // ////////////////////////////////////////////////////////////////////////////////////
  // Functions to generate data

  private async generateUsers() {
    log("generateUsers");

    for (let index = 0; index < 10; index++) {
      const fullName: string = faker.name.firstName() + " " + faker.name.lastName();
      const fullNameSearch = this.getListOfKeywordsFromString(fullName);
      const user = {
        "email": faker.internet.email(),
        "fullName": fullName,
        "fullNameSearch": fullNameSearch,
        "role": "sponsor",
        "sponsorIds": [],
        "childIds": [],
        "newUser": false,
      };

      let docId: string;
      let zero = false; // initialize users with all statistics set to zero
      // Always add these too userIds for testing function with Postman
      if (index == 0) {
        docId = await this.dbManager.createUserDocument(user, Constants.TEST_SPONSOR_ID);
        zero = true;
      } else if (index == 1) {
        docId = await this.dbManager.createUserDocument(user, Constants.TEST_EXPLORER_ID);
        zero = true;
      } else docId = await this.dbManager.createUserDocument(user);
      await this.generateUserStatistics(docId, zero);
      await this.dbManager.addUid(docId);
    }
  }

  private async generateUserStatistics(userId: string, zero = false) {
    // log(`generateUserStatistics userId:${userId}`);
    const stats = {
      "afkCredits": zero ? 0 : faker.datatype.number(100000),
      "availableSponsoring": zero ? 0 : faker.datatype.number(100000),
      "completedQuests": zero ? 0 : faker.datatype.number(10),
    };
    await this.dbManager.createUserStatistics(userId, stats);
  }


  // /////////////////////////////////////////////////////////////////
  // Helper functions for creating dummy document to know whether
  // data has already been generated or not

  private async createGenerateDocument(): Promise<void> {
    log("createGenerateDocument");
    await this.getGenerateDocument().set({});
  }

  private getGenerateDocument(): firestore.DocumentReference {
    return this.db.collection("data").doc("generate");
  }

  // ////////////////////////////////////////////////
  // Other helper functions
  private getListOfKeywordsFromString(str: string): Array<string> {
    if (str == null) return [];
    const splitList: Array<string> = str.split(" ");
    const searchKeywords: Array<string> = [];
    for (let i = 0; i < splitList.length; i++) {
      for (let j = 1; j <= splitList[i].length; j++) {
        searchKeywords.push(splitList[i].substring(0, j).toLowerCase());
      }
    }
    return searchKeywords;
  }
}
