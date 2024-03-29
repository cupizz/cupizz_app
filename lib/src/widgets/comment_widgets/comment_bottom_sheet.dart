import 'package:cupizz_app/src/base/base.dart';
import 'package:cupizz_app/src/screens/main/pages/post/post_page.controller.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'comment_item.dart';

class CommentBottomSheet {
  final PostPageController controller;
  final BuildContext context;
  final Post post;
  final int totalLike;
  final bool autoFocusInput;

  CommentBottomSheet(
    this.context, {
    required this.post,
    required this.totalLike,
    required this.controller,
    this.autoFocusInput = false,
  });

  Future show() async {
    final inputController = TextEditingController();
    final sheetController = SheetController();

    await showSlidingBottomSheet(
      context,
      builder: (context) {
        return SlidingSheetDialog(
          controller: sheetController,
          snapSpec: SnapSpec(snappings: [0.9, 0.7], initialSnap: 0.9),
          cornerRadius: 10,
          color: context.colorScheme.background,
          headerBuilder: (context, state) {
            return Material(
              color: context.colorScheme.background,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        width: 1, color: context.colorScheme.surface),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.favorite, color: context.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        '$totalLike người yêu thích',
                        style: context.textTheme.subtitle1!.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          footerBuilder: (context, state) {
            return Material(
              color: context.colorScheme.background,
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                      border: Border(
                    top: BorderSide(
                        width: 1, color: context.colorScheme.surface),
                  )),
                  child: ListView(
                    shrinkWrap: true,
                    itemExtent: null,
                    padding: EdgeInsets.zero,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            controller.changeIsIncognitoComment();
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: controller.isIncognitoComment,
                                activeColor: context.colorScheme.primary,
                                onChanged: (_) {
                                  controller.changeIsIncognitoComment();
                                },
                              ),
                              Text(
                                'Bình luận ẩn danh',
                                style: context.textTheme.bodyText1!.copyWith(
                                  color: controller.isIncognitoComment
                                      ? context.colorScheme.primary
                                      : context.colorScheme.onBackground,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      TextField(
                        controller: inputController,
                        autofocus: autoFocusInput,
                        style: context.textTheme.bodyText2,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: 'Nhập bình luận',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          prefixIcon: AnimatedSwitcher(
                            duration: 500.milliseconds,
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                            child: Padding(
                              key: ValueKey(controller.isIncognitoComment),
                              padding: const EdgeInsets.all(8.0),
                              child: UserAvatar.fromChatUser(
                                  size: 30,
                                  user: !controller.isIncognitoComment
                                      ? Momentum.controller<
                                              CurrentUserController>(context)
                                          .model
                                          .currentUser
                                      : null),
                            ),
                          ),
                          suffixIcon: ArgonButton(
                            height: 30,
                            width: 30,
                            borderRadius: 22.0,
                            roundLoadingShape: false,
                            color: Colors.transparent,
                            loader: Center(
                              child: LoadingIndicator(
                                color: context.colorScheme.primaryVariant,
                                size: 25,
                              ),
                            ),
                            onTap: (startLoading, stopLoading, btnState) async {
                              startLoading();
                              try {
                                await controller.commentPost(
                                    post, inputController.text);
                                inputController.clear();
                                await sheetController.scrollTo(0);

                                // @Todo: handle temperature fix bug not render first comment
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              } finally {
                                stopLoading();
                              }
                            },
                            child: Icon(
                              CupertinoIcons.paperplane,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          builder: (context, state) {
            if (post.commentCount! <= 0) {
              return Material(
                color: context.colorScheme.background,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Chưa có bình luận nào hết.\nNhanh nào bạn sẽ là người bình luận đầu tiên.',
                      style: context.textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
            return GetBuilder<PostPageController>(
              init: controller,
              builder: (controller) {
                return ListView(
                  itemExtent: null,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    ..._buildListComment(post.comments!),
                    if (post.comments!.length < post.commentCount!)
                      ArgonButton(
                        height: 50,
                        width: context.width,
                        loader: LoadingIndicator(
                            size: 30, color: context.colorScheme.onBackground),
                        onTap: (startLoading, stopLoading, btnState) async {
                          startLoading();
                          await trycatch(() async {
                            await controller.loadmoreComments(post);
                          });
                          stopLoading();
                        },
                        child: Text(
                          'Tải thêm bình luận',
                          style: context.textTheme.button!.copyWith(
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  List<Widget> _buildListComment(List<Comment> comments) {
    return comments
        .mapIndexed(((e, index) => FadeInTranslate(
              key: ValueKey(e.id),
              delay: 1,
              delayDuration: 300,
              child: Padding(
                padding: EdgeInsets.only(top: index == 0 ? 8.0 : 0),
                child: CommentItem(comment: e),
              ),
            )))
        .toList();
  }
}
