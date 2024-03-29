import 'dart:io';

import 'package:cupizz_app/src/base/base.dart';

enum CurrentUserEventAction {
  newUserImage,
}

class CurrentUserEvent {
  final CurrentUserEventAction action;
  final String? message;

  CurrentUserEvent({required this.action, this.message});
}

class CurrentUserController extends MomentumController<CurrentUserModel> {
  @override
  CurrentUserModel init() {
    return CurrentUserModel(
      this,
      currentUser: null,
    );
  }

  @override
  Future bootstrapAsync() => getCurrentUser();

  Future<void> getCurrentUser() async {
    await trycatch(() async {
      final service = Get.find<UserService>();
      final result = await service.getCurrentUser();
      model.update(currentUser: result);
    }, throwError: true);
  }

  Future toggleGenderButton(Gender gender) async {
    final currentUser = model.currentUser!.clone<User>();
    if (currentUser.genderPrefer!.contains(gender)) {
      currentUser.genderPrefer!.remove(gender);
    } else {
      currentUser.genderPrefer!.add(gender);
    }
    await updateDatingSetting(genderPrefer: currentUser.genderPrefer);
  }

  final Debouncer hobbyDebouncer = Debouncer(delay: Duration(seconds: 1));
  Future toggleHobbyButton(Hobby hobby) async {
    final currentUser = model.currentUser!.clone<User>();
    if (currentUser.hobbies!.contains(hobby)) {
      currentUser.hobbies!.remove(hobby);
    } else {
      currentUser.hobbies!.add(hobby);
    }
    model.update(currentUser: currentUser);

    hobbyDebouncer.debounce(() async {
      await updateProfile(hobbies: currentUser.hobbies);
    });
  }

  Future updateCover(File? cover) async {
    try {
      model.update(isUpdatingCover: true);
      await updateProfile(cover: cover);
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    } finally {
      model.update(isUpdatingCover: false);
    }
  }

  Future updateAvatar(File? avatar) async {
    try {
      model.update(isUpdatingAvatar: true);
      await updateProfile(avatar: avatar);
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    } finally {
      model.update(isUpdatingAvatar: false);
    }
  }

  Future<void> updateProfile({
    String? nickName,
    String? introduction,
    Gender? gender,
    List<Hobby>? hobbies,
    String? phoneNumber,
    String? job,
    int? height,
    DateTime? birthday,
    File? avatar,
    File? cover,
    double? latitude,
    double? longitude,
    EducationLevel? educationLevel,
    UsualType? smoking,
    UsualType? drinking,
    HaveKids? yourKids,
    List<LookingFor>? lookingFors,
    Religious? religious,
  }) async {
    final currentUser = model.currentUser!.clone<User>();
    if (nickName != null) currentUser.nickName = nickName;
    if (introduction != null) currentUser.introduction = introduction;
    if (gender != null) currentUser.gender = gender;
    if (hobbies != null) currentUser.hobbies = hobbies;
    if (phoneNumber != null) currentUser.phoneNumber = phoneNumber;
    if (job != null) currentUser.job = job;
    if (height != null) currentUser.height = height;
    if (birthday != null) {
      currentUser.birthday = birthday;
      currentUser.age = birthday.getAge();
    }
    if (educationLevel != null) currentUser.educationLevel = educationLevel;
    if (smoking != null) currentUser.smoking = smoking;
    if (drinking != null) currentUser.drinking = drinking;
    if (yourKids != null) currentUser.yourKids = yourKids;
    if (lookingFors != null) currentUser.lookingFors = lookingFors;
    if (religious != null) currentUser.religious = religious;

    model.update(currentUser: currentUser);

    try {
      final service = Get.find<UserService>();
      final result = await service.updateProfile(
        nickName: nickName,
        introduction: introduction,
        gender: gender,
        hobbies: hobbies,
        phoneNumber: phoneNumber,
        job: job,
        height: height,
        avatar: avatar,
        cover: cover,
        birthday: birthday,
        latitude: latitude,
        longitude: longitude,
        educationLevel: educationLevel,
        smoking: smoking,
        drinking: drinking,
        yourKids: yourKids,
        lookingFors: lookingFors,
        religious: religious,
      );
      model.update(currentUser: result);
      if (hobbies != null || longitude != null || latitude != null) {
        unawaited(
            controller<RecommendableUsersController>().fetchRecommendableUsers());
      }
    } catch (e) {
      backward();
      unawaited(Fluttertoast.showToast(msg: e.toString()));
      rethrow;
    }
  }

