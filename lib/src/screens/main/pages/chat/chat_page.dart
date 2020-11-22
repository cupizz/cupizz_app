library chat_page;

import 'package:cupizz_app/src/screens/messages/messages_screen.dart';
import 'package:cupizz_app/src/widgets/index.dart';
import 'package:flutter/material.dart' hide Router;

import '../../../../base/base.dart';

part 'components/chat_page.controller.dart';
part 'components/chat_page.model.dart';
part 'widgets/chat_item.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<CustomAnimatedListState> _key =
      GlobalKey<CustomAnimatedListState>();

  int messageLength;
  String selectId;
  int selectAction;

  void updateBubble(int val) {
    setState(() {
      messageLength = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.background,
      child: MomentumBuilder(
          controllers: [ChatPageController],
          builder: (context, snapshot) {
            final model = snapshot<ChatPageModel>();
            return Column(
              children: <Widget>[
                buildHeadingBar(context),
                buildButtonBar(context),
                Expanded(
                  child: model.isLoading
                      ? LoadingIndicator()
                      : model.conversations.isEmpty
                          ? NotFoundIndicator()
                          : CustomAnimatedList(
                              items: model.conversations
                                  .asMap()
                                  .map((i, e) {
                                    return MapEntry(
                                        i,
                                        ChatItem(
                                          conversation: e,
                                          onHided: (_) {
                                            _key.currentState.removeItem(i);
                                          },
                                          onDeleted: (_) {
                                            _key.currentState.removeItem(i);
                                          },
                                        ));
                                  })
                                  .values
                                  .toList(),
                            ),
                ),
              ],
            );
          }),
    );
  }

  Widget buildBadge(int length) {
    return length <= 0
        ? const SizedBox.shrink()
        : Container(
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 20,
            height: 20,
            child: Center(
              child: Text(
                length.toString(),
                style: TextStyle(
                    color: context.colorScheme.onPrimary, fontSize: 11),
              ),
            ),
          );
  }

  Widget buildHeadingBar(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 65.0,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 15.0, bottom: 10.0, top: 10),
        color: context.colorScheme.background,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Tin nhắn',
              style: context.textTheme.headline4.copyWith(
                color: context.colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            MomentumBuilder(
                controllers: [ChatPageController],
                builder: (context, snapshot) {
                  final unreadMessageCount =
                      snapshot<ChatPageModel>().unreadMessageCount ?? 0;
                  return buildBadge(unreadMessageCount);
                })
          ],
        ),
      ),
    );
  }

  Container buildButtonBar(BuildContext context) {
    return Container(
      color: context.colorScheme.background,
      height: 45.0,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
      child: Row(
        children: <Widget>[
          Container(
            child: Center(
              child: Text(
                'Công khai',
                style: TextStyle(color: context.colorScheme.onPrimary),
              ),
            ),
            width: 80.0,
            height: 32.0,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: context.colorScheme.secondary.withOpacity(0.7),
                      blurRadius: 4.0)
                ],
                color: context.colorScheme.secondary,
                borderRadius: BorderRadius.circular(20.0)),
          ),
          SizedBox(width: 12.0),
          Text(
            'Ẩn danh',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
