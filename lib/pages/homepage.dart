import 'dart:io';

import 'package:ai_chat_bot/helper/constants.dart';
import 'package:ai_chat_bot/helper/hive.dart';
import 'package:ai_chat_bot/model/home_type.dart';
import 'package:ai_chat_bot/pages/options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Option> list = [];
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent));
    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        Pref.showOnBoarding = false;
      }
    }
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //     statusBarColor: Colors.white,
    //     statusBarIconBrightness: Brightness.dark,
    //     systemNavigationBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AI Assistant',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w500, color: Colors.blue),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {},
                icon: const Icon(
                  Icons.light_mode_rounded,
                  color: Colors.blue,
                ))
          ],
        ),
        body: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03,
            ),
            children: [
              SizedBox(
                height: size.height * 0.02,
              ),
              ...HomeType.values.map((e) => CustomCard(type: e)).toList(),
            ]),
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final HomeType type;
  const CustomCard({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Animate.restartOnHotReload = true;
    return Container(
      height: size.height * 0.25,
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.blue.withOpacity(0.2)),
      child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onTap: type.onPressed,
          child: type.align
              ? Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
                      child: Lottie.asset(type.path, height: type.height),
                    ),
                    const Spacer(),
                    Text(
                      type.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color.fromARGB(221, 22, 22, 22)),
                    ),
                    const Spacer(
                      flex: 5,
                    ),
                  ],
                )
              : Row(
                  children: [
                    const Spacer(
                      flex: 2,
                    ),
                    Text(
                      type.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color.fromARGB(221, 22, 22, 22)),
                    ),
                    const Spacer(),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.02),
                      child: Lottie.asset(type.path, height: size.height * 0.1),
                    ),
                    const Spacer(),
                  ],
                )),
    ).animate().scale(duration: const Duration(milliseconds: 800));
  }
}
