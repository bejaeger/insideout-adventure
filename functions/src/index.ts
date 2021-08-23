import {FunctionParser} from "firebase-backend";
import admin = require("firebase-admin");
import {FakeDataPopulator} from "./system/fakeDataPopulator";

// Initialise the admin functionality for the firebase backend
admin.initializeApp();

const db = admin.firestore();


if (process.env.FUNCTIONS_EMULATOR) {
  console.log("We are running emulators locally.");

  const populator = new FakeDataPopulator(db);
  populator.generateFakeData().catch(() =>
    console.log("Could not generate fake data")
  );
}

exports = new FunctionParser(__dirname, exports).exports;
