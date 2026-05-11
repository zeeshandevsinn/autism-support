# Contributing to Autism Support

Thank you for your interest in contributing to the Autism Support app! We welcome contributions from developers, designers, and subject matter experts in the field of autism support.

---

## 🚀 How to Contribute

### 1. Reporting Bugs
- Use the **GitHub Issues** tab to report bugs.
- Provide a clear description of the issue and steps to reproduce it.
- Include information about your device and Flutter version (`flutter doctor`).

### 2. Suggesting Features
- Open an issue with the tag `enhancement`.
- Describe why the feature would be beneficial for the autism community.
- Provide any UI mockups or design ideas if possible.

### 3. Pull Requests
1. **Fork** the repository.
2. Create a new **branch** for your feature or fix.
3. Ensure your code follows the [Flutter Style Guide](https://dart.dev/guides/language/effective-dart/style).
4. Run `flutter test` to ensure no regressions.
5. Submit a **Pull Request** with a detailed description of your changes.

---

## 🛠 Development Guidelines

### State Management
- We use `Provider` for global state management.
- Keep business logic in the `controller/` directory.
- Avoid placing logic directly in the `build` methods of widgets.

### Internationalization
- Use `easy_localization` for all user-facing strings.
- Add new translations to `assets/translations/en.json` and `ur.json`.
- Do not hardcode strings in the UI.

### Coding Standards
- Use `camelCase` for variables and functions.
- Use `PascalCase` for classes.
- Ensure all new components are documented with comments.

---

## 💬 Community & Support

If you have any questions or need guidance, feel free to reach out via the issues tab or join our community discussions.

---

*Together, we can make a difference.*
