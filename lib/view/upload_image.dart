// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'dart:ui' as ui;
// import 'icon_preview.dart';

// class UploadProfilePicture extends StatefulWidget {
//   @override
//   _UploadProfilePictureState createState() => _UploadProfilePictureState();
// }

// class _UploadProfilePictureState extends State<UploadProfilePicture> {
//   File? _image;

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);

//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload Profile Picture')),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           if (_image != null) Image.file(_image!, height: 200, width: 200),
//           ElevatedButton(
//             onPressed: _pickImage,
//             child: Text('Upload Picture'),
//           ),
//           if (_image != null)
//             ElevatedButton(
//               onPressed: () async {
//                 final iconFile = await _generateIcon(_image!, 'Ubaid');
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => IconPreview(iconFile: iconFile)),
//                 );
//               },
//               child: Text('Generate Icon'),
//             ),
//         ],
//       ),
//     );
//   }

//   Future<File> _generateIcon(File image, String userName) async {
//     final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(pictureRecorder);
//     final Paint paint = Paint();

//     // Draw the profile picture
//     final ui.Image profileImage = await _loadImage(image);
//     paintImage(
//       canvas: canvas,
//       rect: Rect.fromLTWH(0, 0, 512, 512),
//       image: profileImage,
//       fit: BoxFit.cover,
//     );

//     // Overlay with app theme color
//     paint.color = Colors.blue.withOpacity(0.5); // Adjust the color as needed
//     canvas.drawRect(Rect.fromLTWH(0, 0, 512, 512), paint);

//     // Add user name
//     final textPainter = TextPainter(
//       text: TextSpan(
//         text: userName,
//         style: TextStyle(
//             color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),
//       ),
//       textAlign: TextAlign.center,
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout(minWidth: 0, maxWidth: 512);
//     textPainter.paint(canvas, Offset(0, 512 - textPainter.height));

//     final ui.Image finalImage =
//         await pictureRecorder.endRecording().toImage(512, 512);
//     final ByteData? byteData =
//         await finalImage.toByteData(format: ui.ImageByteFormat.png);
//     final Uint8List imageData = byteData!.buffer.asUint8List();

//     final directory = await getApplicationDocumentsDirectory();
//     final File file = File('${directory.path}/personalized_icon.png');
//     await file.writeAsBytes(imageData);

//     return file;
//   }

//   Future<ui.Image> _loadImage(File file) async {
//     final data = await file.readAsBytes();
//     return decodeImageFromList(data);
//   }
// }
