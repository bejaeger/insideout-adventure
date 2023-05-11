const nodemailer = require('nodemailer');

// enable short hand for console.log()
function log(message: string) {
    console.log(`EmailService | ${message}`);
}

export class EmailService {
    transporter: any;

    constructor(
    ) {
        //create and config transporter
        this.transporter = nodemailer.createTransport({
            host: 'smtp.gmail.com',
            port: 465,
            secure: true, // true for 465, false for other ports
            auth: {
                user: 'jaeger.benjamin7@gmail.com',
                // generated app password from google account
                pass: 'jmdkgdqaaslejgeo',
            },
        });
    }


    async sendMail(mailOptions: any) {
        log("send email");
        this.transporter.sendMail(mailOptions, (error: any, info: any) => {
            if (error) {
                log("Sending mail failed due to error:" + error.toString());
            } else {
                log("Succesfully sent email");
            }
        });
    }

    async notifyAFKCreditsTeamAfterGiftCardPurchase(status: string, uid: string, categoryId: string, transferId: string, code: any) {

        // TODO: Get current version of app somehow as senderName?
        let senderName: string = "InsideOut Adventure App";
        let message: string;
        if (status == "pending") {
            message = "NEED TO PROVIDE GIFT CARD: User with id " + uid + " purchased gift card with id " + categoryId + " in transaction with id " + transferId + ".";
        } else {
            message = "Need to update gift card: User with id " + uid + " succesfully purchased gift card with id " + categoryId + " and code "+ code + " in transaction with id " + transferId + ".";
        }
        const mailOptions = {
            from: senderName,
            to: "afkcredits@gmail.com",
            subject: 'ACTION NEEDED: New Gift Card Purchase',
            text: message,
        };
        this.sendMail(mailOptions);
    }

    async sendEmailFeedback(message: string) {
        // TODO: In message include app version, uid, email of sender
        let senderName: string = "InsideOut Adventure App - Feedback";
        const mailOptions = {
            from: senderName,
            to: "benjamin.jaeger@posteo.de",
            subject: 'New Feedback to InsideOut Adventure App',
            text: message,
        };
        this.sendMail(mailOptions);
    }

}

