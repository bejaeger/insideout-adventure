import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/views/create_ward/create_ward_view.form.dart';
import 'package:afkcredits/ui/views/create_ward/create_ward_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/custom_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'validators.dart';

@FormView(
  fields: [
    FormTextField(name: 'name', validator: FormValidators.nameValidator),
    FormTextField(
        name: 'password', validator: FormValidators.passwordValidator),
  ],
  autoTextFieldValidation: false,
)
class CreateWardView extends StatelessWidget with $CreateWardView {
  CreateWardView({Key? key}) : super(key: key);

  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateWardViewModel>.reactive(
      viewModelBuilder: () =>
          CreateWardViewModel(disposeController: () => controller.dispose()),
      onModelReady: (model) => listenToFormUpdated(model),
      onDispose: (_) => disposeForm(),
      builder: (context, model, child) => CustomSafeArea(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "Create Child Account",
            onBackButton: () => model.onBackButton(controller),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: model.isBusy || model.pageIndex == 1
              ? null
              : BottomFloatingActionButtons(
                  swapButtons: true,
                  onTapSecondary: model.pageIndex == 0
                      ? () async {
                          if (model.pageIndex == 0) {
                            FocusScope.of(context).unfocus();
                          }
                          await model.onNextButton(controller);
                        }
                      : () async {
                          if (model.pageIndex == 2) {
                            FocusScope.of(context).unfocus();
                          }
                          await model.onNextButton(controller);
                        },
                  titleSecondary:
                      model.pageIndex < 1 ? "Next \u2192" : "Create Account",
                  busySecondary: model.isLoading,
                  onTapMain: model.pageIndex >= 1
                      ? () async {
                          FocusScope.of(context).unfocus();
                          model.onBackButton(controller);
                        }
                      : () => model.onBackButton(controller),
                  titleMain: model.pageIndex >= 1 ? "\u2190 Back" : "Cancel",
                ),
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
                          children: [
                            verticalSpaceLarge,
                            InsideOutInputField(
                              placeholder: 'Account Name',
                              controller: nameController,
                              errorText:
                                  model.fieldsValidationMessages[NameValueKey],
                              autofocus: model.nameValue == null,
                            ),
                            verticalSpaceMedium,
                            InsideOutInputField(
                              placeholder: 'Password',
                              obscureText: (model.isPwShown) ? false : true,
                              controller: passwordController,
                              errorText: model
                                  .fieldsValidationMessages[PasswordValueKey],
                              trailing: IconButton(
                                onPressed: () {
                                  model.setIsPwShown(!model.isPwShown);
                                },
                                icon: (!model.isPwShown)
                                    ? Icon(Icons.visibility,
                                        color: kcPrimaryColor)
                                    : Icon(Icons.visibility_off,
                                        color: kcPrimaryColor),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: model.showPasswordReasonDialog,
                                  child: InsideOutText(
                                      text: "Why password?",
                                      style: bodyStyleSofia.copyWith(
                                          color: Colors.grey[500],
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13)),
                                ),
                              ),
                            ),
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
                            InsideOutText.subheading(
                                "Does your child use their own phone?"),
                            verticalSpaceMedium,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      model.switchOnOwnPhoneSelected(false),
                                  child: Container(
                                    width: 100,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: kcShadowColor),
                                        color: model.ownPhoneSelected == false
                                            ? kcPrimaryColor.withOpacity(0.8)
                                            : Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: model.ownPhoneSelected == false
                                        ? InsideOutText.headingFour("No")
                                        : InsideOutText.headingFourLight("No"),
                                  ),
                                ),
                                horizontalSpaceMedium,
                                GestureDetector(
                                  onTap: () =>
                                      model.switchOnOwnPhoneSelected(true),
                                  child: Container(
                                    width: 100,
                                    height: 60,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: kcShadowColor),
                                        color: model.ownPhoneSelected == true
                                            ? kcPrimaryColor.withOpacity(0.8)
                                            : Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: model.ownPhoneSelected == true
                                        ? InsideOutText.headingFour("Yes")
                                        : InsideOutText.headingFourLight("Yes"),
                                  ),
                                ),
                              ],
                            ),
                            verticalSpaceLarge,
                            if (model.chooseValueMessage != null)
                              Center(
                                  child: InsideOutText.warn(
                                      model.chooseValueMessage!)),
                            if (model.chooseValueMessage != null)
                              verticalSpaceMedium,
                            InsideOutButton(
                                leading:
                                    Icon(Icons.person_add, color: Colors.white),
                                busy: model.isBusy,
                                onTap: () async {
                                  bool res = await model.addWard();
                                  if (res == false) {
                                    FocusScope.of(context).unfocus();
                                    model.onBackButton(controller);
                                  }
                                },
                                title: "Create account"),
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
