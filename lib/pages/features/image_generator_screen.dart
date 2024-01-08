import 'package:ai_chat_bot/controller/image_controller.dart';
import 'package:ai_chat_bot/helper/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ImageGeneratorScreen extends StatefulWidget {
  const ImageGeneratorScreen({super.key});

  @override
  State<ImageGeneratorScreen> createState() => _ImageGeneratorScreenState();
}

final c = Get.put(ImageController());

class _ImageGeneratorScreenState extends State<ImageGeneratorScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Ai Image Generator',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              alignment: Alignment.center,
              child: TextField(
                textAlign: TextAlign.center,
                controller: c.textController,
                onSubmitted: (value) {
                  c.getImage();
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    hintMaxLines: 2,
                    alignLabelWithHint: true,
                    hintText:
                        'Imagine something  wonderful & Innovate\n Type here & i will create for you '),
              ),
            ),
            Expanded(
                child: Obx(() => Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.02),
                    child: _image()))),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(bottom: size.height * .05),
                child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(size.width * 0.4, size.height * 0.06),
                        maximumSize:
                            Size(size.width * 0.5, size.height * 0.06)),
                    onPressed: () {
                      c.getImage();
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text('create')),
              ),
            )
          ],
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.download),
        ),
      ),
    );
  }

  Widget _image() => switch (c.status.value) {
        Status.none => Lottie.asset(
            'assets/lottie/Animation - 1703130150096.json',
            height: size.height * 0.25),
        Status.loading => Lottie.asset(
            'assets/lottie/Animation - 1703238263484.json',
            height: size.height * 0.25),
        Status.complete => CachedNetworkImage(
            imageUrl: c.url.value,
            placeholder: (context, url) => Lottie.asset(
                'assets/lottie/Animation - 1703238263484.json',
                fit: BoxFit.contain,
                height: size.height * 0.25,
                width: size.width * 0.8),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
      };
}
