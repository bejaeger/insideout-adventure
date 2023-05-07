import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/parent_drawer_view/parent_drawer_view.dart';
import 'package:afkcredits/ui/views/parent_home/parent_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/child_stats_card.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class ParentHomeView extends StatelessWidget {
  final ScreenTimeSession? screenTimeSession;
  const ParentHomeView({Key? key, this.screenTimeSession}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParentHomeViewModel>.reactive(
        // this a singleton because we listen to screen time changes from here!
        viewModelBuilder: () => locator<ParentHomeViewModel>(),
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
                  screenTimes: model.childScreenTimeSessionsActive,
                  hasUserGivenFeedback: model.userHasGivenFeedback,
                ),
                endDrawer: const ParentDrawerView(),
                floatingActionButton: model.navigatingToActiveScreenTimeView
                    ? null
                    : AFKFloatingActionButton(
                        icon: Image.asset(kSwitchAccountIcon,
                            height: 22, color: Colors.white),
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
                              onButtonTap: model.navToCreateChildAccount,
                              buttonIcon: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 5.0),
                                height: 30,
                                width: 40,
                                child: Icon(Icons.person_add,
                                    size: 28, color: kcPrimaryColor),
                              ),
                            ),
                            if (model.supportedExplorers.length == 0)
                              model.isBusy
                                  ? AFKProgressIndicator()
                                  : Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: InsideOutButton(
                                        onTap: model.navToCreateChildAccount,
                                        title: "Create child account",
                                        height: 80,
                                        //imagePath: ImagePath.peopleHoldingHands,
                                      ),
                                    ),
                            if (model.supportedExplorers.length > 0)
                              ChildrenStatsList(
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
                                      onTap: model.navToParentMapView,
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

class ChildrenStatsList extends StatelessWidget {
  final ParentHomeViewModel viewModel;

  const ChildrenStatsList({
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
        itemCount: viewModel.supportedExplorers.length,
        itemBuilder: (context, index) {
          String uid = viewModel.supportedExplorers[index].uid;
          User explorer = viewModel.supportedExplorers[index];
          return Padding(
            padding: EdgeInsets.only(
                left: (index == 0) ? 20.0 : 5.0,
                right: (index == viewModel.supportedExplorers.length - 1)
                    ? 20.0
                    : 0),
            child: GestureDetector(
              onTap: () => viewModel.navToSingleChildView(uid: uid),
              child: ChildStatsCard(
                  isBusy: viewModel.isBusy,
                  screenTimeLastWeek:
                      viewModel.totalChildScreenTimeLastDays[uid],
                  activityTimeLastWeek:
                      viewModel.totalChildActivityLastDays[uid],
                  screenTimeTrend: viewModel.totalChildScreenTimeTrend[uid],
                  activityTimeTrend: viewModel.totalChildActivityTrend[uid],
                  user: explorer,
                  childStats: viewModel.childStats[uid],
                  screenTimeSession: viewModel.getScreenTime(uid: uid)),
            ),
          );
        },
      ),
    );
  }
}
