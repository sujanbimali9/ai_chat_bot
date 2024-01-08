import 'dart:io';

import 'package:ai_chat_bot/helper/constants.dart';
import 'package:ai_chat_bot/helper/hive.dart';
import 'package:ai_chat_bot/pages/homepage.dart';
import 'package:ai_chat_bot/pages/onboardingscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

double scale = 0;
double opacity = 0;

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10)).then((value) {
      setState(() {
        scale = 0.4;
        opacity = 1;
      });
    });
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (!kIsWeb) {
        if (Platform.isAndroid || Platform.isIOS) {
          return Get.off(() {
            return Pref.showOnBoarding
                ? const OnBoardingScreen()
                : const HomeScreen();
          });
        }
      } else {
        return Get.off(() => const HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(
            flex: 4,
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedScale(
              scale: scale,
              duration: const Duration(seconds: 2),
              child: AnimatedOpacity(
                opacity: opacity,
                duration: const Duration(seconds: 2),
                child: Image.asset(
                  'assets/icon/icon.png',
                ),
              ),
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          Lottie.asset(
            'assets/lottie/Animation - 1703068933332.json',
            height: size.height * 0.1,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
