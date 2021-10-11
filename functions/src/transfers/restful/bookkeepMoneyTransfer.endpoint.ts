
import { Request, Response } from "express";
import { Post } from "firebase-backend";
import { AFKCreditsBookkeeper } from "../../system/afkCreditsBookkeeper";
import { getPayload } from "../../system/helperFunctions";
import { StatusCodes } from "http-status-codes";
import { ResponseHandler } from "../../system/responseHandler";
import { FirestoreManager } from "../../system/firestoreManager";

const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors");

// enable short hand for console.log()
function log(message: string) {
  console.log(`bookkeepMoneyTransfer | ${message}`);
}

export default new Post((request: Request, response: Response) => {
  cors()(request, response, async () => {
    try {
      log("Calling function with request body:");
      const data: any = getPayload(request.body);
      console.log(data);

      // TODO: Check whether input request is valid!

      const bookkeeper = new AFKCreditsBookkeeper(db);
      const dbHandler = new FirestoreManager(db);

      const transferDetails = data["transferDetails"];
      const type = data["type"];

      const docRef = dbHandler.createMoneyTransferDocument();
      data["createdAt"] = admin.firestore.FieldValue.serverTimestamp();
      data["transferId"] = docRef.id;

      // prepare return Data
      const returnData: any = { transferId: docRef.id };

      // /////////////////////////////////////////////////////////////
      // Sponsoring payment
      if (type === "Sponsor2Explorer") {
        // at the moment we don't necessarily need a batch here
        // (cause we only need one operations)
        // But might be useful to leave it like that for the future when
        // we probably want to track more things in this call
        const batch = db.batch();
        const recipientId = transferDetails["recipientId"];
        const amount = transferDetails["amount"];

        bookkeeper.updateStatsOnSponsor2ExplorerTransfer(batch, recipientId, amount).catch(() => log("Error: Could not add updates of user to own good wallet transfer documents to batch commit)"));
        // Add field to money transfer document to easily identify that this was a pledge
        batch.set(docRef, data);

        // await all async calls
        await batch.commit();
      }


      response.status(StatusCodes.OK).send(
        ResponseHandler.returnData(returnData)
      );
    } catch (error) {
      if (typeof error === "string") {
        // We've narrowed 'e' down to the type 'string'.
        console.log(error);
      }
      if (error instanceof Error) {
        log(error.message);
        response.status(StatusCodes.INTERNAL_SERVER_ERROR).send(ResponseHandler.returnError(error.message));
      }
    }
  });
}
);


