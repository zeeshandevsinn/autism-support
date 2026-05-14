import "package:autism_support/utils/app_text.dart";
import "package:autism_support/utils/colors.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:audioplayers/audioplayers.dart";

class Conversation extends StatefulWidget {
  final dynamic data;

  const Conversation({super.key, this.data});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _playingIndex;
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String audioPath, int index) async {
    try {
      // Stop any currently playing audio
      if (_isPlaying) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _playingIndex = null;
        });
      }
      
      setState(() {
        _isPlaying = true;
        _playingIndex = index;
      });
      
      // Play the audio file
      await _audioPlayer.play(AssetSource(audioPath));
      
      // Listen for completion
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() {
            _isPlaying = false;
            _playingIndex = null;
          });
        }
      });
      
    } catch (e) {
      print("Error playing audio: $e");
      setState(() {
        _isPlaying = false;
        _playingIndex = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not play audio'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
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
              childSecondaryColor,
              childBgColor,
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
                    final isPlaying = _playingIndex == index;
                    final sentence = widget.data['data'][index]['sentence'].toString();
                    final audioFile = widget.data['data'][index]['audio'].toString();
                    
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isPlaying 
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
                          color: isPlaying
                              ? childPrimaryColor
                              : childSecondaryColor.withOpacity(0.2),
                          width: isPlaying ? 1.5 : 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            if (audioFile.isNotEmpty) {
                              await _playAudio(audioFile, index);
                            } else {
                              print('No audio file for: $sentence');
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
                                        colors: isPlaying
                                            ? [childPrimaryColor, childSecondaryColor]
                                            : [Colors.grey.shade300, Colors.grey.shade200],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isPlaying ? Icons.play_arrow : Icons.volume_up,
                                      color: isPlaying ? Colors.white : Colors.grey.shade600,
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
                                      color: isPlaying ? childPrimaryColor : Colors.black87,
                                      fontSize: 18,
                                      fontWeight: isPlaying ? FontWeight.w600 : FontWeight.w500,
                                      height: 1.3,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                
                                // Audio Indicator
                                if (isPlaying)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(childPrimaryColor),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: childSecondaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: childSecondaryColor,
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