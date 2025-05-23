import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wellbeingclinic/test/screens/multi_result_page.dart';
import 'package:wellbeingclinic/test/screens/preview_multi.dart';
import 'package:wellbeingclinic/test/screens/single_result_page.dart';

import '/blog/blog_details.dart';
import 'blog/blog_screen.dart';
import 'firebase_options.dart';
import 'page/home.dart';
import 'page/main_page.dart';
import 'page/profile.dart';
import 'page/unknown_route.dart';
import 'test/screens/preview.dart';
import 'test/screens/test.dart';
import 'test/screens/test_details.dart';
import 'test/screens/tests.dart';

//
// firebase deploy --only hosting:wellbeingclinic
Future<void> main() async {
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: GoogleFonts.anekBangla().fontFamily,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const MainPage()),
        GetPage(
          name: '/tests',
          page: () => const Tests(),
        ),
        GetPage(
          name: '/tests/:route',
          page: () => Test(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/tests/:route/details',
          page: () => TestDetails(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/tests/:route/result',
          page: () => SingleResultPage(),
          transition: Transition.downToUp,
          curve: Curves.easeInOut,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: '/tests/:route/results',
          page: () => const MultiResultPage(),
          transition: Transition.downToUp,
          curve: Curves.easeInOut,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(
          name: '/tests/:route/preview',
          page: () => PreviewScreen(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/tests/:route/previews',
          page: () => MultiResultPreviewScreen(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/home',
          page: () => const Home(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/blog',
          page: () => const BlogScreen(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/blog/:id',
          page: () => const BlogDetails(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: '/profile',
          page: () => const Profile(),
          transition: Transition.noTransition,
        ),
      ],
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const UnknownRoutePage(),
      ),
    );
  }
}
