import 'package:momentum/momentum.dart';

import '../../services/index.dart';
import 'index.dart';

class AuthController extends MomentumController<AuthModel> {
  @override
  AuthModel init() {
    return AuthModel(this);
  }

  bootstrapAsync() async {
    if (!await isAuthenticated) {
      getService<AuthService>().gotoAuth();
    }
    super.bootstrapAsync();
  }

  Future<bool> get isAuthenticated async =>
      (await getService<StorageService>().getToken) != null;

  Future<void> login(String email, String password) =>
      getService<AuthService>().login(email, password);

  Future<void> logout() => getService<AuthService>().logout();
}