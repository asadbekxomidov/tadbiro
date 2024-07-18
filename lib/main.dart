import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tadbiro/controller/favorite_user_controller.dart';
import 'package:tadbiro/controller/theme_controller.dart';
import 'package:tadbiro/firebase_options.dart';
import 'package:tadbiro/services/location_services.dart';
import 'package:tadbiro/views/screens/auth/login_screen.dart';
import 'package:tadbiro/views/screens/home/main_screen.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main(List<String> args) async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  LocationServices.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeModeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteUserController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeModeController>(context).nightmode
              ? ThemeData.dark()
              : ThemeData.light(),
          home: child,
          // localizationsDelegates: AppLocalizations.localizationsDelegates,
          // supportedLocales: AppLocalizations.supportedLocales,
        );
      },
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
