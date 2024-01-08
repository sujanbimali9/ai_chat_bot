import 'dart:developer';
import 'dart:io';
import 'package:ai_chat_bot/apis/apis.dart';
import 'package:ai_chat_bot/helper/constants.dart';
import 'package:ai_chat_bot/model/consversaiton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class ChatController extends GetxController {
  var textController = TextEditingController();
  var scrollController = ScrollController();
  var isNewConservation = true.obs;
  var conversation = <Map<String, dynamic>>[];
  var showSideMenu = kIsWeb
      ? true.obs
      : Platform.isAndroid
          ? false.obs
          : true.obs;
  var screenSize = size.width.obs;

  var chatList = <Map<String, dynamic>>[
    ChatTOJson(role: 'model', msg: 'Hello! How can I assist today').toJson()
  ].obs;

  Future<void> askQuestion() async {
    log(textController.text.trim());

    if (textController.text.trim().isNotEmpty) {
      chatList.add(ChatTOJson(msg: textController.text, role: 'user').toJson());
      conversation
          .add(ChatTOJson(msg: textController.text, role: 'user').toJson());
      scrollDown();
      chatList.add(ChatTOJson(msg: 'loading', role: 'model').toJson());
      textController.clear();
      try {
        String res =
            await APIs.getAnswer(conversation, isNewConservation.value);
        chatList.removeLast();
        conversation.add(ChatTOJson(msg: res, role: 'model').toJson());
        chatList.add(ChatTOJson(msg: res, role: 'model').toJson());
      } catch (e) {
        log('askQuestionE: $e');
      }
      scrollDown();
    }
  }

  void scrollDown() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50), curve: Curves.linear);
  }
}
