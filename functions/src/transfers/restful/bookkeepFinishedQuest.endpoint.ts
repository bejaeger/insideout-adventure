
import { Request, Response } from "express";
import { Post } from "firebase-backend";
import { AFKCreditsBookkeeper } from "../../system/afkCreditsBookkeeper";
import { getPayload } from "../../system/helperFunctions";
import { StatusCodes } from "http-status-codes";
import { ResponseHandler } from "../../system/responseHandler";

import { Client } from "@notionhq/client";
const notion = new Client({ auth: "secret_JyfVJ2khuaLre3df4tAjlPy3I8k01vDc4uWQ5BAPLKK" });
const databaseId = "16be4379b2bf41a9a33036efcee2bd53";

const admin = require("firebase-admin");
const db = admin.firestore();
const cors = require("cors");


// enable short hand for console.log()
function log(message: string) {
    console.log(`bookkeepFinishedQuest | ${message}`);
}

//------------------------------------------------
// notion test

async function addItem(text: string) {
    try {
        const response = await notion.pages.create({
            parent: { database_id: databaseId },
icon: {
    	type: "emoji",
			emoji: "🎉"
  	},
  	cover: {
  		type: "external",
    	external: {
    		url: "https://website.domain/images/image.png"
    	}
  	},
    properties: {
      Name: {
        title: [
          {
            text: {
              content: 'Tuscan Kale',
            },
          },
        ],
      },
      'Food group': {
        select: {
          name: '🥦 Vegetable',
        },
      },
      Price: {
        number: 2.5,
      },
    },
    children: [
      {
        object: 'block',
        type: 'heading_2',
        heading_2: {
          text: [
            {
              type: 'text',
              text: {
                content: 'Lacinato kale',
              },
            },
          ],
        },
      },
      {
        object: 'block',
        type: 'paragraph',
        paragraph: {
          text: [
            {
              type: 'text',
              text: {
                content: 'Lacinato kale is a variety of kale with a long tradition in Italian cuisine, especially that of Tuscany. It is also known as Tuscan kale, Italian kale, dinosaur kale, kale, flat back kale, palm tree kale, or black Tuscan palm.',
                link: {
                  url: 'https://en.wikipedia.org/wiki/Lacinato_kale',
                },
              },
            },
          ],
        },
      },
    ],
  });
        console.log(response)
        log("Success! Entry added.")
    } catch (error) {
        if (typeof error === "string") {
            // We've narrowed 'e' down to the type 'string'.
            log(error);
        }
        if (error instanceof Error) {
            log(error.message);
        }
    }
}

//----------------------------------------------------

export default new Post((request: Request, response: Response) => {
    cors()(request, response, async () => {
        try {
            log("Calling function with request body:");
            const data: any = getPayload(request.body);
            console.log(data);

            const bookkeeper = new AFKCreditsBookkeeper(db);

            // const quest = data["quest"];
            const afkCreditsEarned = data["afkCreditsEarned"];
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
                                bookkeeper.updateStatsOnFinishedQuest(t, uid, afkCreditsEarned);
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
                addItem("Giftcard purchased");
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