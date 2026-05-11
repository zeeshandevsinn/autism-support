import 'package:flutter/material.dart';

class ParentCard extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback onTap;
  const ParentCard({super.key, required this.image, required this.onTap});
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: h * 0.2,
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.cyan,
            image: DecorationImage(image: image, fit: BoxFit.cover),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
