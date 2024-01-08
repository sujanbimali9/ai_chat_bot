import 'package:ai_chat_bot/controller/chat_controller.dart';

class ChatTOJson {
  late final String role;
  late final String msg;

  ChatTOJson({required this.role, required this.msg});

  Map<String, dynamic> toJson() {
    return {
      "role": role,
      "parts": [
        {
          "text": msg,
        }
      ]
    };
  }
}

class JsontoChat {
  final Map<String, dynamic> message;
  late String msg;
  late String role;
  JsontoChat({required this.message}) {
    msg = message['parts'][0]['text'];
    role = message['role'];
  }
}

class ShowConversations {
  static fromjson(Map<String, dynamic> json, ChatController controller) {
    json.forEach((key, value) {
      String userMessage = value['parts'][0]['text'] ?? '';
      String role = value['role'] ?? '';
      controller.chatList
          .add(ChatTOJson(role: role, msg: userMessage).toJson());
    });
  }
}
