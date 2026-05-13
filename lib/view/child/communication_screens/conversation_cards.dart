import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/view/child/communication_screens/conversation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../utils/conversation.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  // Different gradient colors for each card
  final List<List<Color>> _cardGradients = const [
    [Color(0xFF667EEA), Color(0xFF764BA2)],
    [Color(0xFFF093FB), Color(0xFFF5576C)],
    [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    [Color(0xFF43E97B), Color(0xFF38F9D7)],
    [Color(0xFFFA709A), Color(0xFFFEE140)],
    [Color(0xFF30CFD0), Color(0xFF330867)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              childSecondaryColor.withOpacity(0.3),
              childBgColor,
              Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppbar(
                title: tr(AppText.conversation),
                route: '/child_dashboard',
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: conversationData.length,
                  itemBuilder: (context, index) {
                    final conversation = conversationData[index];
                    final gradientColors = _cardGradients[index % _cardGradients.length];
                    
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Conversation(
                              data: conversation,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'conversation_$index',
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: gradientColors,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColors.first.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 90,
                                width: 90,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getIconForIndex(index),
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  conversation['title']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
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

  IconData _getIconForIndex(int index) {
    switch (index % 6) {
      case 0:
        return Icons.chat_bubble_outline;
      case 1:
        return Icons.record_voice_over;
      case 2:
        return Icons.people_outline;
      case 3:
        return Icons.face_retouching_natural;
      case 4:
        return Icons.message_outlined;
      default:
        return Icons.chat_outlined;
    }
  }
}