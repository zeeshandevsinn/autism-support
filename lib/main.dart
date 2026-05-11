import 'package:autism_support/controller/provider/password_provider.dart';
import 'package:autism_support/controller/services/firebase_auth_provider.dart';
import 'package:autism_support/home_screen.dart';
import 'package:autism_support/splash.dart';
import 'package:autism_support/view/child/child_dashboard.dart';
import 'package:autism_support/view/child/communication_screens/conversation_cards.dart';
import 'package:autism_support/view/child/family_screens.dart/family_members.dart';
import 'package:autism_support/view/child/learning_screens/learning_category.dart';
import 'package:autism_support/view/parent/excercise_tracking.dart';
import 'package:autism_support/view/parent/family_members.dart';
import 'package:autism_support/view/parent/login_screen.dart';
import 'package:autism_support/view/parent/user_dashbar_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'view/child/emotional_regulation_screens/mood_selection.dart';
import 'view/child/exercise_screens/drill_screen.dart';
import 'view/child/exercise_screens/excercise_dashboard.dart';
import 'view/child/learning_screens/learning_dashboard.dart';
import 'view/parent/sign_up_screen.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(EasyLocalization(
      supportedLocales: [Locale('ur'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: Locale('ur'),
      // assetLoader: CodegenLoader(),
      child: const OverlaySupport.global(
        child: MyApp(),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PasswordProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseAuthProvider(),
        )
      ],
      child: SafeArea(
          child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(fontFamily: 'ubuntu'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const SplashPage());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            case '/parent_dashboard':
              return MaterialPageRoute(
                  builder: (_) => const UserDashbarScreen());
            case '/exercise_tracking':
              return MaterialPageRoute(
                  builder: (_) => const ExcerciseTracking());
            case '/child_dashboard':
              return MaterialPageRoute(builder: (_) => const ChildDashboard());
            case '/learning':
              return MaterialPageRoute(
                  builder: (_) => const LearningDashboard());
            case '/learning/category':
              final action = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (_) => LearningCategory(action: action),
              );
            case '/exercise':
              return MaterialPageRoute(
                  builder: (_) => const ExerciseDashboard());
            case '/signup':
              return MaterialPageRoute(builder: (_) => const SignUpScreen());
            case '/signin':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/emotion':
              return MaterialPageRoute(
                  builder: (_) => const MoodTrackingScreen());
            case '/conversation':
              return MaterialPageRoute(
                  builder: (_) => const ConversationScreen());
            case '/family_members':
              return MaterialPageRoute(
                  builder: (_) => const FamilyMemberCards());
            case '/parent/family_members':
              return MaterialPageRoute(builder: (_) => const FamilyMembers());
            case '/exercise/drill':
              final data = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                  builder: (_) => ExerciseDrillScreen(
                        drillData: data,
                      ));
            default:
              return MaterialPageRoute(
                builder: (_) => const SplashPage(),
              );
          }
        },
      )),
    );
  }
}
