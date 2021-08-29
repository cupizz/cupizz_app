import 'dart:developer';

import 'package:cupizz_app/src/base/base.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../app.dart';

class AuthController extends MomentumController<AuthModel> {
  @override
  AuthModel init() {
    return AuthModel(this);
  }

  @override
  Future<void> bootstrapAsync() async {
    try {
      await Get.find<OneSignalService>().init();
    } catch (e) {
      log(e.toString(), name: 'Error');
    }
    if (await isAuthenticated) {
      unawaited(gotoHome());
      await controller<LocationController>()
          .checkPermission(AppConfig.navigatorKey.currentContext);
    } else {
      unawaited(gotoAuth());
    }
    return super.bootstrapAsync();
  }

  void navigateToHomeIfAutheticated() async {
    if (await isAuthenticated) {
      await gotoHome();
    }
  }

  Future<bool> get isAuthenticated async =>
      (await Get.find<StorageService>().getToken) != null;

  Future<void> loginEmail(String email, String password) async {
    await Get.find<AuthService>().loginEmail(email.trim(), password,
        controller<CurrentUserController>().getCurrentUser);
    await _afterLogin();
    unawaited(Get.find<StorageService>().saveLoginEmail(email.trim()));
  }

  Future<void> loginSocial(SocialProviderType type) async {
    try {
      model.update(isLoading: true);
      if (type == SocialProviderType.google) {
        final googleSignIn = GoogleSignIn(
          scopes: <String>[
            'email',
            'profile',
            'https://www.googleapis.com/auth/contacts.readonly'
          ],
        );
        await googleSignIn.signIn();
        if (googleSignIn.currentUser == null) return;
        GoogleSignInAuthentication auth;
        auth = await googleSignIn.currentUser!.authentication;
        final tokenGoogle = auth.accessToken;
        debugPrint('Token Google: $tokenGoogle');
        await Get.find<AuthService>().loginSocial(type, tokenGoogle,
            controller<CurrentUserController>().getCurrentUser);
        unawaited(googleSignIn.signOut());
      } else if (type == SocialProviderType.facebook) {
        try {
          var result = await FacebookAuth.instance.login();
          if (result.accessToken == null) {
            return;
          }
          await Get.find<AuthService>().loginSocial(
              SocialProviderType.facebook,
              result.accessToken!.token,
              controller<CurrentUserController>().getCurrentUser);
        } catch (e) {
          await Fluttertoast.showToast(msg: e.toString());
          rethrow;
        }
      } else {
        return;
      }
      await _afterLogin();
    } finally {
      model.update(isLoading: false);
    }
  }

  Future _afterLogin() async {
    reset();
    unawaited(gotoHome());
    final userId = await Get.find<StorageService>().getUserId;
    if (userId.isExistAndNotEmpty) {
      await Get.find<OneSignalService>().subscribe(userId!);
      await controller<LocationController>()
          .checkPermission(AppConfig.navigatorKey.currentContext);
    }
  }

  Future<void> _register(String? registerToken) async {
    await trycatch(() async {
      await Get.find<AuthService>().register(
        registerToken,
        model.nickname,
        model.password,
        controller<CurrentUserController>().getCurrentUser,
      );
      await _afterLogin();
    });
  }

  Future<void> registerEmail() async {
    await trycatch(() async {
      final otpToken = await Get.find<AuthService>().registerEmail(model.email);
      model.update(otpToken: otpToken);
    }, throwError: true);
  }

  Future<void> vertifyOtp(String otp) async {
    if (!model.otpToken.isExistAndNotEmpty) return;
    await trycatch(() async {
      final registerToken =
          await Get.find<AuthService>().verifyOtpEmail(model.otpToken, otp);
      await _register(registerToken);
    });
  }

  Future<void> logout() async {
    await Get.find<AuthService>().logout();
    unawaited(Get.find<OneSignalService>().unSubscribe());
    Get.reset();
    await initServices();
    Momentum.resetAll(AppConfig.navigatorKey.currentContext!);
    Momentum.restart(AppConfig.navigatorKey.currentContext!, momentum());
    unawaited(Get.offAndToNamed(Routes.login));
  }

  Future<void> gotoHome() async {
    await Get.offAllNamed(Routes.home);
  }

  Future<void> gotoAuth() async {
    await Get.offAllNamed(Routes.login);
  }
}
