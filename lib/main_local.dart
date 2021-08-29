import 'package:graphql_flutter/graphql_flutter.dart';

import 'src/app.dart';
import 'src/base/base.dart';

void main() async {
  const hostServer = '192.168.100.5';
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();
  var configuredApp = AppConfig(
    appName: 'Cubiz Development',
    flavorName: AppFlavor.DEVELOPMENT,
    apiUrl: 'http://$hostServer:1998/graphql',
    wss: 'ws://$hostServer:1998/graphql',
    child: App(),
    sentry: null,
  );

  objectMapping();
  await initServices();
  runApp(configuredApp);
}
