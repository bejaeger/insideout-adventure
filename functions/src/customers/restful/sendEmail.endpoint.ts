import { Request, Response } from "express";
import { Post } from "firebase-backend";
import { getPayload } from "../../system/helperFunctions";
import { StatusCodes } from "http-status-codes";
import { ResponseHandler } from "../../system/responseHandler";
import { EmailService } from "../../system/emailService";

const cors = require("cors");

// enable short hand for console.log()
function log(message: string) {
    console.log(`sendEmail | ${message}`);
}

export default new Post((request: Request, response: Response) => {
    cors()(request, response, async () => {
        try {
            log("Calling function with request body:");
            const data: any = getPayload(request.body);
            console.log(data);

            const emailService = new EmailService();

            try {
                if ('receiverEmail' in data) {
                    await emailService.sendEmailConsent(data["message"], data["receiverEmail"]);
                } else {
                    await emailService.sendEmailFeedback(data["message"]);
                }
                
            } catch (e) {
                log("Error when sending email alert!")
                if (typeof e === "string") {
                    log(e);
                }
                if (e instanceof Error) {
                    log(e.message);
                }
            }
            response.status(StatusCodes.OK).send(
                ResponseHandler.returnSuccess()
            );
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


