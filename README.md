# 🧩 Autism Support App

A comprehensive, multi-platform Flutter application designed to empower individuals on the autism spectrum and support their caregivers. This app provides tools for communication, learning, emotional regulation, and daily activity tracking.

---

## 🚀 Key Features

### 👨‍👩‍👧 Parent & Caretaker Tools
- **User Dashboard**: Overview of child's progress and quick access to management tools.
- **Exercise Tracking**: Monitor daily physical and developmental exercises.
- **Family Management**: Add and organize family members to build a support network.
- **Service Locator**: Connect with professional caretakers and autism-specific services.

### 🧒 Child-Centric Features
- **Communication Cards**: Use visual aids and conversation cards to facilitate expression.
- **Learning Dashboard**: Interactive modules categorized by skill level (Learning Category).
- **Emotional Regulation**: A dedicated mood tracking interface to help identify and manage feelings.
- **Interactive Exercises**: Engaging drills with video and audio support to guide the child.

### 🛠 Technical Highlights
- **Multi-lingual Support**: Full support for **English** and **Urdu** using `easy_localization`.
- **Text-to-Speech (TTS)**: Integrated `flutter_tts` for vocalizing communication cards.
- **Media Integration**: Support for video players, audio players, and image uploading.
- **Firebase Backend**: Secure authentication and real-time data sync using Firestore.
- **Global State Management**: Efficient UI updates driven by `Provider`.

---

## 🛠 Tech Stack

| Category | Technology |
| :--- | :--- |
| **Framework** | [Flutter 3.x](https://flutter.dev) |
| **Language** | [Dart](https://dart.dev) |
| **Backend** | [Firebase](https://firebase.google.com) (Auth, Firestore) |
| **State Management** | [Provider](https://pub.dev/packages/provider) |
| **Localization** | [Easy Localization](https://pub.dev/packages/easy_localization) |
| **UI/UX** | [Material Design](https://m3.material.io) & [Carousel Slider](https://pub.dev/packages/carousel_slider) |

---

## 📦 Getting Started

### Prerequisites
- Flutter SDK (>= 3.5.0)
- Android Studio / VS Code
- Firebase Project Setup

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/ubaid9029/autism-support.git
   cd autism-support
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration:**
   - Place your `google-services.json` in `android/app/`
   - Place your `GoogleService-Info.plist` in `ios/Runner/`
   - Ensure `lib/firebase_options.dart` is correctly configured (generated via FlutterFire CLI).

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```bash
lib/
├── components/     # Reusable UI widgets
├── controller/     # Business logic & Providers
├── screens/        # Feature-specific screens (Caretaker, Services)
├── view/           # Main UI screens (Parent/Child split)
│   ├── child/      # Emotional regulation, Learning, Exercise
│   └── parent/     # Dashboards, Tracking, Auth
├── utils/          # Constants, formatting, and helper themes
└── main.dart       # App entry point & Routing
```

---

## 🌍 Localization

To add or update translations, modify the files in `assets/translations/`:
- `en.json` (English)
- `ur.json` (Urdu)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

*Made with ❤️ for the Autism Community.*
