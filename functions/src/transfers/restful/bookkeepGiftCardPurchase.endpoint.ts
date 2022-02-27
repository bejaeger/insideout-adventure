import { Request, Response } from "express";
import { Post } from "firebase-backend";
import { AFKCreditsBookkeeper } from "../../system/afkCreditsBookkeeper";
import { getPayload } from "../../system/helperFunctions";
import { StatusCodes } from "http-status-codes";
import { ResponseHandler } from "../../system/responseHandler";
import { FirestoreManager } from "../../system/firestoreManager";
import { GiftCardManager } from "../../system/giftCardManager";
import { EmailService } from "../../system/emailService";
import { NotionApi } from "../../system/notionApi";

const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors");

// enable short hand for console.log()
function log(message: string) {
    console.log(`bookkeepGiftCardPurchase | ${message}`);
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
            const giftCardManager = new GiftCardManager(db);
            const emailService = new EmailService();
            const notionApi = new NotionApi();

            const giftCardCategory = data["giftCardCategory"];
            const uid = data["uid"];

            const docRef = dbHandler.createGiftCardPurchaseDocument(uid);
            data["purchasedAt"] = admin.firestore.FieldValue.serverTimestamp();
            data["transferId"] = docRef.id;

            // prepare return Data
            let returnData: any = GiftCardManager.getDefaultReturnObject(docRef.id, false);

            const amount = giftCardCategory["amount"];
            const categoryId = giftCardCategory["categoryId"];

            try {
                await db.runTransaction(async (t: any) => {
                    const response: any = await giftCardManager.checkForPrepaidGiftCard(t, categoryId);
                    await
                        bookkeeper.updateStatsOnGiftCardPurchase(t, uid, amount);
                    if (response) {
                        data["code"] = response["code"];
                        data["status"] = "available";

                        // TODO: Maybe don't delete this but move it to another
                        // collection called purchasedGiftCards (just for bookkeeping?)

                        // delete gift card document
                        t.delete(response["giftCardDocId"]);
                    } else {
                        returnData["needToProvideGiftCard"] = true;
                        data["status"] = "pending";
                        data["code"] = "";
                    }
                    t.set(docRef, data);
                });

                try {
                    // Send email
                    emailService.notifyAFKCreditsTeamAfterGiftCardPurchase(
                        data["status"],
                        uid,
                        categoryId,
                        data["transferId"],
                        data["code"]
                    );

                    // add gift card purchase to notion
                    notionApi.bookkeepGiftCardPurchase(
                        data["status"],
                        uid,
                        categoryId,
                        giftCardCategory["categoryName"],
                        amount,
                        data["transferId"],
                    );
                } catch (e) {
                    log("Error when sending email alert or using notion Api!")
                    if (typeof e === "string") {
                        log(e);
                    }
                    if (e instanceof Error) {
                        log(e.message);
                    }
                }

                response.status(StatusCodes.OK).send(
                    ResponseHandler.returnData(returnData)
                );

            }
            catch (e) {
                log(`Error: Could not purchase gift card because of error: ${e}`);
                response.status(StatusCodes.INTERNAL_SERVER_ERROR).send(
                    ResponseHandler.returnError(`Gift card could not be purchased, error: ${e}`));
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


