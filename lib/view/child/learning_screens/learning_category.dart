import 'package:autism_support/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LearningCategory extends StatefulWidget {
  final Map<String, dynamic> action;

  const LearningCategory({super.key, required this.action});

  @override
  State<LearningCategory> createState() => _LearningCategoryState();
}

class _LearningCategoryState extends State<LearningCategory> {
  FlutterTts flutterTts = FlutterTts();
  Future speak(sentence) async {
    await flutterTts.setLanguage('en');
    await flutterTts.setPitch(3);
    await flutterTts.speak(sentence);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppbar(
              title: widget.action['title'].toString(),
              route: '/learning',
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.action['data'].length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 7,
                      crossAxisSpacing: 7),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        print(widget.action['data'][index]['audio']);
                        if (widget.action['data'][index]['title'].isNotEmpty) {
                          // final player = AudioPlayer();
                          // await player.play(AssetSource(widget.action['data']
                          //         [index]['audio']
                          //     .toString()));
                          speak(widget.action['data'][index]['title']);
                        }
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Image.asset(
                              widget.action['data'][index]["image"].toString(),
                              height: 90,
                            ),
                            Text(
                              widget.action['data'][index]["title"].toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
