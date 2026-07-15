import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  // Stripe.publishableKey = "pk_test_YOUR_KEY_HERE";
  //
  // await Stripe.instance.applySettings();



  runApp(const MyApp());
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs);
  final String? token =
  prefs.getString(LocalDBKeys.TOKEN);


  final String role =
      prefs.getString('role') ?? 'reader';


  String initialRoute = '/';


  if (token != null && token.isNotEmpty) {

    initialRoute =
    (role == 'author')
        ? '/authorbottomnav'
        : '/bottomnav';

  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: containerColor,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'My Project',
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,

          // Yahan aapki file ka reference use hoga
          initialRoute: '/',
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