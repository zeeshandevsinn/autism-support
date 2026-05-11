// import 'dart:developer';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';


// import '../utils/learning_data.dart';

// class CustomCarousel extends StatefulWidget {
//   var obj;
//    CustomCarousel({super.key, this.obj});

//   @override
//   State<CustomCarousel> createState() => _CustomCarouselState();
// }

// class _CustomCarouselState extends State<CustomCarousel> {
//   int currentIndex = 0;
//   final CarouselSliderController _carouselController = CarouselSliderController();
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       // DeviceOrientation.portraitUp,
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.landscapeLeft,
//     ]);
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
// print(learningData[widget.obj]['data']);
//     Size size = MediaQuery.of(context).size;
//     final bool isPortrait =
//         MediaQuery.of(context).orientation == Orientation.landscape;
//     final double carouselHeight = isPortrait ? 200.0 : 300.0;

//     return Row(
//       children: [
//         IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
//           onPressed: () {
//             try {
//               _carouselController.previousPage(
//                 curve: Curves.easeInOut,
//                 duration: const Duration(milliseconds: 300),
//               );
//             } catch (e) {
//               debugger();
//               print(e);
//             }
//           },
//         ),
//         Expanded(
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: [
//               // Expanded(child: Container()),
//               Container(
//                 height:
//                     size.height - (MediaQuery.of(context).size.height * 0.3),
//                 width: size.width,
//                 padding: const EdgeInsets.all(8.0),
//                 child: CarouselSlider(
//                   items: [
//                     for (var item in widget.obj)
//                       _buildCarouselItem("${item['slider_video']}")
//                   ],
//                   options: CarouselOptions(
//                     // height: carouselHeight,

//                     autoPlay: true,
//                     aspectRatio: isPortrait ? 2.0 : 16.9,
//                     autoPlayCurve: Curves.fastOutSlowIn,
//                     enableInfiniteScroll: false,
//                     autoPlayAnimationDuration: const Duration(milliseconds: 800),
//                     viewportFraction: 1,
//                     enlargeCenterPage: true,
//                     onPageChanged: (index, reason) {
//                       setState(() {
//                         currentIndex = index;
//                       });
//                     },
//                   ),
//                   carouselController: _carouselController,
//                 ),
//               ),

//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: List.generate(
//                   5, // Number of dots
//                   (index) => Container(
//                     width: 8.0,
//                     height: 8.0,
//                     margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: currentIndex == index ? Colors.blue : Colors.grey,
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.arrow_forward, color: Colors.black, size: 30),
//           onPressed: () {
//             _carouselController.nextPage(
//               curve: Curves.easeInOut,
//               duration: const Duration(milliseconds: 300),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildCarouselItem(String imagePath) {
//     return Container(
//       // height: MediaQuery.of(context).size.height *0.8,
//       // width: MediaQuery.of(context).size.width *0.8,
//       margin: const EdgeInsets.all(6.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//         border: Border.all(color: Colors.white, width: 2),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.5),
//         //     spreadRadius: 2,
//         //     blurRadius: 3,
//         //     offset: Offset(0, 3),
//         //   ),
//         // ],
//         image: DecorationImage(
//           image: AssetImage(imagePath),
//           fit: BoxFit.contain,
//         ),
//       ),
//     );
//   }
// }
