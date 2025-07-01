# kappes_office

A Multi-Vendor E-Commerce App built with Flutter

## Overview
This project is a multi-vendor e-commerce application designed for both buyers and sellers. It features user authentication, product browsing, cart management, order processing, and more. The app is built using Flutter and supports Android, iOS, Web, Windows, macOS, and Linux platforms.

## Features
- User registration, login, and email verification
- OTP-based authentication
- Product listing and search
- Category and store browsing
- Cart and checkout functionality
- Order management
- Profile management
- Multi-language support (English, French)
- Responsive UI for mobile and desktop

## Project Structure
```
lib/
  app/
    constants/         # App-wide constants (icons, images, URLs)
    data/              # Data layer (network, local storage)
    dev_data/          # Development mock data
    localization/      # Language and translation files
    modules/           # Feature modules (auth, home, cart, etc.)
    routes/            # App routing
    themes/            # Theme and style definitions
    utils/             # Utility functions
    widgets/           # Reusable widgets
  main.dart            # App entry point
assets/                # Images, icons, fonts
android/, ios/, web/, windows/, macos/, linux/  # Platform-specific code
```


## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart
- Android Studio / Xcode / VS Code
- Git

### Installation
```sh
git clone https://github.com/Atik-hridoy/kappes_office.git
cd kappes_office
flutter pub get
flutter run


API Configuration
Update the API base URL in lib/app/data/netwok/verify_signup_service.dart and other network files as needed.

Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

License
This project is licensed under the MIT License.
