import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:wellbeingclinic/page/auth/wrapper.dart';

import '/page/auth/login.dart';
import '/page/blog/blog_details.dart';
import '/test/screens/preview_multi.dart';
import '/test/screens/result_page_multi.dart';
import '/test/screens/result_page_single.dart';
import 'firebase_options.dart';
import 'page/ai_agent/ai_chat.dart';
import 'page/auth/forgot_password.dart';
import 'page/auth/registration.dart';
import 'page/blog/blog_screen.dart';
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
  //
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  await initializeDateFormatting('bn', null);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
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
        GetPage(name: '/', page: () => const Wrapper()),
        GetPage(
          name: '/home',
          page: () => const MainPage(),
          transition: Transition.noTransition,
        ),

        // tests
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

        //
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

        //
        GetPage(
          name: '/profile',
          page: () => const Profile(),
          transition: Transition.noTransition,
        ),

        //
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/register', page: () => const RegistrationScreen()),
        GetPage(
            name: '/forgot-password', page: () => const ForgotPasswordScreen()),

        //
        GetPage(name: '/chat', page: () => const ChatScreen()),
      ],
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const UnknownRoutePage(),
      ),
    );
  }
}
