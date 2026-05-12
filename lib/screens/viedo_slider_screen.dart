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
      _controllers[_currentIndex].play(); // Automatically play the first video
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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
       backgroundColor: commonBgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(4, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.cyan),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: CarouselSlider.builder(
              options: CarouselOptions(
                height: isWeb
                    ? double.infinity
                    : (isPortrait ? 300 : double.infinity),
                aspectRatio: isWeb
                    ? 0.6
                    : (isPortrait
                        ? 16 / 9
                        : _controllers[_currentIndex].value.aspectRatio),
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
                return SizedBox(
                  height: 300,
                  child: AspectRatio(
                    aspectRatio: _controllers[index].value.aspectRatio,
                    child: VideoPlayer(_controllers[index]),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(4, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.cyan),
                child: IconButton(
                  onPressed: _navigateToPrevious,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(4, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.cyan),
                child: IconButton(
                  onPressed: _navigateToNext,
                  icon: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: videoUrls.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => setState(() {
                  _currentIndex = entry.key;
                  _onPageChanged(
                      _currentIndex, CarouselPageChangedReason.manual);
                }),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_currentIndex == entry.key ? 0.9 : 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
