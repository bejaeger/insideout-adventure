import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/guardian_drawer_view/guardian_drawer_view.dart';
import 'package:afkcredits/ui/views/guardian_home/guardian_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/ward_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stacked/stacked.dart';

class GuardianHomeView extends StatefulWidget {
  final ScreenTimeSession? screenTimeSession;
  final bool highlightBubbles;
  final bool allowShowDialog;
  const GuardianHomeView(
      {Key? key,
      this.screenTimeSession,
      this.highlightBubbles = false,
      this.allowShowDialog = false})
      : super(key: key);

  @override
  State<GuardianHomeView> createState() => _GuardianHomeViewState();
}

class _GuardianHomeViewState extends State<GuardianHomeView> {
  final GlobalKey _zero = GlobalKey();
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GuardianHomeViewModel>.reactive(
        // this a singleton because we listen to screen time changes from here!
        viewModelBuilder: () => locator<GuardianHomeViewModel>(),
        disposeViewModel: false,
        onModelReady: (model) async {
          // put in post frame callback because we use a singleton!
          SchedulerBinding.instance.addPostFrameCallback(
            (timeStamp) async {
              model.listenToData(screenTimeSession: widget.screenTimeSession);
            },
          );
          if (widget.highlightBubbles) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => ShowCaseWidget.of(context)
                  .startShowCase([_zero, _one, _two, _three, _four, _five]),
            );
          }
        },
        builder: (context, model, child) {
          if (model.currentUser.newUser &&
              widget.screenTimeSession == null &&
              widget.allowShowDialog) {
            model.setNewUserPropertyToFalse();
            SchedulerBinding.instance.addPostFrameCallback(
              (timeStamp) async {
                await model.showFirstLoginDialog();
              },
            );
          }

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
                body: model.isBusy
                    ? AFKProgressIndicator()
                    : RefreshIndicator(
                        onRefresh: () => model.listenToData(),
                        child: ListView(
                          // physics: BouncingScrollPhysics(),
                          children: [
                            verticalSpaceMedium,
                            Center(
                              child: Showcase(
                                  key: _zero,
                                  description:
                                      'This is your parent area which helps you find a healthy lifestyle for your children. This is how it works...',
                                  child:
                                      InsideOutText.headingOne("Parent Area")),
                            ),
                            verticalSpaceSmall,
                            SectionHeader(
                              title: "Children",
                              onButtonTap: model.navToCreateWardAccount,
                              buttonIcon: Showcase(
                                key: _one,
                                description: '1) Create a child account',
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 5.0),
                                  height: 30,
                                  width: 40,
                                  child: Icon(Icons.person_add,
                                      size: 28, color: kcPrimaryColor),
                                ),
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
                            childButtons(context, model),
                            verticalSpaceTiny,
                            activityButtons(context, model),
                            verticalSpaceMassive,
                          ],
                        ),
                      ),
              ),
            ),
          );
        });
  }

  Widget childButtons(BuildContext context, GuardianHomeViewModel model) {
    return Container(
      height: 96,
      width: screenWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Showcase(
              key: _four,
              description: '4) Set a timer when your child uses screen time',
              child: InsideOutButtonVertical(
                  color: kcBlue.withOpacity(0.9),
                  leading: Icon(Icons.hourglass_top_rounded,
                      color: Colors.grey[100], size: 26),
                  title: "Timer",
                  onTap: model.selectWardToSelectScreenTime,
                  height: 100),
            ),
          ),
          horizontalSpaceSmall,
          Expanded(
              child: Showcase(
            key: _three,
            description: '3) Switch to child area and let them do the quests',
            child: InsideOutButtonVertical(
              color: kcBlue.withOpacity(0.9),
              title: "Switch",
              leading: Image.asset(kSwitchAccountIcon,
                  height: 22, color: Colors.grey[100]),
              onTap: model.selectWardToSwitchAccount,
              height: 100,
            ),
          )),
          horizontalSpaceSmall,
          Expanded(
            child: Showcase(
              key: _five,
              description:
                  'Tip: you can also reward your child with credits for any other activities they engage in',
              child: InsideOutButtonVertical(
                color: kcBlue.withOpacity(0.9),
                title: "Reward",
                leading: Image.asset(kInsideOutLogoSmallPath,
                    height: 24, color: Colors.grey[100]),
                onTap: model.selectWardToReward,
                height: 100,
              ),
            ),
          ),
          //verticalSpaceSmall,
        ],
      ),
    );
  }

  Widget activityButtons(BuildContext context, GuardianHomeViewModel model) {
    return Container(
      height: 100,
      width: screenWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Showcase(
              key: _two,
              description: '2) Create a quest',
              child: InsideOutButtonVertical(
                  // color: kcOrangeOpaque,
                  leading: Image.asset(kActivityIcon,
                      height: 30, color: Colors.grey[50]),
                  title: "Create",
                  onTap: model.navToCreateQuest,
                  height: 80),
            ),
          ),
          horizontalSpaceMedium,
          Expanded(
            child: InsideOutButtonVertical(
              title: "Map",
              leading: Icon(Icons.map, color: Colors.grey[50], size: 30),
              onTap: model.navToGuardianMapView,
              height: 80,
            ),
          ),
          //verticalSpaceSmall,
        ],
      ),
    );
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