  Future<void> updateDatingSetting({
    int? minAgePrefer,
    int? maxAgePrefer,
    int? minHeightPrefer,
    int? maxHeightPrefer,
    List<Gender>? genderPrefer,
    int? distancePrefer,
    List<String>? mustHaveFields,
    List<EducationLevel>? educationLevelsPrefer,
    HaveKids? theirKids,
    List<Religious>? religiousPrefer,
  }) async {
    final currentUser = model.currentUser!.clone<User>();

    if (minAgePrefer != null) currentUser.minAgePrefer = minAgePrefer;
    if (maxAgePrefer != null) currentUser.maxAgePrefer = maxAgePrefer;
    if (minHeightPrefer != null) currentUser.minHeightPrefer = minHeightPrefer;
    if (maxHeightPrefer != null) currentUser.maxHeightPrefer = maxHeightPrefer;
    if (genderPrefer != null) currentUser.genderPrefer = genderPrefer;
    if (distancePrefer != null) currentUser.distancePrefer = distancePrefer;
    if (educationLevelsPrefer != null) {
      currentUser.educationLevelsPrefer = educationLevelsPrefer;
    }
    if (theirKids != null) currentUser.theirKids = theirKids;
    if (religiousPrefer != null) currentUser.religiousPrefer = religiousPrefer;

    model.update(currentUser: currentUser);

    final service = Get.find<UserService>();
    await service.updateSetting(
      minAgePrefer: minAgePrefer,
      maxAgePrefer: maxAgePrefer,
      minHeightPrefer: minHeightPrefer,
      maxHeightPrefer: maxHeightPrefer,
      genderPrefer: genderPrefer,
      distancePrefer: distancePrefer,
      mustHaveFields: mustHaveFields,
      educationLevelsPrefer: educationLevelsPrefer,
      theirKids: theirKids,
      religiousPrefer: religiousPrefer,
    );
    unawaited(
        controller<RecommendableUsersController>().fetchRecommendableUsers());
  }

  Future updateSetting({
    bool? allowMatching,
    bool? isPrivate,
    bool? showActive,
  }) async {
    if (model.isUpdatingSetting) return;
    try {
      final currentUser = model.currentUser!.clone<User>();
      if (allowMatching != null) currentUser.allowMatching = allowMatching;
      if (isPrivate != null) currentUser.isPrivate = isPrivate;
      if (showActive != null) currentUser.showActive = showActive;

      model.update(currentUser: currentUser, isUpdatingSetting: true);

      final service = Get.find<UserService>();
      model.update(
          currentUser: await service.updateSetting(
        allowMatching: allowMatching,
        isPrivate: isPrivate,
        showActive: showActive,
      ));
    } catch (e) {
      backward();
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    } finally {
      model.update(isUpdatingSetting: false);
    }
  }

