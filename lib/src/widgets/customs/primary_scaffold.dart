import 'package:cupizz_app/src/base/base.dart';
import 'package:flutter/foundation.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class PrimaryScaffold extends StatelessWidget {
  final Widget? body;
  final bool isLoading;
  final ScrollController? scrollController;
  final Widget? footer;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final Function? onBack;
  final double loadingBackgroundOpacity;

  PrimaryScaffold({
    Key? key,
    this.body,
    this.isLoading = false,
    this.scrollController,
    this.footer,
    this.bottomNavigationBar,
    this.appBar,
    this.drawer,
    this.onBack,
    this.floatingActionButton,
    this.loadingBackgroundOpacity = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = CupertinoScaffold(
        body: Scaffold(
      appBar: appBar,
      backgroundColor: context.colorScheme.background,
      drawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    ));
    return Stack(
      children: [
        if (context.height > context.width && kIsWeb)
          Center(
            child: SizedBox(
              width: context.height * 9 / 19.5,
              child: scaffold,
            ),
          )
        else
          scaffold,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedContainer(
              duration: 1.seconds,
              color: context.colorScheme.background
                  .withOpacity(isLoading ? loadingBackgroundOpacity : 0),
              child: isLoading ? LoadingIndicator() : const SizedBox.shrink(),
            ),
          ),
        )
      ],
    );
  }
}
