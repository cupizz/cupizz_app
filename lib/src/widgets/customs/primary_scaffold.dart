import 'package:cupizz_app/src/base/base.dart';

class PrimaryScaffold extends StatelessWidget {
  final Widget body;
  final bool isLoading;
  final ScrollController scrollController;
  final Widget footer;
  final Widget bottomNavigationBar;
  final PreferredSizeWidget appBar;
  final Widget drawer;
  final Function onBack;

  PrimaryScaffold({
    Key key,
    this.body,
    this.isLoading = false,
    this.scrollController,
    this.footer,
    this.bottomNavigationBar,
    this.appBar,
    this.drawer,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RouterPage(
      onWillPop: onBack,
      child: Stack(
        children: [
          Scaffold(
            appBar: appBar,
            backgroundColor: context.colorScheme.background,
            drawer: drawer,
            body: body,
            bottomNavigationBar: bottomNavigationBar,
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: context.colorScheme.background.withOpacity(0.5),
                child: LoadingIndicator(),
              ),
            )
        ],
      ),
    );
  }
}
