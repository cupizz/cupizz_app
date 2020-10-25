part of 'index.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double width = 190.0;
  double widthIcon = 200.0;
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FlareControls controls = FlareControls();
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    if (AppConfig.instance.isDev) {
      email.text = 'hienlh1298@gmail.com';
      password.text = 'abc123456';
    }
  }

  _getDisposeController() {
    email.clear();
    password.clear();
    emailFocus.unfocus();
    passwordFocus.unfocus();
  }

  Future _onLogin() async {
    if (formKey.currentState.validate()) {
      final authCtl = Momentum.of<AuthController>(context);
      try {
        await authCtl.login(email.text, password.text);
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  _onGoToRegister() {
    _getDisposeController();
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: Duration(milliseconds: 800),
        child: RegisterScreen(),
      ),
    )
        // Router.goto(
        //   context,
        //   RegisterScreen,
        //   transition: (ctx, widget) => PageTransition(
        //     type: PageTransitionType.rightToLeft,
        //     duration: Duration(milliseconds: 800),
        //     child: widget,
        //   ),
        // )
        .then((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          width = 190;
          widthIcon = 200;
        });
      });
    });
    setState(() {
      width = 400.0;
      widthIcon = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PrimaryScaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(),
                height: size.height,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      context.colorScheme.primaryVariant.withOpacity(0.7),
                      context.colorScheme.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOutQuad,
                child: AnimationBuildLogin(
                  size: size,
                  yOffset: size.height / 1.36,
                  color: context.colorScheme.background,
                ),
              ),
              AuthHeader(controls: controls),
              Padding(
                padding: EdgeInsets.only(
                  right: 22,
                  left: 22,
                  bottom: 22,
                  top: 270,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      child: TextFieldWidget(
                        hintText: Strings.common.email,
                        obscureText: false,
                        prefixIconData: Icons.mail_outline,
                        textEditingController: email,
                        focusNode: emailFocus,
                        validator: Validator.email,
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    Container(
                      child: TextFieldWidget(
                        hintText: Strings.common.password,
                        obscureText: true,
                        prefixIconData: Icons.lock,
                        textEditingController: password,
                        focusNode: passwordFocus,
                        validator: Validator.password,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 8, top: 18),
                      child: Text(
                        Strings.button.forgotPassword,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 18,
                          color: context.colorScheme.onPrimary.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      margin: EdgeInsets.only(
                        top: 40,
                        right: (8),
                        left: (8),
                        bottom: (20),
                      ),
                      child: AuthButton(
                        text: Strings.button.login,
                        onPressed: _onLogin,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: context.colorScheme.background,
        height: 70,
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AnimatedContainer(
                  width: widthIcon,
                  duration: Duration(seconds: 1),
                  curve: Curves.linear,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SocialButton(
                        imageName: Assets.icons.google,
                        margin: EdgeInsets.only(left: 30.0),
                      ),
                      SocialButton(
                        imageName: Assets.icons.facebook,
                        margin: EdgeInsets.only(right: 30.0),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _onGoToRegister,
                  child: AnimatedContainer(
                    height: 65.0,
                    width: width,
                    duration: Duration(milliseconds: 1000),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Icon(Icons.arrow_back_ios,
                              color: context.colorScheme.onPrimary),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: AutoSizeText(
                                  Strings.login.dontHaveAccount,
                                  textAlign: TextAlign.end,
                                  minFontSize: 8,
                                  style: TextStyle(
                                    color: context.colorScheme.onPrimary
                                        .withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                child: Text(
                                  Strings.login.registerNow,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1,
                                    color: context.colorScheme.onPrimary
                                        .withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    curve: Curves.linear,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        topLeft: Radius.circular(40),
                      ),
                      color: context.colorScheme.primaryVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}