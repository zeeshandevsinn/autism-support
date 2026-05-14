import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/colors.dart';

class LearningCategory extends StatefulWidget {
  final Map<String, dynamic> action;

  const LearningCategory({super.key, required this.action});

  @override
  State<LearningCategory> createState() => _LearningCategoryState();
}

class _LearningCategoryState extends State<LearningCategory> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int? _playingIndex;

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
      }
      
      setState(() {
        _isPlaying = true;
        _playingIndex = index;
      });
      
      // Play the audio file
      await _audioPlayer.play(AssetSource(audioPath));
      
      // Wait for audio to complete
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
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not play audio: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic>? dataList = widget.action['data'];
    
    if (dataList == null || dataList.isEmpty) {
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
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                CustomAppbar(
                  title: widget.action['title']?.toString() ?? 'Learning',
                  route: '/learning',
                ),
                const Expanded(
                  child: Center(
                    child: Text('No data available'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(
                title: widget.action['title']?.toString() ?? 'Learning',
                route: '/learning',
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final item = dataList[index];
                    final isPlaying = _playingIndex == index;
                    
                    return GestureDetector(
                      onTap: () async {
                        final audioFile = item['audio']?.toString();
                        if (audioFile != null && audioFile.isNotEmpty) {
                          await _playAudio(audioFile, index);
                        } else {
                          print('No audio file for ${item['title']}');
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isPlaying 
                              ? childSecondaryColor.withOpacity(0.3)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: childPrimaryColor.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: isPlaying
                                ? childPrimaryColor
                                : childSecondaryColor.withOpacity(0.2),
                            width: isPlaying ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Padding(
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
                                  if (isPlaying)
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: childPrimaryColor.withOpacity(0.8),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                item['title']?.toString() ?? '',
                                style: TextStyle(
                                  color: isPlaying ? childPrimaryColor : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isPlaying)
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(childPrimaryColor),
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
        ),
      ),
    );
  }
}