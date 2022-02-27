
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
    console.log(`bookkeepScreenTimePurchase | ${message}`);
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

            const uid = data["uid"];
            const docRef = dbHandler.createScreenTimePurchaseDocument(uid);
            const amount = data["amount"];
            const hours = data["hours"];
            data["purchasedAt"] = admin.firestore.FieldValue.serverTimestamp();
            data["purchaseId"] = docRef.id;
            data["status"] = "unused";

            // prepare return Data
            const returnData: any = { purchaseId: docRef.id };

            try {
                await db.runTransaction(async (t: any) => {
                    await
                        bookkeeper.updateStatsOnScreenTimePurchase(t, uid, amount, hours);
                    t.set(docRef, data);
                });

                response.status(StatusCodes.OK).send(
                    ResponseHandler.returnData(returnData)
                );

            }
            catch (e) {
                log(`Error: Could not purchase screen time because of error: ${e}`);
                response.status(StatusCodes.INTERNAL_SERVER_ERROR).send(
                    ResponseHandler.returnError(`Screen time could not be purchased, error: ${e}`));
            }

        } catch (error) {
            if (typeof error === "string") {
                // We've narrowed 'e' down to the type 'string'.
                log(error);
            }
            if (error instanceof Error) {
                log(error.message);
                response.status(StatusCodes.INTERNAL_SERVER_ERROR).send(ResponseHandler.returnError(error.message));
            }
        }
    });
}
);


