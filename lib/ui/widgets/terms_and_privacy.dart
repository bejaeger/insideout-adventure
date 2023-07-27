import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/ui/widgets/about_dialog_ios.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'dart:io' show Platform;

void showTermsAndPrivacyDialog(
    {required BuildContext context,
    required AppConfigProvider appConfigProvider,
    Widget? consentButton,
    Widget? revokeButton}) {
  return Platform.isIOS
      ? showAboutDialog(
          context: context,
          applicationIcon: Image.asset(
            "assets/insideout_logo_io_adv.png",
            height: 50,
            width: 50,
          ),
          applicationName: "InsideOut Adventure",
          applicationVersion: appConfigProvider.versionName,
          children: getTermsText(
              context: context,
              consentButton: consentButton,
              revokeButton: revokeButton),
        )
      : showAboutDialogIos(
          context: context,
          applicationIcon: Image.asset(
            "assets/insideout_logo_io_adv.png",
            height: 50,
            width: 50,
          ),
          applicationName: "InsideOut Adventure",
          applicationVersion: appConfigProvider.versionName,
          children: getTermsText(
              context: context,
              consentButton: consentButton,
              revokeButton: revokeButton),
        );
}

List<Widget> getTermsText(
    {required BuildContext context,
    Widget? consentButton,
    Widget? revokeButton}) {
  return [
    if (consentButton != null) consentButton,
    if (consentButton != null) verticalSpaceMedium,
    Text(
        "Welcome to InsideOut Adventure! Our app incentivizes healthy activities and outdoor exploration while allowing parents to manage their child’s screen time. By using our app, you agree to the following terms, conditions, and privacy policy"),
    verticalSpaceMedium,
    InsideOutText.headingFour("Terms & Conditions"),
    verticalSpaceSmall,
    Text(
      // generated
      """
- Acceptance of Terms -
By downloading or using our app, you agree to be bound by these Terms & Conditions. If you do not agree to these terms, you may not use our app.

- Eligibility/Parental Consent -
In accordance to the Children’s Online Privacy Protection Rule (“COPPA”), we require verifiable parental consent before collecting personal information from children under 13.  Parents must provide explicit consent before their children can use the app.

- Registration and User Accounts -
To use certain features of our app, you may be required to create a user account. When creating an account, you must provide accurate and complete information. You are responsible for maintaining the security of your account and password. If you become aware of any unauthorized use of your account, you must notify us immediately. We reserve the right to suspend or terminate your account at any time for any reason without notice.

- Content and Intellectual Property Rights - 
Our app and all of its content, including but not limited to text, graphics, logos, images, and software, are the property of our company or our licensors and are protected by intellectual property laws. Users are granted a limited, non-exclusive, non-transferable, and revocable license to access and use our app and its content for personal and non-commercial purposes.
Users may submit content to our app, including user-generated content. By submitting content, users grant us a non-exclusive, royalty-free, perpetual, irrevocable, and fully sublicensable right to use, reproduce, modify, adapt, publish, translate, create derivative works from, distribute, and display such content throughout the world in any media. Users represent and warrant that they have all necessary rights to submit the content and that the content does not violate any third-party rights or applicable laws.

- Rules of Conduct -
We reserve the right to terminate accounts or remove content without notice that violate the following rules of conduct:
#1: Treat others with respect.
#2: Stay aware of your surroundings and adhere to the rules of the human world.
#3: Avoid inappropriate content.
#4: No cheating.

- Third-Party Services and Links -
We may provide links to third-party services or websites that are not owned or controlled by us. We are not responsible for the content or practices of these third-party services or websites. By using our app, you acknowledge and agree that we shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such third-party services or websites.

- Indemnification and Limitation of Liability -
Users agree to defend, indemnify, and hold our company and its officers, directors, employees, and agents harmless from any claims, liabilities, damages, losses, and expenses, including reasonable attorneys’ fees and costs, arising out of their use of our app or violation of these Terms & Conditions. To the extent permitted by law, our company shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use of our app or these Terms & Conditions.

- Disclaimers and Warranties -
Our app and its content are provided on an “as is” and “as available” basis without any warranties, express or implied, including but not limited to warranties of merchantability, fitness for a particular purpose, non-infringement, or course of performance. We do not warrant that the app will be error-free, uninterrupted, or free of viruses or other harmful components. Any reliance on the app or its content is at the user’s own risk.

- Governing Law and Dispute Resolution -
These Terms & Conditions shall be governed by and construed in accordance with the laws of the City of Vancouver. Any dispute arising out of or in connection with these Terms & Conditions or the use of our app shall be resolved exclusively by the courts of the City of Vancouver. Users consent to personal jurisdiction in such courts and waive any objection to venue in such courts.

- Changes to the Terms & Conditions -
We reserve the right to revise these Terms & Conditions at any time without notice. By continuing to use our app after any changes are made, users agree to be bound by the revised Terms & Conditions. If we make material changes to these Terms & Conditions, we will provide notice to parents and obtain verifiable parental consent before collecting personal information from children under 13. We will notify parents of any material changes to these Terms & Conditions by posting the updated Terms & Conditions on our app and by sending an email to the email address associated with their account. It is the user’s responsibility to review these Terms & Conditions periodically for any changes.

- Contact Information -
If you have any questions or concerns, please reach out via our in-app feedback function, or directly to our temporary email address patrick.mayerhofer@icloud.com.
""",
      style: bodyStyle,
    ),
    verticalSpaceMedium,
    InsideOutText.headingFour("Privacy Policy"),
    verticalSpaceSmall,
    Text(
      """
- Information Collection -
Some of our Services require you to register with us or sign up for an account before you can use them. Where this is the case, you provide us with information including your in-app username or email address that you choose to use on our Services. We collect and use this information in order to authenticate you when you register an account and use the Services, to make sure you are eligible and able to receive the Services, and so that you receive the correct version of the Services.

You may choose to have an account with a supported external single sign-on service (Google or Apple Login) in order to use some of our services. Where this is the case, the Personal Data we collect also depends on which external accounts you choose to use, their privacy policy, and what your privacy settings with those services allow us to see when you use their services to access our services.

If you choose to link your Google account to the services, we will collect your Google email address and an authentication token provided by Google.

If you choose to link your Apple account to the services, we will collect your email address on file with your Apple ID account or a private relayed email address if you use the Hide My Email option provided by Apple.

We collect and use your device location information as you use our services. Our services include location based games whose core feature is to provide an experience tied to your real world location, so we need to know where you are. We identify your location using a variety of technologies, including GPS, the WiFi points you are accessing the service through and mobile/cell tower triangulation.

We also collect and use your in-app actions to provide information about your achievements.

We do not sell or rent users’ personal information to third parties.

- Data Retention -
We retain users’ personal information for as long as necessary to provide and improve our app and to comply with legal obligations.

- Security -
We take reasonable measures to protect users’ personal information from unauthorized access, use, and disclosure. However, no method of transmission over the internet or method of electronic storage is 100% secure, and we cannot guarantee absolute security.

- Children’s Privacy -
Our app is intended for use by children. All children under 13 require verifiable parental consent. We do not knowingly collect personal information from children under 13 without parental consent. If we become aware that we have collected personal information from a child under 13 without parental consent, we will take steps to delete the information as soon as possible.

- Third-Party Services and Links -
Our application may contain links to third-party websites, services, or applications that are not owned or controlled by us. Additionally, we may integrate certain third-party services or tools into our application to enhance its functionality. This privacy policy only applies to our application, and we have no control over the privacy practices or content of these third-party services. We are not responsible for the privacy practices or the content of any third-party services, and your use of such services is subject to their respective terms and policies.

- Changes to the Privacy Policy -
We reserve the right to revise the Privacy Policy at any time without notice. By continuing to use our app after any changes are made, users agree to be bound by the revised Privacy Policy. If we make material changes to the Privacy Policy, we will provide notice to parents and obtain verifiable parental consent before collecting personal information from children under 13. We will notify parents of any material changes to the Privacy Policy by posting the updated Privacy Policy on our app and by sending an email to the email address associated with their account. It is the user’s responsibility to review these Privacy Policy periodically for any changes.

- Contact Information -
If you have any questions or concerns about our Privacy Policy, please contact us via our in-app feedback function or directly to our temporary email address patrick.mayerhofer@icloud.com.
""",
      style: bodyStyle,
    ),
    verticalSpaceMedium,
    if (revokeButton != null) revokeButton,
    verticalSpaceSmall,
  ];
}
