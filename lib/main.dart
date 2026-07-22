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
import 'core/bindings/init_binding.dart';
import 'core/routes/App_Routing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");


  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  await Stripe.instance.applySettings();

  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs);

  bool hasSeenOnboarding = prefs.getBool(LocalDBKeys.SPLASH) ?? false;
 bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
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

  if (!hasSeenOnboarding) {

    initialRoute = '/';
  }
  // } else if (isLoggedIn) {
  //
  //   initialRoute = (role == 'author') ? '/authorbottomnav' : '/bottomnav';
  // }
    else {

    initialRoute = '/signin';
  }

  runApp(MyApp(initialRoute : initialRoute));
}
class MyApp extends StatelessWidget {
  final String initialRoute; // Ye variable add karein

  // Constructor update karein
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