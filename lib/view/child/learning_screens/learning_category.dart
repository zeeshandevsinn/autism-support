// learning_category_simple.dart - No TTS version
import 'package:flutter/material.dart';
import 'package:autism_support/components/custom_appbar.dart';
import 'package:autism_support/utils/colors.dart';

class LearningCategory extends StatelessWidget {
  final Map<String, dynamic> action;

  const LearningCategory({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    final List<dynamic>? dataList = action['data'];
    
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
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(action['title']?.toString() ?? 'Learning'),
              // backgroundColor: childSecondaryColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(child: Text('No data available')),
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
              childSecondaryColor,      // Soft Pink (#FDA4AF)
              childBgColor,             // Very Light Pink-White (#FEF2F2)
              Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(action['title']?.toString() ?? 'Learning'),
            backgroundColor: childSecondaryColor,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            elevation: 0,
          ),
          body: GridView.builder(
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
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Padding(
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
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        item['title']?.toString() ?? '',
                        style: TextStyle(
                          color: childPrimaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}