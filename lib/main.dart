import 'package:flutter/material.dart';
import 'package:gharas_saudi_app/core/utils/size_config.dart';
import 'core/utils/theme.dart';
import 'core/navigation/router/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  MapboxOptions.setAccessToken(dotenv.env['MAP_BOX_API_KEY']!);
  runApp(const GharasSaudiApp());
}

class GharasSaudiApp extends StatelessWidget {
  const GharasSaudiApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Gharas Saudi App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: AppTheme.themeMode,
      routerConfig: router,
    );
  }
}