  Debouncer updatePushNotiDebouncer =
      Debouncer(delay: Duration(milliseconds: 500));
  void updatePushNoti(NotificationType noti, bool active) {
    final currentUser = model.currentUser!.clone<User>();
    if (active && !currentUser.pushNotiSetting!.contains(noti)) {
      currentUser.pushNotiSetting!.add(noti);
    } else if (!active) {
      currentUser.pushNotiSetting!.remove(noti);
    } else {
      return;
    }
    model.update(currentUser: currentUser);
    updatePushNotiDebouncer.debounce(() async {
      try {
        final service = Get.find<UserService>();
        await service.updateSetting(
          pushNotiSetting: currentUser.pushNotiSetting,
        );
        Get.snackbar(
          Strings.common.success,
          'Đã lưu cài đặt thành công',
        );
      } catch (e) {
        backward();
        await Fluttertoast.showToast(msg: e.toString());
        rethrow;
      }
    });
  }

  Future removeUserImage(UserImage image) async {
    try {
      model.update(isDeletingImage: true);
      final service = Get.find<UserService>();
      await service.removeUserImage(image.id);
      model.currentUser!.userImages!.remove(image);
      model.newOrderList.remove(image);
      model.update(
        currentUser: model.currentUser,
        newOrderList: model.newOrderList,
      );
      unawaited(getCurrentUser());
    } catch (e) {
      backward();
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    } finally {
      model.update(isDeletingImage: false);
    }
  }

  Future addImage(File image) async {
    try {
      model.update(isAddingImage: true);
      final service = Get.find<UserService>();
      final userImage = await service.addImage(image);
      model.currentUser!.userImages!.add(userImage);
      model.newOrderList.add(userImage);
      model.update(
        currentUser: model.currentUser,
        newOrderList: model.newOrderList,
      );
      unawaited(getCurrentUser());
      sendEvent(CurrentUserEvent(action: CurrentUserEventAction.newUserImage));
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    } finally {
      model.update(isAddingImage: false);
    }
  }

  Future addAnswer(UserImage userImage) async {
    try {
      model.currentUser!.userImages!.add(userImage);
      model.newOrderList.add(userImage);
      model.update(
        currentUser: model.currentUser,
        newOrderList: model.newOrderList,
      );
      unawaited(getCurrentUser().then((value) => sendEvent(
          CurrentUserEvent(action: CurrentUserEventAction.newUserImage))));
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future editAnswer(
    UserImage userImage, {
    String? content,
    required ColorOfAnswer color,
    File? image,
  }) async {
    try {
      final result = await Get.find<UserService>().editAnswer(
        userImage.id,
        content: content,
        color: color.color,
        textColor: color.textColor,
        gradient: color.gradient,
        backgroundImage: image,
      );
      await getCurrentUser();
      final index = model.newOrderList.indexOf(userImage);
      model.newOrderList[index] = result;
      model.update(newOrderList: model.newOrderList);
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }

  Future updateUserImagesOrder() async {
    try {
      model.update(
        currentUser: await Get.find<UserService>()
            .updateUserImagesSortOrder(model.newOrderList),
        newOrderList: [],
      );
    } catch (e) {
      await Fluttertoast.showToast(msg: '$e');
    }
  }

  void changeOrder(int oldIndex, int newIndex) {
    if (!model.newOrderList.isExistAndNotEmpty) {
      model.newOrderList.addAll(model.currentUser!.userImages!);
    }
    if (newIndex > model.newOrderList.length - 1) return;
    final userImage = model.newOrderList.removeAt(oldIndex);
    model.newOrderList.insert(newIndex, userImage);
    model.update(newOrderList: model.newOrderList);
  }

  Future changePassword(String oldPassword, String newPassword) async {
    if (oldPassword == newPassword) return;
    await trycatch(() async {
      await Get.find<UserService>().changePassword(oldPassword, newPassword);
    }, throwError: true);
    await Fluttertoast.showToast(
        msg: 'Đổi mật khẩu thành công.\nVui lòng đăng nhập lại.');
    unawaited(controller<AuthController>().logout());
  }

  Future reloadRemainingSuperLike() async {
    final remainingSuperLike =
        await Get.find<UserService>().remainingSuperLikeQuery();
    model.currentUser!.remainingSuperLike = remainingSuperLike;
    model.update(currentUser: model.currentUser);
  }
}
