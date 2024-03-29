part of '../home_page.dart';

class OptionsDrawerController extends ChangeNotifier {
  bool _isMenuOpen = false;
  bool get isMenuOpen => _isMenuOpen;

  void openMenu() {
    if (!_isMenuOpen) {
      _isMenuOpen = true;
      notifyListeners();
    }
  }

  void closeMenu() {
    if (_isMenuOpen) {
      _isMenuOpen = false;
      notifyListeners();
    }
  }
}

class OptionsDrawer extends StatefulWidget {
  final double sidebarSize;
  final OptionsDrawerController? controller;

  const OptionsDrawer({
    Key? key,
    this.sidebarSize = 300,
    this.controller,
  }) : super(key: key);

  @override
  _OptionsDrawerState createState() => _OptionsDrawerState();
}

class _OptionsDrawerState extends State<OptionsDrawer> {
  late OptionsDrawerController controller;
  bool isMenuOpen = false;
  Offset _offset = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? OptionsDrawerController();

    controller.addListener(() {
      setState(() {
        isMenuOpen = controller._isMenuOpen;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 1500),
      right: isMenuOpen ? 0 : -widget.sidebarSize,
      top: 0,
      curve: Curves.elasticOut,
      child: SizedBox(
        width: widget.sidebarSize,
        child: GestureDetector(
          onPanUpdate: (details) {
            if (details.localPosition.dx <= widget.sidebarSize) {
              setState(() {
                _offset = details.localPosition;
              });
            }

            if (details.localPosition.dx > widget.sidebarSize - 20 &&
                details.delta.distanceSquared > 2) {
              setState(() {
                isMenuOpen = true;
              });
            }
          },
          onPanEnd: (details) {
            setState(() {
              _offset = Offset(0, 0);
            });
          },
          child: Stack(
            children: <Widget>[
              CustomPaint(
                size: Size(widget.sidebarSize, size.height),
                painter: _DrawerPainter(
                    offset: _offset, color: context.colorScheme.background),
              ),
              Positioned.fill(child: _buildBody())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: MomentumBuilder(
          controllers: [CurrentUserController],
          builder: (context, snapshot) {
            final model = snapshot<CurrentUserModel>();
            if (model.currentUser == null) {
              return ErrorIndicator(
                onReload: Momentum.controller<CurrentUserController>(context)
                    .getCurrentUser,
              );
            }
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _buildTitle(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildGender(model.currentUser!),
                        _buildHobbies(model.currentUser!),
                        _buildDistance(model.currentUser!),
                        _buildAge(model.currentUser!),
                        _buildHeight(model.currentUser!),
                        _buildEnum<EducationLevel>(
                          title: Strings.common.educationLevel,
                          itemToString: (i) => i.displayValue,
                          items: EducationLevel.getAll(),
                          value: model.currentUser!.educationLevelsPrefer,
                          onPressed: (i) {
                            if (model.currentUser!.educationLevelsPrefer !=
                                    null &&
                                model.currentUser!.educationLevelsPrefer!
                                    .contains(i)) {
                              model.currentUser!.educationLevelsPrefer!
                                  .remove(i);
                            } else {
                              model.currentUser!.educationLevelsPrefer!.add(i);
                            }
                            model.controller.updateDatingSetting(
                                educationLevelsPrefer:
                                    model.currentUser!.educationLevelsPrefer);
                          },
                        ),
                        _buildEnum<HaveKids?>(
                          title: 'Con cái',
                          itemToString: (i) => i!.theirDisplay,
                          items: HaveKids.getAll(),
                          value: [model.currentUser!.theirKids],
                          onPressed: (i) {
                            model.currentUser!.theirKids = i;
                            model.controller.updateDatingSetting(
                                theirKids: model.currentUser!.theirKids);
                          },
                        ),
                        _buildEnum<Religious>(
                          title: 'Tôn giáo',
                          itemToString: (i) => i.displayValue,
                          items: Religious.getAll(),
                          value: model.currentUser!.religiousPrefer,
                          onPressed: (i) {
                            if (model.currentUser!.religiousPrefer != null &&
                                model.currentUser!.religiousPrefer!
                                    .contains(i)) {
                              model.currentUser!.religiousPrefer!.remove(i);
                            } else {
                              model.currentUser!.religiousPrefer!.add(i);
                            }
                            model.controller.updateDatingSetting(
                                religiousPrefer:
                                    model.currentUser!.religiousPrefer);
                          },
                        ),
                        const SizedBox(height: 56),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          Strings.drawer.filter,
          style: context.textTheme.headline6!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            InkWell(
              enableFeedback: true,
              onTap: () {
                Momentum.controller<ThemeController>(context).randomTheme();
              },
              child: Icon(
                Icons.color_lens,
                color: context.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              enableFeedback: true,
              onTap: () {
                controller.closeMenu();
              },
              child: Icon(
                Icons.arrow_right_alt,
                color: context.colorScheme.onBackground,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGender(User user) {
    return _buildItem(
      title: Strings.drawer.whoAreYouLookingFor,
      body: Row(
        children: [
          Expanded(
            child: _buildGenderButton(user, Gender.male),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildGenderButton(user, Gender.female),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildGenderButton(user, Gender.other),
          ),
        ],
      ),
    );
  }

  Widget _buildHobbies(User currentUser) {
    return _buildItem(
      title: Strings.common.hobbies,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 10,
            children: currentUser.hobbies!
                .take(5)
                .map(
                  (e) => HobbyItem(hobby: e, isSelected: true),
                )
                .toList(),
          ),
          OutlinedButton(
            onPressed: () {
              HobbiesBottomSheet().show(context);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(width: 1, color: Colors.grey[500]!),
              primary: context.colorScheme.primary.withOpacity(0.5),
            ),
            child: Text(Strings.drawer.chooseOtherHoddies),
          )
        ],
      ),
    );
  }

  Widget _buildDistance(User currentUser) {
    return _buildItem(
      title: Strings.common.distance,
      actions: Row(
        children: [
          Icon(
            Icons.room,
            size: 12,
            color: Colors.grey[500],
          ),
          const SizedBox(width: 5),
          Text('${currentUser.distancePrefer} km',
              style: context.textTheme.caption),
        ],
      ),
      body: FlutterSlider(
        values: [currentUser.distancePrefer.toDouble()],
        max: (1000 < currentUser.distancePrefer
                ? currentUser.distancePrefer
                : 1000)
            .toDouble(),
        min: 0,
        trackBar: FlutterSliderTrackBar(
          activeTrackBar: BoxDecoration(color: context.colorScheme.primary),
        ),
        handler: HeartSliderHandler(context),
        tooltip: CustomSliderTooltip(context, unit: 'km'),
        onDragCompleted: (handlerIndex, lowerValue, upperValue) {
          Momentum.controller<CurrentUserController>(context)
              .updateDatingSetting(
                  distancePrefer:
                      double.tryParse(lowerValue.toString())!.round());
        },
      ),
    );
  }

  Widget _buildAge(User currentUser) {
    return currentUser.minAgePrefer == null || currentUser.maxAgePrefer == null
        ? const SizedBox.shrink()
        : _buildItem(
            title: Strings.common.age,
            actions: Text(
                '${currentUser.minAgePrefer} - ${currentUser.maxAgePrefer} tuổi',
                style: context.textTheme.caption),
            body: FlutterSlider(
              values: [
                currentUser.minAgePrefer!.toDouble(),
                currentUser.maxAgePrefer!.toDouble()
              ],
              max: (60 < currentUser.maxAgePrefer!
                      ? currentUser.maxAgePrefer
                      : 60)!
                  .toDouble(),
              min: (18 > currentUser.minAgePrefer!
                      ? currentUser.minAgePrefer
                      : 18)!
                  .toDouble(),
              rangeSlider: true,
              minimumDistance: 1,
              trackBar: FlutterSliderTrackBar(
                activeTrackBar:
                    BoxDecoration(color: context.colorScheme.primary),
              ),
              handlerWidth: 18,
              handlerHeight: 18,
              handler: HeartSliderHandler(context, iconSize: 14),
              rightHandler: HeartSliderHandler(context, iconSize: 14),
              tooltip: CustomSliderTooltip(context, unit: 'tuổi'),
              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                Momentum.controller<CurrentUserController>(context)
                    .updateDatingSetting(
                        minAgePrefer:
                            double.tryParse(lowerValue.toString())!.round(),
                        maxAgePrefer:
                            double.tryParse(upperValue.toString())!.round());
              },
            ),
          );
  }

  Widget _buildHeight(User currentUser) {
    return currentUser.minHeightPrefer == null ||
            currentUser.maxHeightPrefer == null
        ? const SizedBox.shrink()
        : _buildItem(
            title: Strings.common.height,
            actions: Text(
                '${currentUser.minHeightPrefer} - ${currentUser.maxHeightPrefer} cm',
                style: context.textTheme.caption),
            body: FlutterSlider(
              values: [
                currentUser.minHeightPrefer!.toDouble(),
                currentUser.maxHeightPrefer!.toDouble()
              ],
              max: (200 < currentUser.maxHeightPrefer!
                      ? currentUser.maxAgePrefer
                      : 200)!
                  .toDouble(),
              min: (150 > currentUser.minHeightPrefer!
                      ? currentUser.minHeightPrefer
                      : 150)!
                  .toDouble(),
              rangeSlider: true,
              minimumDistance: 1,
              trackBar: FlutterSliderTrackBar(
                activeTrackBar:
                    BoxDecoration(color: context.colorScheme.primary),
              ),
              handlerWidth: 18,
              handlerHeight: 18,
              handler: HeartSliderHandler(context, iconSize: 14),
              rightHandler: HeartSliderHandler(context, iconSize: 14),
              tooltip: CustomSliderTooltip(context, unit: 'cm'),
              onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                Momentum.controller<CurrentUserController>(context)
                    .updateDatingSetting(
                        minHeightPrefer:
                            double.tryParse(lowerValue.toString())!.round(),
                        maxHeightPrefer:
                            double.tryParse(upperValue.toString())!.round());
              },
            ),
          );
  }

  Widget _buildEnum<T extends Enumerable?>({
    String? title,
    List<T>? value,
    List<T> items = const [],
    Function(T i)? onPressed,
    String Function(T i)? itemToString,
  }) {
    return _buildItem(
      title: title ?? '',
      body: Wrap(
        spacing: 10,
        children: items
            .map(
              (e) => OptionButton(
                title: itemToString?.call(e) ?? e.toString(),
                isSelected: value?.contains(e) ?? false,
                onPressed: () => onPressed?.call(e),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildItem({
    required String title,
    Widget? actions,
    Widget? body,
    bool showBottomSeparator = true,
  }) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (actions != null) actions
          ],
        ),
        if (body != null) ...[const SizedBox(height: 10), body],
        const SizedBox(height: 15),
        if (showBottomSeparator) Divider(color: Colors.grey[500])
      ],
    );
  }

  Widget _buildGenderButton(User user, Gender gender) => OptionButton(
      title: gender.displayValue,
      isSelected: user.genderPrefer?.contains(gender) ?? false,
      onPressed: () async {
        try {
          await Momentum.controller<CurrentUserController>(context)
              .toggleGenderButton(gender);
        } catch (e) {
          await Fluttertoast.showToast(msg: e.toString());
        }
      });
}

class _DrawerPainter extends CustomPainter {
  final Offset? offset;
  final Color color;

  _DrawerPainter({this.offset, this.color = Colors.white});

  double getControlPointX(double width) {
    if (offset!.dx == 0) {
      return 0;
    } else {
      return offset!.dx > width ? -offset!.dx : -75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.0);
    var path = Path();
    path.moveTo(size.width * 2, 0);
    path.lineTo(0, -50);
    path.quadraticBezierTo(
        getControlPointX(size.width), offset!.dy, 0, size.height);
    path.lineTo(size.width * 2, size.height + 50);
    path.close();

    canvas.drawShadow(path, Colors.grey[900]!, 2.0, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class HeartSliderHandler extends FlutterSliderHandler {
  HeartSliderHandler(BuildContext context, {double? iconSize})
      : super(
          child: Icon(
            Icons.favorite,
            color: context.colorScheme.primary,
            size: iconSize,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.background,
            border: Border.all(color: context.colorScheme.primary),
            shape: BoxShape.circle,
          ),
        );
}

class CustomSliderTooltip extends FlutterSliderTooltip {
  CustomSliderTooltip(BuildContext context, {String unit = ''})
      : super(
          boxStyle: FlutterSliderTooltipBox(
            decoration: BoxDecoration(
              color: context.colorScheme.primary.withOpacity(.8),
            ),
          ),
          textStyle: context.textTheme.caption!
              .copyWith(color: context.colorScheme.onPrimary),
          format: (v) => '${double.tryParse(v)?.round() ?? v} $unit',
        );
}
