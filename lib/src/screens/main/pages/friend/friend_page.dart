library friend_page;

import 'package:cupizz_app/src/base/base.dart';
import 'package:cupizz_app/src/widgets/index.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

part 'components/friend_page.controller.dart';
part 'components/friend_page.model.dart';
part 'widgets/settings_bottom_sheet.dart';

const _PADDING = 20.0;

class FriendPage extends StatefulWidget {
  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends MomentumState<FriendPage>
    with TickerProviderStateMixin, LoadmoreMixin, KeepScrollOffsetMixin {
  static double lastScrollOffset = 0;
  @override
  double get lastOffset => lastScrollOffset;

  @override
  set lastOffset(double value) {
    lastScrollOffset = value;
  }

  AnimationController? animationController;
  late AnimationController topBarAnimationController;
  bool multiple = true;
  late Animation<double> topBarAnimation;

  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    topBarAnimationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this)
      ..forward();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: topBarAnimationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Momentum.controller<FriendPageController>(context)
        ..model.update(animationController: animationController)
        // ..refresh()
        ..listen<FriendPageEvent>(
          state: this,
          invoke: (data) {
            if (data.action == FriendPageEventAction.error) {
              Fluttertoast.showToast(msg: data.message!);
            }
          },
        );
      animationController!.fling();
    });
  }

  @override
  void onLoadMore() {
    Momentum.controller<FriendPageController>(context).loadmoreFriends();
  }

  @override
  void dispose() {
    animationController!.dispose();
    topBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MomentumBuilder(
              controllers: [FriendPageController],
              builder: (context, snapshot) {
                final model = snapshot<FriendPageModel>();
                final friendsList = [
                  ...model.friends,
                  ...!model.isLastPage!
                      ? List.generate(
                          model.friends.length % 2 == 0 ? 2 : 3, (_) => null)
                      : []
                ];
                if (!friendsList.isExistAndNotEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          'Những người đã được ghép đôi, đã thích bạn hay bạn đã thích sẽ xuất hiện ở đây.',
                          style: context.textTheme.subtitle1!
                              .copyWith(color: context.colorScheme.onSurface),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10),
                      OptionButton(
                        title: 'Cập nhật thông tin',
                        onPressed: () {
                          Get.toNamed(Routes.editProfile);
                        },
                      ),
                    ],
                  );
                }
                return GridView(
                  padding: const EdgeInsets.all(12).copyWith(top: 100),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: multiple ? 2 : 1,
                    mainAxisSpacing: _PADDING,
                    crossAxisSpacing: _PADDING,
                    childAspectRatio: 1,
                  ),
                  children: friendsList
                      .asMap()
                      .map((index, value) {
                        final count = friendsList.length;
                        final animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: animationController!,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        );
                        return MapEntry(
                          index,
                          HomeListView(
                            animation: animation,
                            animationController: animationController,
                            simpleUser: value?.friend,
                          ),
                        );
                      })
                      .values
                      .toList(),
                );
              }),
        ),
        getAppBarUI(),
      ],
    );
  }

  Widget getAppBarUI() {
    return FadeTransition(
      opacity: topBarAnimation,
      child: Container(
        padding: MediaQuery.of(context).padding,
        decoration: BoxDecoration(
          color: context.colorScheme.background.withOpacity(topBarOpacity),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: context.colorScheme.onSurface
                    .withOpacity(0.4 * topBarOpacity),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16 - 8.0 * topBarOpacity,
              bottom: 12 - 8.0 * topBarOpacity),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Strings.friendPage.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22 + 6 - 6 * topBarOpacity,
                      letterSpacing: 1.2,
                      color: context.colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 38,
                width: 38,
                child: InkWell(
                  highlightColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                  onTap: () {
                    SettingsBottomSheet(context).show();
                  },
                  child: Center(
                    child: Icon(
                      Icons.settings,
                      color: context.colorScheme.onSurface,
                    ),
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

class HomeListView extends StatelessWidget {
  const HomeListView({
    Key? key,
    this.simpleUser,
    this.animationController,
    this.animation,
  }) : super(key: key);

  final SimpleUser? simpleUser;
  final AnimationController? animationController;
  final Animation<dynamic>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation as Animation<double>,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: UserItem(simpleUser: simpleUser),
          ),
        );
      },
    );
  }
}
