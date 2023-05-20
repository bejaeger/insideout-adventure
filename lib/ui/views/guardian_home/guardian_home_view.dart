import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/guardian_drawer_view/guardian_drawer_view.dart';
import 'package:afkcredits/ui/views/guardian_home/guardian_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/ward_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

class GuardianHomeView extends StatelessWidget {
  final ScreenTimeSession? screenTimeSession;
  const GuardianHomeView({Key? key, this.screenTimeSession}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GuardianHomeViewModel>.reactive(
        // this a singleton because we listen to screen time changes from here!
        viewModelBuilder: () => locator<GuardianHomeViewModel>(),
        disposeViewModel: false,
        onModelReady: (model) async {
          if (model.currentUser.newUser && screenTimeSession == null) {
            model.setNewUserPropertyToFalse();
            SchedulerBinding.instance.addPostFrameCallback(
              (timeStamp) async {
                await model.showFirstLoginDialog();
              },
            );
          }
          // put in post frame callback because we use a singleton!
          SchedulerBinding.instance.addPostFrameCallback(
            (timeStamp) async {
              model.listenToData(screenTimeSession: screenTimeSession);
            },
          );
        },
        builder: (context, model, child) {
          return WillPopScope(
            onWillPop: () async => false,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(
                  showLogo: true,
                  title: " ",
                  drawer: true,
                  screenTimes: model.wardScreenTimeSessionsActive,
                  hasUserGivenFeedback: model.userHasGivenFeedback,
                ),
                endDrawer: const GuardianDrawerView(),
                floatingActionButton: model.navigatingToActiveScreenTimeView
                    ? null
                    : AFKFloatingActionButton(
                        icon: Icon(Icons.switch_account_outlined,
                            color: Colors.white),
                        width: 140,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        title: "Kids area",
                        onPressed: model.showSwitchAreaBottomSheet,
                      ),
                body: model.isBusy
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            AFKProgressIndicator(),
                            verticalSpaceSmall,
                            InsideOutText.body("Loading..."),
                          ])
                    : RefreshIndicator(
                        onRefresh: () => model.listenToData(),
                        child: ListView(
                          // physics: BouncingScrollPhysics(),
                          children: [
                            verticalSpaceMedium,
                            Center(
                                child: InsideOutText.headingOne("Parent Area")),
                            verticalSpaceSmall,
                            SectionHeader(
                              title: "Children",
                              onButtonTap: model.navToCreateWardAccount,
                              buttonIcon: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 5.0),
                                height: 30,
                                width: 40,
                                //color: Colors.red,
                                child: Icon(Icons.person_add,
                                    size: 28, color: kcPrimaryColor),
                              ),
                            ),
                            if (model.supportedWards.length == 0)
                              model.isBusy
                                  ? AFKProgressIndicator()
                                  : Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: InsideOutButton(
                                        onTap: model.navToCreateWardAccount,
                                        title: "Create child account",
                                        height: 80,
                                        //imagePath: ImagePath.peopleHoldingHands,
                                      ),
                                    ),
                            if (model.supportedWards.length > 0)
                              WardsStatsList(
                                viewModel: model,
                              ),
                            verticalSpaceMedium,
                            Container(
                              height: 90,
                              color: kcVeryLightGrey,
                              width: screenWidth(context),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InsideOutButton(
                                        leading: Icon(Icons.add,
                                            color: Colors.white),
                                        title: "Quest",
                                        onTap: model.navToCreateQuest,
                                        height: 50),
                                  ),
                                  horizontalSpaceMedium,
                                  Expanded(
                                    child: InsideOutButton.outline(
                                      title: "Map",
                                      leading: Icon(Icons.map,
                                          color: kcPrimaryColor),
                                      onTap: model.navToGuardianMapView,
                                      height: 50,
                                    ),
                                  ),
                                  //verticalSpaceSmall,
                                ],
                              ),
                            ),
                            verticalSpaceMedium,
                            verticalSpaceMedium,
                            InsideOutText.headingFour(
                              "How can we improve?",
                              align: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: model.navToFeedbackView,
                              child: Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kHorizontalPadding),
                                child: InsideOutButton.text(
                                  title: "Provide Feedback",
                                  onTap: null,
                                  height: 35,
                                ),
                              ),
                            ),
                            verticalSpaceMassive,
                            verticalSpaceMassive,
                          ],
                        ),
                      ),
              ),
            ),
          );
        });
  }
}

class WardsStatsList extends StatelessWidget {
  final GuardianHomeViewModel viewModel;

  const WardsStatsList({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        //shrinkWrap: true,
        itemCount: viewModel.supportedWards.length,
        itemBuilder: (context, index) {
          String uid = viewModel.supportedWards[index].uid;
          User ward = viewModel.supportedWards[index];
          return Padding(
            padding: EdgeInsets.only(
                left: (index == 0) ? 20.0 : 5.0,
                right:
                    (index == viewModel.supportedWards.length - 1) ? 20.0 : 0),
            child: GestureDetector(
              onTap: () => viewModel.navToSingleWardView(uid: uid),
              child: WardStatsCard(
                  isBusy: viewModel.isBusy,
                  screenTimeLastWeek:
                      viewModel.totalWardScreenTimeLastDays[uid],
                  activityTimeLastWeek:
                      viewModel.totalWardActivityLastDays[uid],
                  screenTimeTrend: viewModel.totalWardScreenTimeTrend[uid],
                  activityTimeTrend: viewModel.totalWardActivityTrend[uid],
                  user: ward,
                  wardStats: viewModel.wardStats[uid],
                  screenTimeSession: viewModel.getScreenTime(uid: uid)),
            ),
          );
        },
      ),
    );
  }
}
