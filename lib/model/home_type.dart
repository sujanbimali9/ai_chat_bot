import 'package:ai_chat_bot/helper/constants.dart';
import 'package:ai_chat_bot/pages/features/chatscreen_page.dart';
import 'package:ai_chat_bot/pages/features/image_generator_screen.dart';
import 'package:ai_chat_bot/pages/features/translator_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';

enum HomeType { aiChatbot, aiImage, aiTranslator }

extension MyHomeType on HomeType {
  String get title => switch (this) {
        HomeType.aiChatbot => 'Ai ChatBot',
        HomeType.aiImage => 'Ai Image Generator',
        HomeType.aiTranslator => 'Ai Translator',
      };
  String get path => switch (this) {
        HomeType.aiChatbot => 'assets/lottie/Animation - 170308403072.json',
        HomeType.aiImage => 'assets/lottie/Animation - 1703130150096.json',
        HomeType.aiTranslator => 'assets/lottie/Animation - 1703131953251.json',
      };
  bool get align => switch (this) {
        HomeType.aiChatbot => true,
        HomeType.aiImage => false,
        HomeType.aiTranslator => true,
      };

  double get height => switch (this) {
        HomeType.aiChatbot => size.height * 0.1,
        HomeType.aiImage => size.height * 0.1,
        HomeType.aiTranslator => size.height * 0.55,
      };
  VoidCallback get onPressed => switch (this) {
        HomeType.aiChatbot => () {
            Get.to(() => const ChatBotScreen());
          },
        HomeType.aiImage => () {
            Get.to(() => const ImageGeneratorScreen());
          },
        HomeType.aiTranslator => () {
            Get.to(() => const TranslateScreen());
          },
      };
}
