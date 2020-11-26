library edit_profile_screen;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../base/base.dart';

part 'sub_edit_screen/edit_age_screen.dart';
part 'sub_edit_screen/edit_drink_screen.dart';
part 'sub_edit_screen/edit_gender_screen.dart';
part 'sub_edit_screen/edit_height_screen.dart';
part 'sub_edit_screen/edit_hobbies_screen.dart';
part 'sub_edit_screen/edit_location_screen.dart';
part 'sub_edit_screen/edit_lookup_screen.dart';
part 'sub_edit_screen/edit_marriage_screen.dart';
part 'sub_edit_screen/edit_religion_screen.dart';
part 'sub_edit_screen/edit_smoke_screen.dart';
part 'sub_edit_screen/edit_text_screen.dart';
part 'widgets/custom_check_box_group.dart';
part 'widgets/custom_item_choice.dart';
part 'widgets/custom_radio_button_group.dart';
part 'widgets/multi_select_hobby.dart';
part 'widgets/multiselect_dialog_hobby.dart';
part 'widgets/row_edit_info.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _bioController = TextEditingController();
  int bioLenght;
  @override
  void initState() {
    super.initState();
    _bioController.addListener(_onBioChanged);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _onBioChanged() {
    print(_bioController.text.length.toString());
    if (!(_bioController.text.length == 0 && this.bioLenght == null)) {
      setState(() {
        this.bioLenght = _bioController.text.length;
      });
    }
  }

  Widget buildWrapperRowEditInfo(
      String title, List<Widget> listWidgetItems, SizeHelper sizeHelper) {
    List<Widget> children = new List<Widget>();
    children.add(Text(
      title,
      style: context.textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
    ));
    children.add(const SizedBox(height: 10.0));
    for (var widget in listWidgetItems) {
      children.add(widget);
      children.add(const SizedBox(height: 10));
    }
    children.add(Divider(
      thickness: 1.0,
      indent: 0,
      endIndent: 0,
      height: 30.0,
      color: context.colorScheme.onSurface,
    ));
    children.add(const SizedBox(height: 10.0));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget buildBasicInfo(SizeHelper sizeHelper) {
    List<Widget> listWidgetItems = new List<Widget>();

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.account_circle_outlined,
      title: "Tên",
      value: "Thăng",
      onClick: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditTextScreen(
                title: "Tên",
                onSave: (value) {},
              ),
            ))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.info,
      title: "Độ tuổi",
      value: "22",
      onClick: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditAgeScreen()))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.location_on_rounded,
      title: "Vị trí hẹn hò",
      value: "Đang ở Thành phố Hồ Chí Minh",
      onClick: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditLocationScreen()))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: MdiIcons.human,
      title: "Giới tính",
      value: "Nam",
      onClick: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditGenderScreen()))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.account_circle_outlined,
      title: "Đang tìm kiếm",
      value: "-",
      onClick: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditLookupScreen()))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.height,
      title: "Chiều cao",
      value: "-",
      onClick: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditHeightScreen()))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.house,
      title: "Quê quán",
      value: "Bến Cát, Bình Dương, Viet Nam",
    ));

    return buildWrapperRowEditInfo(
        "Thông tin cơ bản của bạn", listWidgetItems, sizeHelper);
  }

  Widget buildJobAndEducation(SizeHelper sizeHelper) {
    List<Widget> listWidgetItems = new List<Widget>();

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.work,
      title: "Chức danh",
      value: "-",
      onClick: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditTextScreen(
                      title: "Chức danh",
                      onSave: (value) {},
                    )))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.work,
      title: "Công ty",
      value: "-",
      onClick: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTextScreen(
              title: "Bạn đang làm việc ở đâu",
              onSave: (value) {},
            ),
          ),
        )
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.school,
      title: "Trường trung học",
      value: "-",
      onClick: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditTextScreen(
                      title: "Trường trung học",
                      onSave: (value) {},
                    )))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.school,
      title: "Trường đại học cao/cao đẳng",
      value: "-",
      onClick: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTextScreen(
              title: "Trường đại học cao/cao đẳng",
              onSave: (value) {},
            ),
          ),
        )
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.school,
      title: "Trình độ học vấn",
      value: "-",
      onClick: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditTextScreen(
              title: "Trình độ học vấn",
              onSave: (value) {},
            ),
          ),
        )
      },
    ));
    return buildWrapperRowEditInfo(
        "Công việc và học vấn của bạn", listWidgetItems, sizeHelper);
  }

  Widget buildLifeStyle(SizeHelper sizeHelper) {
    List<Widget> listWidgetItems = new List<Widget>();
    listWidgetItems.add(RowEditInfo(
      iconData: Icons.family_restroom,
      title: "Con bạn",
      value: "Chưa có con",
      onClick: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditMarriageScreen()))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.smoking_rooms,
      title: "Hút thuốc",
      value: "Thỉnh thoảng",
      onClick: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditSmokeScreen()))
      },
    ));

    listWidgetItems.add(RowEditInfo(
      iconData: Icons.local_bar,
      title: "Uống rượu",
      value: "Thỉnh thoảng",
      onClick: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => EditDrinkScreen()))
      },
    ));
    return buildWrapperRowEditInfo(
        "Lối sống của bạn", listWidgetItems, sizeHelper);
  }

  Widget buildReligion(SizeHelper sizeHelper) {
    List<Widget> listWidgetItems = new List<Widget>();
    listWidgetItems.add(RowEditInfo(
      iconData: Icons.self_improvement,
      title: "Quan điểm tôn giáo",
      value: "khác",
      onClick: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditReligionScreen()))
      },
    ));

    return buildWrapperRowEditInfo(
        "Lối sống của bạn", listWidgetItems, sizeHelper);
  }

  Widget buildFavorites(SizeHelper sizeHelper) {
    List<Widget> listWidgetItems = new List<Widget>();
    listWidgetItems.add(InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EditHobbiesScreen()));
      },
      child: Container(
        width: sizeHelper.rW(45),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.grey[300],
        ),
        child: Padding(
          padding: EdgeInsets.all(sizeHelper.rW(2)),
          child: Wrap(
            children: [
              Icon(
                Icons.search,
                size: sizeHelper.rW(6.0),
              ),
              SizedBox(
                height: sizeHelper.rW(3),
              ),
              Text(
                "Thêm sở thích",
                style: TextStyle(
                  fontSize: sizeHelper.rW(5.0),
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    ));

    return buildWrapperRowEditInfo(
        "Sở thích của bạn", listWidgetItems, sizeHelper);
  }

  @override
  Widget build(BuildContext context) {
    SizeHelper sizeHelper = new SizeHelper(context);

    return PrimaryScaffold(
      appBar: AppBar(
        title: Text(
          "Chỉnh sửa hồ sơ hẹn hò",
          style: context.textTheme.subtitle2,
        ),
        backgroundColor: context.colorScheme.background,
        leading: IconButton(
          onPressed: () {
            RouterService.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: context.colorScheme.onBackground,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Giới thiệu bản thân",
                    style: context.textTheme.headline6
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: sizeHelper.rW(0.5)),
                    child: TextFormField(
                      controller: _bioController,
                      // autovalidate: true,
                      autocorrect: false,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      style: context.textTheme.bodyText1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            "Hãy mô tả bản thân bạn bằng vài từ hoặc câu...",
                        hintStyle: context.textTheme.bodyText1
                            .copyWith(color: context.colorScheme.onSurface),
                      ),
                    ),
                  ),
                  if (this.bioLenght != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$bioLenght/500",
                          style: context.textTheme.caption,
                        ),
                        InkWell(
                          onTap: () => {},
                          child: Text(
                            Strings.button.save,
                            style: context.textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        )
                      ],
                    ),
                ],
              ),
              Divider(
                thickness: 1.0,
                indent: 0,
                endIndent: 0,
                height: 10.0,
                color: context.colorScheme.onSurface,
              ),
              const SizedBox(height: 10.0),
              buildBasicInfo(sizeHelper),
              buildJobAndEducation(sizeHelper),
              buildLifeStyle(sizeHelper),
              buildReligion(sizeHelper),
              buildFavorites(sizeHelper)
            ],
          ),
        ),
      ),
    );
  }
}
