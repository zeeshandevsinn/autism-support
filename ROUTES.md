# 🛣️ App Routing Guide

This document outlines the navigation routes available in the Autism Support app. Navigation is handled via `onGenerateRoute` in `lib/main.dart`.

---

## 📍 Available Routes

| Route Name | Target Screen | Description |
| :--- | :--- | :--- |
| `/` | `SplashPage` | Initial entry point and splash animation. |
| `/home` | `HomeScreen` | Main home screen (Root after splash). |
| `/parent_dashboard` | `UserDashbarScreen` | Main dashboard for parents. |
| `/exercise_tracking` | `ExcerciseTracking` | Exercise tracking summary for parents. |
| `/child_dashboard` | `ChildDashboard` | Main dashboard for child users. |
| `/learning` | `LearningDashboard` | Dashboard for educational activities. |
| `/learning/category` | `LearningCategory` | Displays activities filtered by category (Requires `action` arguments). |
| `/exercise` | `ExerciseDashboard` | Dashboard for exercise-related activities. |
| `/signup` | `SignUpScreen` | User registration screen. |
| `/signin` | `LoginScreen` | User login screen. |
| `/emotion` | `MoodTrackingScreen` | Interface for child emotional regulation. |
| `/conversation` | `ConversationScreen` | Visual conversation cards for children. |
| `/family_members` | `FamilyMemberCards` | View family member cards (Child view). |
| `/parent/family_members` | `FamilyMembers` | Management interface for family members (Parent view). |
| `/exercise/drill` | `ExerciseDrillScreen` | Interactive exercise drill (Requires `drillData` arguments). |

---

## 🛠 Navigation Example

### Basic Navigation
```dart
Navigator.pushNamed(context, '/child_dashboard');
```

### Navigation with Arguments
For routes like `/learning/category` or `/exercise/drill`, ensure you pass the required data:

```dart
Navigator.pushNamed(
  context, 
  '/exercise/drill', 
  arguments: {
    'title': 'Stretching',
    'id': 'drill_01',
    // ... other drill data
  }
);
```

---

*Note: Any undefined route will safely fallback to the `SplashPage`.*
