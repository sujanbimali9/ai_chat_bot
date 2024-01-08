import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:ai_chat_bot/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart';

class APIs {
  // static Future<String> getAnswer(String question) async {
  //   try {
  //     final res =
  //         await post(Uri.parse('https://api.openai.com/v1/chat/completions'),
  //             headers: {
  //               HttpHeaders.contentTypeHeader: 'application/json',
  //               HttpHeaders.authorizationHeader: 'Bearer $apiKeys'
  //             },
  //             body: jsonEncode({
  //               "model": "gpt-3.5-turbo",
  //               "max_tokens": 2000,
  //               "temperature": 0,
  //               "messages": [
  //                 {"role": "user", "content": 'question'},
  //               ]
  //             }));

  //     final data = jsonDecode(res.body);
  //     log(data['choices'][0]['message']['content']);
  //     return data['choices'][0]['message']['content'];
  //   } catch (e) {
  //     log('getAnswerE: $e');
  //     return 'Something went wrong (Try again in sometime)';
  //   }
  // }

  static Future<String> getAnswer(List conversation, bool isNew) async {
    try {
      final res = await post(
          Uri.parse(
              'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyBBofIqEoLbBJLE-U47bdodb7ORJLX6Ci4'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: jsonEncode({
            "contents": [conversation]
          }));

      final data = jsonDecode(res.body);
      if (isNew) {
        Firestore.firestore
            .collection('Conversation')
            .doc(conversation[0]['parts'][0]['text'])
            .set({
          DateTime.now().microsecondsSinceEpoch.toString(): conversation.last
        });
        Firestore.firestore
            .collection('Conversation')
            .doc(conversation[0]['parts'][0]['text'])
            .update({
          DateTime.now().microsecondsSinceEpoch.toString(): data['candidates']
              [0]['content']
        });
      } else {
        Firestore.firestore
            .collection('Conversation')
            .doc(conversation[0]['parts'][0]['text'])
            .update({
          DateTime.now().microsecondsSinceEpoch.toString(): conversation.last
        });
        Firestore.firestore
            .collection('Conversation')
            .doc(conversation[0]['parts'][0]['text'])
            .update({
          DateTime.now().microsecondsSinceEpoch.toString(): data['candidates']
              [0]['content']
        });
      }

      log(data['candidates'][0]['content']['parts'][0]['text']);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } catch (e) {
      log('getAnswerE: $e');
      return 'Something went wrong (Try again in sometime)';
    }
  }

  static Future<String> generateImage(String imageDetail) async {
    try {
      final image = await post(
          Uri.parse('https://api.openai.com/v1/images/generations'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $apiKeys'
          },
          body: jsonEncode({
            "model": "dall-e-2",
            "prompt": imageDetail,
            "n": 1,
            "size": "1024x1024"
          }));

      final data = jsonDecode(image.body);

      log(data['data'][0]['url']);
      return data['data'][0]['url'];
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  static Future<void> sendAudio(path) async {
    var request = MultipartRequest(
        'POST', Uri.parse('https://api.openai.com/v1/audio/transcriptions'))
      ..headers['Authorization'] = 'Bearer $apiKeys'
      ..files.add(await MultipartFile.fromPath(
        'file',
        path,
        contentType:
            MediaType('audio', 'm4a'), // Adjust content type accordingly
      ))
      ..fields['model'] = 'whisper-1'
      ..fields['response_format'] = 'text';
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Success: ${await response.stream.bytesToString()}');
      } else {
        print('Failed with status ${response.statusCode}');
        print('Body: ${await response.stream.bytesToString()}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}

class Firestore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getConversationTitle() {
    return firestore.collection('Conversation').snapshots();
  }

  static Future<Map<String, dynamic>?> getConversation(String id) async {
    final data = await firestore.collection('Conversation').doc(id).get();

    if (data.exists && data.data() != null) {
      final sortedMessages = data.data()!.keys.toList()
        ..sort((a, b) => a.compareTo(b));
      final orderedConversationData = Map.fromEntries(sortedMessages
          .map((timestamp) => MapEntry(timestamp, data.data()![timestamp])));
      return orderedConversationData;
    }
    return {
      'role': 'model',
      'parts': [
        {'text': 'an error occures'}
      ]
    };
  }
}
