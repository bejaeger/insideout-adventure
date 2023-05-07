import 'package:afkcredits/app_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

void showTermsAndPrivacyDialog(
    BuildContext context, AppConfigProvider appConfigProvider) {
  return showAboutDialog(
    context: context,
    applicationIcon: Image.asset(
      "assets/inside_out_logo_io_adv.png",
      height: 50,
      width: 50,
    ),
    applicationName: "InsideOut Adventure",
    applicationVersion: appConfigProvider.versionName,
    children: [
      InsideOutText.headingFour("Terms & Conditions"),
      verticalSpaceSmall,
      Text(
        // generated
        """
1. Introduction
- Briefly describe the purpose of the Terms & Conditions and your application.

2. Acceptance of Terms
- State that by downloading or using the app, users agree to be bound by these Terms & Conditions.

3. Eligibility and Children's Privacy
- Specify the age requirements for users (e.g., 13+) and outline the ways in which you comply with applicable child privacy laws (e.g., COPPA).

4. Registration and User Accounts
- Describe the requirements for creating user accounts, and state that users are responsible for maintaining the security of their accounts.

5. Content and Intellectual Property Rights
- Define the scope of rights granted to users for accessing and using your app's content, and specify the rights users grant to you when they submit content (e.g., user-generated content).

6. Rules of Conduct
- Establish rules for users' behavior when they engage with your app, and reserve the right to terminate accounts or remove content that violates these rules.

7. Third-Party Services and Links
- Describe any third-party services or links that may be available in your app, and clarify that you are not responsible for the content or practices of these third parties.

8. Indemnification
- State that users agree to defend, indemnify, and hold your company harmless from any claims or losses resulting from their use of the app or violation of the Terms & Conditions.

9. Limitation of Liability
- Limit your liability for any damages incurred by users as a result of their use of the app, to the extent permitted by law.

10. Disclaimers and Warranties
- Disclaim any warranties, express or implied, related to the app, its content, or its performance.

11. Termination and Suspension
- Reserve the right to terminate or suspend users' access to the app for any reason, including violations of the Terms & Conditions.

12. Governing Law and Dispute Resolution
- Specify the governing law and jurisdiction for resolving any disputes arising from the use of the app or the Terms & Conditions.

13. Changes to the Terms & Conditions
- State that you reserve the right to revise the Terms & Conditions at any time, and explain how users will be notified of any changes.

14. Contact Information
- Provide contact information through which users can reach you with questions or concerns about the Terms & Conditions or the app.""",
        style: bodyStyle,
      ),
      verticalSpaceMedium,
      InsideOutText.headingFour("Privacy Policy"),
      verticalSpaceSmall,
      Text(
        "This is our privacy policy",
        style: bodyStyle,
      ),
    ],
  );
}
