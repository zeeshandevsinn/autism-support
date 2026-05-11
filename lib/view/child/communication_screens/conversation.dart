// import "package:audioplayers/audioplayers.dart";
// import "package:autism_support/utils/app_text.dart";
// import "package:easy_localization/easy_localization.dart";
// import "package:flutter/material.dart";
// import "package:flutter_tts/flutter_tts.dart";

// class Conversation extends StatefulWidget {
//   var data;
//   Conversation({super.key, this.data});

//   @override
//   State<Conversation> createState() => _ConversationState();
// }

// FlutterTts flutterTts = FlutterTts();
// Future speak(sentence) async {
//   await flutterTts.setLanguage('en');
//   await flutterTts.setPitch(3);
//   await flutterTts.speak(sentence);
// }

// class _ConversationState extends State<Conversation> {
//   @override
//   Widget build(BuildContext context) {
//     widget.data;
//     return Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 20,
//           ),
//           Image(
//             image: AssetImage(widget.data['image'].toString()),
//             height: 100,
//             width: 100,
//           ),
//           Text(
//             widget.data['title'],
//             style: const TextStyle(
//               fontSize: 40,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             tr(AppText.conversation)
//             // " Conversation"
//             ,
//             style: TextStyle(
//               color: Colors.grey,
//               fontSize: 17,
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: widget.data['data'].length,
//               itemBuilder: (BuildContext context, int index) {
//                 return InkWell(
//                   onTap: () async {
//                     print(widget.data['data'][index]['audio']);
//                     if (
//                         // widget.data['data'][index]['audio'].isNotEmpty
//                         widget.data['data'][index]['sentence'].isNotEmpty) {
//                       speak(widget.data['data'][index]['sentence']);
//                       // final player = AudioPlayer();
//                       // await player.play(AssetSource(
//                       //     widget.data['data'][index]['audio'].toString()));
//                       // await player.play(AssetSource('assets/tuesday.mp3'));
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     child: Row(
//                       children: [
//                         Image(
//                           image: AssetImage(widget.data['image'].toString()),
//                           height: 50,
//                           width: 50,
//                         ),
//                         const SizedBox(
//                           width: 20,
//                         ),
//                         Expanded(
//                           child: Text(
//                             overflow: TextOverflow.ellipsis,
//                             widget.data['data'][index]['sentence'].toString(),
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import "package:autism_support/utils/app_text.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_tts/flutter_tts.dart";

class Conversation extends StatefulWidget {
  final dynamic data;

  const Conversation({super.key, this.data});

  @override
  State<Conversation> createState() => _ConversationState();
}

FlutterTts flutterTts = FlutterTts();
Future speak(String sentence, String languageCode) async {
  await flutterTts.setLanguage(languageCode);
  await flutterTts.setPitch(1.0);
  await flutterTts.speak(sentence);
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Image(
            image: AssetImage(widget.data['image'].toString()),
            height: 100,
            width: 100,
          ),
          Text(
            widget.data['title'],
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            tr(AppText.conversation),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.data['data'].length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    print(widget.data['data'][index]['audio']);
                    if (widget.data['data'][index]['sentence'].isNotEmpty) {
                      String languageCode =
                          context.locale.languageCode == 'en' ? 'en' : 'ur';
                      speak(
                          widget.data['data'][index]['sentence'], languageCode);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage(widget.data['image'].toString()),
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            widget.data['data'][index]['sentence'].toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
