part of '../profile_screen.dart';

class ProfileSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  static const _AVATAR_MAX_SIZE = 100.0;
  static const _AVATAR_MIN_SIZE = 50.0;
  static const _HEADER_MIN_HEIGHT = 100.0;
  final double expandedHeight;
  final PreferredSizeWidget bottom;

  @override
  final FloatingHeaderSnapConfiguration snapConfiguration;

  ProfileSliverAppBarDelegate({
    @required this.expandedHeight,
    this.bottom,
    this.snapConfiguration,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final scrollRate =
        min(1.0, max<double>(0.0, shrinkOffset / (maxExtent - minExtent)));
    final opacity = 0.3 - 0.3 * scrollRate;

    return Container(
      height: expandedHeight,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          _buildCover(context, scrollRate),
          ClipPath(
            clipper: PinkOneClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withOpacity(opacity),
              ),
            ),
          ),
          ClipPath(
            clipper: PinkTwoClipper(),
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withOpacity(opacity),
              ),
            ),
          ),
          _buildAvatar(context, scrollRate),
          _buildUpdateCoverButton(context, scrollRate),
          _buildUpdateCoverButton(context, scrollRate),
        ],
      ),
    );
  }

  Widget _buildCover(BuildContext context, double scrollRate) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0 - 30 * scrollRate,
      child: ClipPath(
        clipper: BackgroudClipper(),
        child: Stack(
          children: [
            Positioned.fill(
                child: MomentumBuilder(
                    controllers: [CurrentUserController],
                    builder: (context, snapshot) {
                      final model = snapshot<CurrentUserModel>();
                      return CustomNetworkImage(
                          model.currentUser?.cover?.url ?? '');
                    })),
            Container(
              width: context.width,
              height: expandedHeight,
              color:
                  context.colorScheme.primary.withOpacity(0 + 0.3 * scrollRate),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, double scrollRate) {
    final size =
        _AVATAR_MAX_SIZE - (_AVATAR_MAX_SIZE - _AVATAR_MIN_SIZE) * scrollRate;
    return Positioned(
      bottom: 0,
      left: context.width / 12 - (context.width / 12 - 20) * scrollRate,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(90.0)),
          border: Border.all(
            color: context.colorScheme.background,
            width: 5,
          ),
          color: context.colorScheme.background,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(90.0)),
            border: Border.all(color: context.colorScheme.primary),
          ),
          child: MomentumBuilder(
              controllers: [CurrentUserController],
              builder: (context, snapshot) {
                final model = snapshot<CurrentUserModel>();
                return CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: model.isUpdatingAvatar
                      ? null
                      : () {
                          pickImage(
                            context,
                            (images) {
                              if (images.isExistAndNotEmpty) {
                                Momentum.controller<CurrentUserController>(
                                        context)
                                    .updateAvatar(images[0]);
                              }
                            },
                            maxSelected: 1,
                            title: Strings.public.updateAvatar,
                          );
                        },
                  child: model.isUpdatingAvatar
                      ? Align(child: LoadingIndicator(size: size * 0.5))
                      : UserAvatar.fromChatUser(
                          user: model.currentUser,
                          size: size,
                          showOnline: false,
                        ),
                );
              }),
        ),
      ),
    );
  }

  Widget _buildUpdateCoverButton(BuildContext context, double scrollRate) {
    final topPosition = 10 + MediaQuery.of(context).padding.top;
    return Positioned(
      right: 10,
      top: topPosition * (1 - scrollRate),
      child: Transform.scale(
        scale: 1 - scrollRate,
        child: MomentumBuilder(
            controllers: [CurrentUserController],
            builder: (context, snapshot) {
              final model = snapshot<CurrentUserModel>();
              return OpacityIconButton(
                icon: !model.isUpdatingCover ? Icons.camera : null,
                iconWidget: model.isUpdatingCover
                    ? LoadingIndicator(
                        color: context.colorScheme.onPrimary,
                        size: 22,
                      )
                    : null,
                onPressed: () {
                  pickImage(
                    context,
                    (images) {
                      if (images.isExistAndNotEmpty) {
                        model.controller.updateCover(images[0]);
                      }
                    },
                    title: Strings.public.updateCover,
                    maxSelected: 1,
                  );
                },
              );
            }),
      ),
    );
  }

  Widget _buildSettingButton(BuildContext context, double scrollRate) {
    final topPosition = 10 + MediaQuery.of(context).padding.top;
    return Positioned(
      right: 10,
      top: topPosition * (1 - scrollRate),
      child: Transform.scale(
        scale: 1 - scrollRate,
        child: MomentumBuilder(
            controllers: [CurrentUserController],
            builder: (context, snapshot) {
              final model = snapshot<CurrentUserModel>();
              return OpacityIconButton(
                icon: !model.isUpdatingCover ? Icons.camera : null,
                iconWidget: model.isUpdatingCover
                    ? LoadingIndicator(
                        color: context.colorScheme.onPrimary,
                        size: 22,
                      )
                    : null,
                onPressed: () {
                  pickImage(
                    context,
                    (images) {
                      if (images.isExistAndNotEmpty) {
                        model.controller.updateCover(images[0]);
                      }
                    },
                    title: Strings.public.updateCover,
                  );
                },
              );
            }),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + (bottom?.preferredSize?.height ?? 0);

  @override
  double get minExtent =>
      _HEADER_MIN_HEIGHT + (bottom?.preferredSize?.height ?? 0);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
