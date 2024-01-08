import 'dart:io';
import 'package:ai_chat_bot/apis/apis.dart';
import 'package:ai_chat_bot/controller/chat_controller.dart';
import 'package:ai_chat_bot/helper/constants.dart';
import 'package:ai_chat_bot/model/consversaiton.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:lottie/lottie.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ChatController c;
  late SideMenuController _sideMenuController;

  @override
  void initState() {
    super.initState();

    _sideMenuController = SideMenuController();
    c = ChatController();
    c.isNewConservation = true.obs;
  }

  @override
  void dispose() {
    super.dispose();
    _sideMenuController.dispose();
    c.textController.dispose();
  }

  String? conversationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Chat With Ai',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w500, color: Colors.blue),
        ),
        centerTitle: true,
        leading: kIsWeb || !Platform.isAndroid && !Platform.isIOS
            ? IconButton(
                onPressed: () {
                  c.showSideMenu.value = !c.showSideMenu.value;
                },
                icon: const Icon(Icons.menu))
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
      ),
      drawer: kIsWeb || !Platform.isAndroid && !Platform.isIOS
          ? null
          : SafeArea(child: sideMenu()),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (kIsWeb || !Platform.isAndroid && !Platform.isIOS)
                    if (c.showSideMenu.value) sideMenu(),
                  Expanded(
                      child: ListView.builder(
                          controller: c.scrollController,
                          padding: EdgeInsets.only(
                              top: size.height * 0.03,
                              bottom: size.height * 0.03),
                          itemCount: c.chatList.length,
                          itemBuilder: (context, index) {
                            return MessageCard(
                              chatsJson: c.chatList[index],
                              isFirstTime: c.chatList.length - 1 == index,
                            );
                          })),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: c.textController,
                      onTapOutside: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      onFieldSubmitted: (value) {
                        c.askQuestion();
                        if (c.isNewConservation.value) {
                          c.isNewConservation.value =
                              !c.isNewConservation.value;
                        }
                      },
                      decoration: const InputDecoration(
                          hintText: 'Ask Me Anything ...',
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 27,
                    child: InkWell(
                        onTap: () {
                          c.askQuestion();
                          if (c.isNewConservation.value) {
                            c.isNewConservation.value =
                                !c.isNewConservation.value;
                          }
                        },
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.blueAccent,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer sideMenu() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Lottie.asset('assets/lottie/Animation - 1703671797376.json',
              alignment: Alignment.center, height: 100),
          ListTile(
            onTap: () {
              if (!c.isNewConservation.value) {
                c.isNewConservation.value = true;
              }
              c.chatList.clear();
              c.conversation.clear();
            },
            title: const Text('new chat'),
          ),
          StreamBuilder(
              stream: Firestore.getConversationTitle(),
              builder: (context, snapshots) {
                switch (snapshots.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshots.data?.docs;

                    if (data != null && data.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                shape: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onTap: () async {
                                  c.chatList.clear();
                                  conversationId = data[index].id;

                                  final conversation =
                                      await Firestore.getConversation(
                                          conversationId!);
                                  ShowConversations.fromjson(conversation!, c);
                                  if (c.isNewConservation.value) {
                                    c.isNewConservation.value =
                                        !c.isNewConservation.value;
                                  }
                                  if (!kIsWeb) {
                                    if (Platform.isAndroid || Platform.isIOS) {
                                      _scaffoldKey.currentState
                                          ?.closeEndDrawer();
                                    }
                                  }
                                },
                                title: Text(
                                  data[index].id,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }),
                      );
                    }
                }
                return const SizedBox();
              })
        ],
      ),
    );
  }
}

class MessageCard extends StatelessWidget {
  final bool isFirstTime;

  final Map<String, dynamic> chatsJson;
  const MessageCard(
      {super.key, required this.isFirstTime, required this.chatsJson});

  @override
  Widget build(BuildContext context) {
    final chat = JsontoChat(message: chatsJson);
    bool isBot = chat.role == 'model';
    Widget animatedText = isFirstTime
        ? AnimatedTextKit(
            totalRepeatCount: 1,
            animatedTexts: [
              TyperAnimatedText(chat.msg,
                  speed: const Duration(milliseconds: 0)),
            ],
          )
        : Text(chat.msg);

    return Align(
      alignment: isBot ? Alignment.topRight : Alignment.topLeft,
      child: Wrap(
        verticalDirection: VerticalDirection.up,
        children: [
          if (isBot)
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.03),
              child: Image.asset(
                'assets/icon/icon.png',
                height: size.height * 0.03,
              ),
            ),
          SizedBox(
            width: size.width * .03,
          ),
          chat.msg == 'loading'
              ? Lottie.asset('assets/lottie/Animation - 1703242753777.json',
                  height: size.height * 0.06)
              : Container(
                  constraints: BoxConstraints(maxWidth: size.width * 0.5),
                  margin: EdgeInsets.only(bottom: size.height * 0.01),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.height * 0.007),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Colors.black),
                      borderRadius: isBot
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15))
                          : const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(15))),
                  child: animatedText,
                ),
          SizedBox(
            width: size.width * .02,
          ),
          if (!isBot)
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.03),
              child: const Icon(Icons.person),
            ),
        ],
      ),
    );
  }
}
