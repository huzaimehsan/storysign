import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';


// Yahan apni routes wali file import karein
import 'constants/color_constants.dart';
import 'constants/local_db_key.dart';
import 'utils/shared_prefrences_methods.dart';

import 'core/routes/App_Routing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");


  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  await Stripe.instance.applySettings();

  final prefs = await SharedPreferences.getInstance();
  prefs.reload();
  Get.put<SharedPreferences>(prefs);

  bool hasSeenOnboarding = SharedPreferencesMethod.getBool(key: LocalDBKeys.SPLASH);
  bool isLoggedIn = SharedPreferencesMethod.getBool(key: 'isLoggedIn');
  String? role = prefs.getString('role');

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: containerColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  String initialRoute;
  final bool isSubscribed = SharedPreferencesMethod.getBool(key: LocalDBKeys.IS_SUBSCRIBED);
  debugPrint('App Startup raw IS_SUBSCRIBED=${prefs.getBool(LocalDBKeys.IS_SUBSCRIBED)}');

  if (!hasSeenOnboarding) {
    initialRoute = '/';
  } else if (isLoggedIn) {
    if (role == 'author') {
      initialRoute = isSubscribed ? '/authorbottomnav' : '/plan';
      debugPrint('App Startup - hasSeenOnboarding=$hasSeenOnboarding isLoggedIn=$isLoggedIn role=$role isSubscribed=$isSubscribed (storedKeys=${prefs.getKeys().toList()})');

    } else {
      initialRoute = '/bottomnav';
    }
  } else {
    initialRoute = '/signin';
  }


  runApp(MyApp(initialRoute : initialRoute));
}
class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute, });

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'My Project',
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,

          // Ab yahan variable use karein
          initialRoute: initialRoute,
          getPages: AppRoutes.routes,

          theme: ThemeData(
            scaffoldBackgroundColor: containerColor,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}