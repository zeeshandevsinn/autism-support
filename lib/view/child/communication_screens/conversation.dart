import "package:autism_support/utils/app_text.dart";
import "package:autism_support/utils/colors.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_tts/flutter_tts.dart";

class Conversation extends StatefulWidget {
  final dynamic data;

  const Conversation({super.key, this.data});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  FlutterTts? _flutterTts;
  bool _isTtsInitialized = false;
  int? _speakingIndex;

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    try {
      _flutterTts = FlutterTts();
      await _flutterTts!.setLanguage(context.locale.languageCode == 'en' ? 'en' : 'ur');
      await _flutterTts!.setPitch(1.0);
      await _flutterTts!.setSpeechRate(0.5);
      setState(() {
        _isTtsInitialized = true;
      });
    } catch (e) {
      print("TTS Initialization Error: $e");
    }
  }

  Future<void> speak(String sentence, String languageCode, int index) async {
    if (!_isTtsInitialized || _flutterTts == null) {
      print("TTS not initialized");
      return;
    }
    
    try {
      setState(() {
        _speakingIndex = index;
      });
      
      await _flutterTts!.setLanguage(languageCode);
      await _flutterTts!.speak(sentence);
      
      // Add a delay to reset the speaking index
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _speakingIndex = null;
        });
      }
    } catch (e) {
      print("Speak Error: $e");
      setState(() {
        _speakingIndex = null;
      });
    }
  }

  @override
  void dispose() {
    _flutterTts?.stop();
    _flutterTts = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              childSecondaryColor,      // Soft Pink (#FDA4AF)
              childBgColor,             // Very Light Pink-White (#FEF2F2)
              Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Header Image Circle
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      childPrimaryColor,
                      childSecondaryColor,
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: childPrimaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage(widget.data['image'].toString()),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.chat_bubble_outline,
                          size: 50,
                          color: childPrimaryColor,
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Title
              Text(
                widget.data['title'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: childPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Subtitle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: childSecondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tr(AppText.conversation),
                  style: TextStyle(
                    color: childPrimaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Conversation List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: widget.data['data'].length,
                  itemBuilder: (BuildContext context, int index) {
                    final isSpeaking = _speakingIndex == index;
                    final sentence = widget.data['data'][index]['sentence'].toString();
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isSpeaking 
                            ? childSecondaryColor.withOpacity(0.3)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: childPrimaryColor.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(
                          color: isSpeaking
                              ? childPrimaryColor
                              : childSecondaryColor.withOpacity(0.2),
                          width: isSpeaking ? 1.5 : 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            if (sentence.isNotEmpty) {
                              String languageCode = context.locale.languageCode == 'en' ? 'en' : 'ur';
                              await speak(sentence, languageCode, index);
                            }
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Avatar with animation
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: isSpeaking
                                            ? [childPrimaryColor, childSecondaryColor]
                                            : [Colors.grey.shade300, Colors.grey.shade200],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isSpeaking ? Icons.play_arrow : Icons.person_outline,
                                      color: isSpeaking ? Colors.white : Colors.grey.shade600,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(width: 16),
                                
                                // Sentence Text
                                Expanded(
                                  child: Text(
                                    sentence,
                                    style: TextStyle(
                                      color: isSpeaking ? childPrimaryColor : Colors.black87,
                                      fontSize: 18,
                                      fontWeight: isSpeaking ? FontWeight.w600 : FontWeight.w500,
                                      height: 1.3,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                // Audio Icon
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSpeaking
                                        ? childPrimaryColor.withOpacity(0.1)
                                        : childSecondaryColor.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isSpeaking ? Icons.speaker : Icons.volume_up,
                                    color: isSpeaking ? childPrimaryColor : childSecondaryColor,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}