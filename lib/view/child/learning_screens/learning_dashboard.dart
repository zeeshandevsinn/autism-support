import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../utils/learning_data.dart';
import 'learning_category.dart'; // Make sure this file exists

class LearningDashboard extends StatefulWidget {
  const LearningDashboard({super.key});

  @override
  State<LearningDashboard> createState() => _LearningDashboardState();
}

class _LearningDashboardState extends State<LearningDashboard> {
  bool _isNavigating = false;

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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CustomAppbar(
                  title: tr(AppText.learning),
                  route: "/child_dashboard",
                ),
                Expanded(
                  child: _buildGridView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the number of columns based on screen width
        int crossAxisCount;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            childAspectRatio: 0.8,
          ),
          itemCount: learningData.length,
          itemBuilder: (BuildContext context, int index) {
            // Safety check for null or invalid data
            if (index >= learningData.length || learningData[index] == null) {
              return const SizedBox.shrink();
            }

            final learningItem = learningData[index];
            
            // Validate required fields
            if (learningItem['image'] == null || learningItem['title'] == null) {
              return const SizedBox.shrink();
            }

            return _buildCategoryCard(learningItem);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> learningItem) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: _isNavigating ? null : () => _navigateToCategory(learningItem),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    learningItem['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Flexible(
                flex: 1,
                child: Text(
                  learningItem["title"] ?? "Unknown",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: childPrimaryColor,
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
  }

  void _navigateToCategory(Map<String, dynamic> action) async {
    if (_isNavigating) return;
    
    setState(() {
      _isNavigating = true;
    });

    try {
      // Navigate to LearningCategory page
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LearningCategory(
            action: action,
          ),
        ),
      );
    } catch (e) {
      print("Navigation error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to open ${action['title']}. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }
}