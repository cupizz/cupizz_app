part of '../friend_page_v2.dart';

enum FriendPageV2EventAction {
  error,
  changePage,
}

class FriendPageV2Event {
  final FriendPageV2EventAction action;
  final String? message;

  FriendPageV2Event({required this.action, this.message});
}

class FriendPageV2Controller extends MomentumController<FriendPageV2Model> {
  @override
  FriendPageV2Model init() {
    return FriendPageV2Model(this);
  }

  @override
  Future<void> bootstrapAsync() async {
    await _reloadFriends();
    await model.animationController?.fling();
  }

  Future refresh() async {
    await _reloadFriends();
    await model.animationController?.fling();
  }

  Future loadmore() {
    if (model.currentTab == 0) {
      return _loadmoreTab0();
    }
    return _loadmoreTab1();
  }

  void updateReadFriendRequest(String? userId) {
    final indexAll =
        model.allFriends.friends.indexWhere((e) => e.friend!.id == userId);
    final indexReceive = model.receivedFriends.friends
        .indexWhere((e) => e.friend!.id == userId);
    if (indexAll >= 0) {
      model.allFriends.friends[indexAll].readAccepted = true;
    }
    if (indexReceive >= 0) {
      model.receivedFriends.friends[indexReceive].readSent = true;
    }

    model.update(
      allFriends: model.allFriends,
      receivedFriends: model.receivedFriends,
    );
  }

  Future _loadmoreTab0() async {
    final clone = model.allFriends.clone<FriendV2TabData>();
    if (clone.isLastPage || clone.isLoadingMore) return;
    model.update(allFriends: clone.copyWith(isLoadingMore: true));
    try {
      final page = clone.currentPage + 1;
      final result = await Get.find<UserService>().getFriendsV2(
        type: FriendQueryType.friend,
        orderBy: clone.sort,
        page: page,
      );
      clone.addData(result.data!,
          currentPage: page, isLastPage: result.isLastPage);

      model.update(allFriends: clone);
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    } finally {
      model.update(allFriends: clone.copyWith(isLoadingMore: false));
    }
  }

  Future _loadmoreTab1() async {
    if (model.receivedFriends.isLastPage ||
        model.receivedFriends.isLoadingMore) {
      return;
    }
    model.update(
        receivedFriends: model.receivedFriends.copyWith(isLoadingMore: true));
    try {
      final page = model.receivedFriends.currentPage + 1;
      final result = await Get.find<UserService>().getFriendsV2(
        type: FriendQueryType.received,
        orderBy: model.receivedFriends.sort,
        page: page,
        isSuperLike: true,
      );
      model.receivedFriends.addData(result.data!,
          currentPage: page, isLastPage: result.isLastPage);

      model.update(receivedFriends: model.receivedFriends);
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    } finally {
      model.update(
          receivedFriends:
              model.receivedFriends.copyWith(isLoadingMore: false));
    }
  }

  void onChangeTab(int index) {
    if (model.currentTab == index) return;

    model.update(currentTab: index);
    sendEvent(FriendPageV2Event(action: FriendPageV2EventAction.changePage));
  }

  Future _reloadFriends() async {
    try {
      final service = Get.find<UserService>();

      final result = await Future.wait([
        service.getFriendsV2(
          type: FriendQueryType.friend,
          orderBy: model.allFriends.sort,
          page: 1,
        ),
        service.getFriendsV2(
          type: FriendQueryType.received,
          orderBy: model.receivedFriends.sort,
          page: 1,
          isSuperLike: true,
        ),
      ]);

      model.update(
        allFriends: model.allFriends.copyWith(
            currentPage: 1,
            friends: result[0].data,
            isLastPage: result[0].isLastPage),
        receivedFriends: model.receivedFriends.copyWith(
            currentPage: 1,
            friends: result[1].data,
            isLastPage: result[1].isLastPage),
      );
    } catch (e) {
      await Fluttertoast.showToast(msg: e.toString());
      rethrow;
    }
  }
}
