import 'package:ai_chat_bot/helper/constants.dart';
import 'package:ai_chat_bot/model/onboarding.dart';
import 'package:ai_chat_bot/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

int _currentPage = 0;
final PageController _pageController = PageController();

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);

    final List<OnBoarding> list = [
      const OnBoarding(
          title: 'Ask me Anything',
          subTitle:
              'I can be your best Friend & you can ask me anything & i will help you',
          path: 'assets/lottie/Animation - 1703084030721.json'),
      const OnBoarding(
          title: 'Imagination to reality',
          subTitle:
              'just imagine anything and let me know & i will create something wonderful for you',
          path: 'assets/lottie/Animation - 1703084597056.json')
    ];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 1,
          ),
          SizedBox(
              height: size.height * 0.6,
              width: double.infinity,
              child: PageView.builder(
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                controller: _pageController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Lottie.asset(list[index].path,
                          height: size.height * 0.45),
                      Text(list[index].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              fontSize: 20)),
                      const Spacer(),
                      SizedBox(
                        width: size.width * 0.8,
                        child: Text(list[index].subTitle,
                            style: const TextStyle(
                              letterSpacing: 1,
                              color: Colors.black54,
                            )),
                      )
                    ],
                  );
                },
              )),
          SizedBox(
            height: size.height * 0.02,
          ),
          Wrap(
            spacing: 8,
            children: List.generate(list.length, (ind) {
              return AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: 10,
                width: 15,
                decoration: BoxDecoration(
                    color: _currentPage == ind
                        ? Colors.blue
                        : const Color.fromARGB(255, 202, 199, 199),
                    borderRadius: BorderRadius.circular(size.width * 0.02)),
              );
            }),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          ElevatedButton(
              onPressed: () {
                if (_currentPage != list.length - 1) {
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linear);
                } else {
                  Get.off(() => const HomeScreen());
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  elevation: 0,
                  minimumSize: Size(size.width * 0.5, size.height * 0.07),
                  maximumSize: Size(size.width * 0.5, 100)),
              child: Text(
                _currentPage == list.length - 1 ? 'Proceed' : 'Next',
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.white),
              )),
          const Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}
