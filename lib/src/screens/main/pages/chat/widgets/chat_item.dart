part of '../chat_page.dart';

class ChatItem extends StatefulWidget {
  final Conversation conversation;
  final Function onPressed;
  final Function onHided;
  final Function onDeleted;

  const ChatItem(
      {Key key,
      @required this.conversation,
      this.onPressed,
      this.onHided,
      this.onDeleted})
      : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    final unreadMessageCount = widget.conversation?.unreadMessageCount ?? 0;
    return GestureDetector(
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed?.call();
        } else {
          RouterService.goto(context, MessagesScreen);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CustomNetworkImage(
                      widget.conversation?.images != null &&
                              widget.conversation.images.isNotEmpty
                          ? widget.conversation.images[0].thumbnail
                          : '',
                      isAvatar: true,
                    ),
                  ),
                  if (widget.conversation?.onlineStatus == OnlineStatus.online)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colorScheme.background,
                            width: 2,
                          ),
                          color: Color(widget.conversation.onlineStatus ==
                                  OnlineStatus.online
                              ? 0xff20FF6C
                              : 0xff7D7D7D),
                        ),
                      ),
                    )
                ],
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      widget.conversation?.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyText2
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Text(
                            widget.conversation?.newestMessage?.message ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.bodyText1.copyWith(
                              fontWeight: unreadMessageCount > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          ' ‧ ' +
                              (widget.conversation?.newestMessage != null
                                  ? TimeAgo.format(widget
                                      .conversation.newestMessage.createdAt)
                                  : ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.caption.copyWith(
                            color: context.colorScheme.onBackground,
                            fontWeight: unreadMessageCount > 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (unreadMessageCount > 0) ...[
                const SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    color: Color(0xFFFF5555),
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                  child: new Text(
                    widget.conversation.unreadMessageCount.toString(),
                    style: new TextStyle(
                      color: context.colorScheme.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
