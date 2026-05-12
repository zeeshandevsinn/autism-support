import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LearningCategory extends StatefulWidget {
  final Map<String, dynamic> action;

  const LearningCategory({super.key, required this.action});

  @override
  State<LearningCategory> createState() => _LearningCategoryState();
}

class _LearningCategoryState extends State<LearningCategory> {
  late FlutterTts flutterTts;
  bool isTtsInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    try {
      flutterTts = FlutterTts();
      await flutterTts.setLanguage('en');
      await flutterTts.setPitch(1.0); // Changed from 3.0 to 1.0
      await flutterTts.setSpeechRate(0.5);
      setState(() {
        isTtsInitialized = true;
      });
    } catch (e) {
      print("TTS Initialization Error: $e");
      setState(() {
        isTtsInitialized = false;
      });
    }
  }

  Future<void> speak(String sentence) async {
    if (!isTtsInitialized) {
      print("TTS not initialized yet");
      return;
    }
    try {
      if (sentence.isNotEmpty) {
        await flutterTts.speak(sentence);
      }
    } catch (e) {
      print("Speak Error: $e");
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Add null check for data
    final List<dynamic>? dataList = widget.action['data'];
    if (dataList == null || dataList.isEmpty) {
      return SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              CustomAppbar(
                title: widget.action['title']?.toString() ?? 'Learning',
                route: '/learning',
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: childBgColor,
        body: Column(
          children: [
            CustomAppbar(
              title: widget.action['title']?.toString() ?? 'Learning',
              route: '/learning',
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final item = dataList[index];
                    return InkWell(
                      onTap: () async {
                        try {
                          final title = item['title']?.toString() ?? '';
                          print('Tapped on: $title');
                          if (title.isNotEmpty) {
                            await speak(title);
                          }
                        } catch (e) {
                          print('Tap Error: $e');
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  item['image']?.toString() ?? '',
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                item['title']?.toString() ?? '',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}