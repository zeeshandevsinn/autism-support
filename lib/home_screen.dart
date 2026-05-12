// import 'package:autism_app/view/widgets/drawer_button.dart';
import 'package:autism_support/controller/services/base.dart';
import 'package:autism_support/utils/app_text.dart';
import 'package:autism_support/utils/colors.dart';
import 'package:autism_support/utils/toast/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = -1; // -1 means none selected
  bool isPressed = false;
  int counter = 5;
  @override
  void initState() {
    super.initState();
  }

  _showLanguagePopup() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                Icons.translate,
                color: parentPrimaryColor,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                tr(AppText.selectLanguage),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: parentPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageTile(
              flag: '🇺🇸',
              name: tr(AppText.english),
              locale: 'en',
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            _buildLanguageTile(
              flag: '🇵🇰',
              name: tr(AppText.urdu),
              locale: 'ur',
              onTap: () {
                context.setLocale(const Locale('ur'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              tr(AppText.cancel),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildLanguageTile({
  required String flag,
  required String name,
  required String locale,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: parentPrimaryColor),
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: commonBgColor,
      
      appBar: AppBar(
        backgroundColor: commonBgColor,
        title: IconButton(
            onPressed: _showLanguagePopup, icon: const Icon(Icons.menu_outlined))
        // Icon(Icons.menu_outlined)
        ,
        //  Row(
        //   children: [
        //     Text(
        //       tr(AppText.language),
        //       style: TextStyle(
        //           fontSize: 16,
        //           fontWeight: FontWeight.normal,
        //           overflow: TextOverflow.ellipsis,
        //           fontFamily: "Montserrat",
        //           color: TextGreyColor),
        //     ),
        //     SizedBox(
        //       width: 19,
        //     ),
        //     // Switch(
        //     //   value: context.locale.languageCode == 'ur',
        //     //   onChanged: (value) {
        //     //     context.setLocale(value ? Locale('ur') : Locale('en'));
        //     //   },
        //     //   activeColor: GoldColor,
        //     // ),
        //   ],
        // ),

        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Toggle buttons for Child and Caretaker
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Child toggle circle
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/child_dashboard");
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedIndex == 0
                              ? Colors.blue
                              : Colors.grey.shade300,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(4, 4),
                            ),
                          ],
                          border: Border.all(
                            color: selectedIndex == 0
                                ? Colors.blueAccent
                                : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/child.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tr(AppText.child),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 60),
                // Caretaker toggle circle
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (UserSession.getUID() != null) {
                          // for(int i=0; i<5; i++){
                          // }
                          setState(() {
                            counter--;
                            ToastUtil.showSuccessToast('${tr(AppText.click)}$counter${tr(AppText.timesToEnterParentMode)}'

                                // 'Click +'$counter'+ times to enter parent mode!'
                                );
                          });

                          if (counter == 0) {
                            counter = 5;
                            setState(() {
                              ToastUtil.showSuccessToast(
                                  tr(AppText.youreNowInParentMode)

                                  // "You're now in Parent Mode!"
                                  );
                            });
                            Navigator.pushNamed(context, "/parent_dashboard");
                          }
                        } else {
                          Navigator.pushNamed(context, "/signin");
                        }
                      },
                      // onTapDown: (_) => _onButtonTap(1),
                      // onTapUp: (_) {
                      //   _animationController.reverse();
                      // },
                      // onTapCancel: () {
                      //   _animationController.reverse();
                      // },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedIndex == 1
                              ? Colors.blue
                              : Colors.grey.shade300,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(4, 4),
                            ),
                          ],
                          border: Border.all(
                            color: selectedIndex == 1
                                ? Colors.blueAccent
                                : Colors.white,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/caretaker.jpeg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      tr(AppText.parent),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// // import 'package:autism_app/view/widgets/drawer_button.dart';
// import 'package:autism_support/controller/services/base.dart';
// import 'package:autism_support/utils/app_text.dart';
// import 'package:autism_support/utils/colors.dart';
// import 'package:autism_support/utils/toast/toast.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen>
//     with SingleTickerProviderStateMixin {
//   int selectedIndex = -1; // -1 means none selected
//   bool isPressed = false;
//   int counter = 5;
//   @override
//   void initState() {
//     super.initState();
//   }

//   void _showLanguagePopup() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(
//             tr(AppText.selectLanguage),
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: Text(tr(AppText.enterAge)),
//                 onTap: () {
//                   context.setLocale(Locale('en'));
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: Text(tr(AppText.urdu)),
//                 onTap: () {
//                   context.setLocale(Locale('ur'));
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text(tr(AppText.cancel)),
//             ),
//           ],
//         );
//       },
//     );
//   }
   
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Text(
//               tr(AppText.language),
//               style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.normal,
//                   overflow: TextOverflow.ellipsis,
//                   fontFamily: "Montserrat",
//                   color: Colors.amber),
//             ),
//             const SizedBox(width: 19),
//             IconButton(
//               icon: const Icon(Icons.language, color: Colors.green),
//               onPressed: _showLanguagePopup,
//             ),
//           ],
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             // Toggle buttons for Child and Caretaker
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Child toggle circle
//                 Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pushNamed(context, "/child_dashboard");
//                       },
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: selectedIndex == 0
//                               ? Colors.blue
//                               : Colors.grey.shade300,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.5),
//                               spreadRadius: 2,
//                               blurRadius: 10,
//                               offset: const Offset(4, 4),
//                             ),
//                           ],
//                           border: Border.all(
//                             color: selectedIndex == 0
//                                 ? Colors.blueAccent
//                                 : Colors.white,
//                             width: 2,
//                           ),
//                         ),
//                         child: ClipOval(
//                           child: Image.asset(
//                             'assets/child.jpeg',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       tr(AppText.child),
//                       style: const TextStyle(
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 60),
//                 // Caretaker toggle circle
//                 Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         if (UserSession.getUID() != null) {
//                           setState(() {
//                             counter--;
//                             ToastUtil.showSuccessToast(
//                                 tr(AppText.click) +
//                                     '$counter' +
//                                     tr(AppText.timesToEnterParentMode));
//                           });

//                           if (counter == 0) {
//                             counter = 5;
//                             setState(() {
//                               ToastUtil.showSuccessToast(
//                                   tr(AppText.youreNowInParentMode));
//                             });
//                             Navigator.pushNamed(context, "/parent_dashboard");
//                           }
//                         } else {
//                           Navigator.pushNamed(context, "/signin");
//                         }
//                       },
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: selectedIndex == 1
//                               ? Colors.blue
//                               : Colors.grey.shade300,
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.5),
//                               spreadRadius: 2,
//                               blurRadius: 10,
//                               offset: const Offset(4, 4),
//                             ),
//                           ],
//                           border: Border.all(
//                             color: selectedIndex == 1
//                                 ? Colors.blueAccent
//                                 : Colors.white,
//                             width: 2,
//                           ),
//                         ),
//                         child: ClipOval(
//                           child: Image.asset(
//                             'assets/caretaker.jpeg',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       tr(AppText.parent),
//                       style: const TextStyle(
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
