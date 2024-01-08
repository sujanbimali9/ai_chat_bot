import 'package:ai_chat_bot/apis/apis.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textController = TextEditingController();
  var status = Status.none.obs;
  var url = ''.obs;

  Future<void> getImage() async {
    if (textController.text.trim().isNotEmpty) {
      status.value = Status.loading;
      url.value = await APIs.generateImage(textController.text);
      if (url.isNotEmpty) {
        status.value = Status.complete;
      }
    }
  }
}
