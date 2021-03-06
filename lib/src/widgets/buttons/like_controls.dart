import 'package:cupizz_app/src/base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vibration/vibration.dart';

class LikeControls extends StatelessWidget {
  final Function? onLike;
  final Function? onDislike;
  final Function? onSuperLike;

  const LikeControls({Key? key, this.onLike, this.onDislike, this.onSuperLike})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: context.colorScheme.background,
                  ),
                )),
                Container(
                  width: 245,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: context.colorScheme.primary.withOpacity(0.2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color:
                            context.colorScheme.onBackground.withOpacity(0.15),
                        blurRadius: 20,
                        offset: Offset(2, 1.5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          onPressed: onDislike as void Function()?,
                          child: Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: SuperLikeButton(
                          onPressed: () {
                            onSuperLike?.call();
                            Vibration.vibrate(amplitude: 255, duration: 30);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colorScheme.background,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: context.colorScheme.onBackground.withOpacity(0.15),
                    blurRadius: 30,
                    offset: Offset(2, 1.5),
                  ),
                ],
              ),
              child: Center(
                child: LikeButton(
                  size: 60,
                  onTap: (isLiked) async {
                    onLike?.call();
                    await Vibration.vibrate(amplitude: 255, duration: 10);
                    return null;
                  },
                  isLiked: true,
                  likeBuilder: (isLiked) => Icon(
                    Icons.favorite,
                    size: 40,
                    color: context.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
