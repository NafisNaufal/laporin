import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laporin/app/controllers/page_index_controller.dart';
import 'firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(PageIndexController(), permanent: true);

  runApp(
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              theme: ThemeData(textTheme: TextTheme()),
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: CircularProgressIndicator(),
              ),
            );
          }
          print(snapshot.data);
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Application",
            initialRoute: snapshot.data?.emailVerified == true
                ? Routes.HOME
                : Routes.WELCOME_SCREEN,
            getPages: AppPages.routes,
          );
        }),
  );
}
