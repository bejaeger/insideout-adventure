import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/views/parental_consent/parental_consent_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/terms_and_privacy.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:stacked/stacked_annotations.dart';
import 'package:afkcredits/ui/views/parental_consent/parental_consent_view.form.dart';

@FormView(
  fields: [
    FormTextField(name: 'email'),
    FormTextField(name: 'code'),
  ],
  autoTextFieldValidation: false,
)
class ParentalConsentView extends StatelessWidget with $ParentalConsentView {
  ParentalConsentView({Key? key}) : super(key: key);

  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParentalConsentViewModel>.reactive(
      viewModelBuilder: () => ParentalConsentViewModel(
          disposeController: () => controller.dispose()),
      onModelReady: (model) {
        listenToFormUpdated(model);
        emailController.text = model.email;
      },
      onDispose: (_) => disposeForm(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Parental Constent",
            onBackButton: () => model.onBackButton(controller),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: model.isBusy
              ? AFKProgressIndicator()
              : PageView(
                  controller: controller,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpaceMedium,
                            InsideOutText.bodyItalic(
                                "We need your consent to our Terms of Service & Privacy Policy."),
                            verticalSpaceSmall,
                            InsideOutButton.outline(
                                title: "Terms of Use & Privacy Policy",
                                onTap: () => showTermsAndPrivacyDialog(
                                    context: context,
                                    appConfigProvider:
                                        model.appConfigProvider)),
                            verticalSpaceMedium,
                            InsideOutText.bodyItalic(
                              "Send verification code to the address below",
                              align: TextAlign.left,
                            ),
                            verticalSpaceSmall,
                            InsideOutInputField(
                              placeholder: 'Email',
                              controller: emailController,
                              errorText:
                                  model.fieldsValidationMessages[EmailValueKey],
                              autofocus: false,
                            ),
                            verticalSpaceMedium,
                            InsideOutButton(
                                title: "Send email",
                                busy: model.isBusy,
                                onTap: () =>
                                    model.sendConsentEmail(controller)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            verticalSpaceMedium,
                            if (!model.verifiedCode)
                              InsideOutText.body(
                                  "We sent a code to your email address:\n${model.email}"),
                            verticalSpaceMedium,
                            if (!model.verifiedCode)
                              Container(
                                width: screenWidth(context, percentage: 1),
                                child: InsideOutInputField(
                                  focusNode: codeFocusNode,
                                  controller: codeController,
                                  style: heading3Style,
                                  placeholder: 'Code',
                                  autofocus: true,
                                  maxLines: 1,
                                  errorText: model
                                      .fieldsValidationMessages[CodeValueKey],
                                ),
                              ),
                            if (!model.verifiedCode) verticalSpaceMedium,
                            if (!model.verifiedCode)
                              InsideOutButton(
                                  title: "Verify code and agree with Terms",
                                  busy: model.isBusy,
                                  onTap: () => model.verifyCode(controller)),
                            if (!model.verifiedCode) verticalSpaceSmall,
                            if (!model.verifiedCode)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: InsideOutButton.text(
                                        title: "Change address",
                                        onTap: () =>
                                            model.onBackButton(controller)),
                                  ),
                                  horizontalSpaceMedium,
                                  Expanded(
                                    child: InsideOutButton.text(
                                        title: "Resend email",
                                        onTap: () => model.sendConsentEmail(
                                            controller,
                                            resend: true)),
                                  ),
                                ],
                              ),
                            if (model.verifiedCode) verticalSpaceMedium,
                            if (model.verifiedCode)
                              Center(
                                child: InsideOutText.subheading(
                                  "Successfully verified code",
                                ),
                              ),
                            if (model.verifiedCode) verticalSpaceMedium,
                            if (model.verifiedCode)
                              InsideOutButton(
                                  title: "Continue",
                                  onTap: () => model.popView(result: true)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
