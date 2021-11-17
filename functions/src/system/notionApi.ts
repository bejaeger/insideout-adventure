import { Client } from "@notionhq/client";
const notion = new Client({ auth: "secret_JyfVJ2khuaLre3df4tAjlPy3I8k01vDc4uWQ5BAPLKK" });


// enable short hand for console.log()
function log(message: string) {
    console.log(`NotionApi | ${message}`);
}

/**
 * A class that calls the notion Api for various purposes
 */
export class NotionApi {

    giftCardPurchaseDatabaseId: string;

    constructor(
    ) {
        this.giftCardPurchaseDatabaseId = "16be4379b2bf41a9a33036efcee2bd53";
    }

    async bookkeepGiftCardPurchase(status: string, uid: string, categoryId: string, categoryName: string, amount: number, transferId: string) {
        let title: string;
        if (status == "pending") {
            title = "Gift Card ORDERED";
        } else {
            title = "Gift Card Purchased";
        }
        try {
            const response = await notion.pages.create({
                parent: { database_id: this.giftCardPurchaseDatabaseId },
                icon: {
                    type: "emoji",
                    emoji: "🎁"
                },
                properties: {
                    Name: {
                        title: [
                            {
                                text: {
                                    content: title,
                                },
                            },
                        ],
                    },
                    uid: {
                        "rich_text": [
                            {
                                text: {
                                    content: uid,
                                },
                            },
                        ],
                    },
                    categoryName: {
                        select: {
                            name: categoryName,
                        },
                    },
                    categoryId: {
                        select: {
                            name: categoryId,
                        },
                    },
                    amount: {
                        number: amount,
                    },
                    transferId: {
                        "rich_text": [
                            {
                                text: {
                                    content: transferId,
                                },
                            },
                        ],
                    },
                    notifiedPerson: {
                        "people":  [
                            {
                                type: "person",
                                id: "ad765a10-a3ef-4ca7-abc7-3b926c0cabdc",
                                person: {
                                   email:  "bjager@sfu.ca",
                                }
                            },
                        ],
                    },              
                },
            });
            console.log(response);
            log("Success! Successfully added gift card purchase entry.");
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

}