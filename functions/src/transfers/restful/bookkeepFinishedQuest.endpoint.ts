
import { Request, Response } from "express";
import { Post } from "firebase-backend";
import { AFKCreditsBookkeeper } from "../../system/afkCreditsBookkeeper";
import { getPayload } from "../../system/helperFunctions";
import { StatusCodes } from "http-status-codes";
import { ResponseHandler } from "../../system/responseHandler";

const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors");


// enable short hand for console.log()
function log(message: string) {
    console.log(`bookkeepFinishedQuest | ${message}`);
}

export default new Post((request: Request, response: Response) => {
    cors()(request, response, async () => {
        try {
            log("Calling function with request body:");
            const data: any = getPayload(request.body);
            console.log(data);

            const bookkeeper = new AFKCreditsBookkeeper(db);

            // const quest = data["quest"];
            const afkCreditsEarned = data["afkCreditsEarned"];
            const questId = data["quest"]["id"];
            const uids = data["uids"];

            // /////////////////////////////////////////////////////////////
            let errorObject: any = {
                uidsWithError: [],
                errorMessages: [],
                hasError: false,
            };
            let index: number = - 1;
            try {
                for (const uid of uids) {
                    index = index + 1;
                    try {
                        await db.runTransaction(async (t: any) => {
                            await
                                bookkeeper.updateStatsOnFinishedQuest(t, uid, afkCreditsEarned, questId);
                        });
                    } catch (e) {
                        log(`Error: Could not add update credits after finished quest event: ${e}`);
                        errorObject["uidsWithError"].push(uid);
                        errorObject["errorMessages"].push(`${e}`);
                        errorObject["hasError"] = true;
                    }
                }
            } catch (e) {
                log(`Unknown error occured: ${e}`);
                throw e;
            }

            if (errorObject["hasError"] === true) {
                response.status(StatusCodes.INTERNAL_SERVER_ERROR).send(
                    // TODO: Update error handling once multi user quest is allowed
                    ResponseHandler.returnErrorObject(`AFK Credits could not be updated. ${errorObject["errorMessages"][0]}`, errorObject)
                );
            } else {
                response.status(StatusCodes.OK).send(
                    ResponseHandler.returnSuccess()
                );
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