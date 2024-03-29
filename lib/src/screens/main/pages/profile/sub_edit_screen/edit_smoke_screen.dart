part of '../edit_profile_screen.dart';

class EditSmokeScreen extends StatefulWidget {
  @override
  _EditSmokeScreenState createState() => _EditSmokeScreenState();
}

class _EditSmokeScreenState extends State<EditSmokeScreen> {
  UsualType? selectedValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      selectedValue = Momentum.controller<CurrentUserController>(context)
          .model
          .currentUser
          ?.drinking;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeHelper = SizeHelper(context);

    return PrimaryScaffold(
      appBar: BackAppBar(title: 'Hút thuốc', actions: [
        SaveButton(onPressed: () {
          Momentum.controller<CurrentUserController>(context)
              .updateProfile(smoking: selectedValue);
          Get.back();
        })
      ]),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(sizeHelper.rW(3)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioButtonGroup<UsualType?>(
                spacing: 1.0,
                items: UsualType.getAll(),
                selectedItems: [selectedValue],
                valueToString: (v) => v!.displayValue,
                onItemPressed: (value) => setState(() {
                  selectedValue = value;
                }),
              ),
              SizedBox(
                height: sizeHelper.rW(5),
              ),
              ShowOnProfileText(),
            ],
          ),
        ),
      ),
    );
  }
}
