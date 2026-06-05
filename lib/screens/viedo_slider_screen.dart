import 'package:autism_support/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';

class VideoSliderScreen extends StatefulWidget {
  const VideoSliderScreen({super.key});

  @override
  State<VideoSliderScreen> createState() => _VideoSliderScreenState();
}

class _VideoSliderScreenState extends State<VideoSliderScreen> {
  final List<String> videoUrls = [
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4"
  ];

  final List<VideoPlayerController> _controllers = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    for (var url in videoUrls) {
      final controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {});
        });
      _controllers.add(controller);
    }
    if (_controllers.isNotEmpty) {
      _controllers[_currentIndex].play();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
      for (var i = 0; i < _controllers.length; i++) {
        if (i == index) {
          _controllers[i].play();
        } else {
          _controllers[i].pause();
        }
      }
    });
  }

  void _navigateToPrevious() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _onPageChanged(_currentIndex, CarouselPageChangedReason.manual);
    }
  }

  void _navigateToNext() {
    if (_currentIndex < videoUrls.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _onPageChanged(_currentIndex, CarouselPageChangedReason.manual);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              commonBgColor,
              Colors.white,
              parentSecondaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Custom App Bar with Back Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: parentPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: parentPrimaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Video Resources",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: parentPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              
              // Header Section
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [parentPrimaryColor, parentSecondaryColor],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: parentPrimaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.video_library,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Educational Videos",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: parentSecondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Video ${_currentIndex + 1} of ${videoUrls.length}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: parentPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Video Player with Card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: parentPrimaryColor.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        height: double.infinity,
                        aspectRatio: isWeb ? 0.6 : (isPortrait ? 16 / 9 : _controllers[_currentIndex].value.aspectRatio),
                        viewportFraction: 1.0,
                        autoPlay: false,
                        enableInfiniteScroll: false,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: _onPageChanged,
                        initialPage: _currentIndex,
                        enlargeCenterPage: true,
                      ),
                      itemCount: videoUrls.length,
                      itemBuilder: (context, index, realIndex) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _controllers[index].value.aspectRatio,
                              child: VideoPlayer(_controllers[index]),
                            ),
                            // Play/Pause Overlay (optional)
                            if (!_controllers[index].value.isPlaying)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_controllers[index].value.isPlaying) {
                                      _controllers[index].pause();
                                    } else {
                                      _controllers[index].play();
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _controllers[index].value.isPlaying 
                                        ? Icons.pause 
                                        : Icons.play_arrow,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Navigation Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous Button
                  GestureDetector(
                    onTap: _navigateToPrevious,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [parentPrimaryColor, parentSecondaryColor],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: parentPrimaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 30),
                  
                  // Next Button
                  GestureDetector(
                    onTap: _navigateToNext,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [parentPrimaryColor, parentSecondaryColor],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: parentPrimaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: videoUrls.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => setState(() {
                      _currentIndex = entry.key;
                      _onPageChanged(_currentIndex, CarouselPageChangedReason.manual);
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: _currentIndex == entry.key ? 20.0 : 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentIndex == entry.key
                            ? parentPrimaryColor
                            : parentPrimaryColor.withOpacity(0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}