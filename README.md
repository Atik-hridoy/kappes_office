# Kappes Office Flutter App

Kappes Office is a modular, scalable Flutter application designed for office management, e-commerce, and user engagement. The app leverages GetX for state management and routing, and is structured for maintainability and extensibility.

## Features
- User authentication (login, signup, password reset, OTP verification)
- Profile management
- Product browsing by category, store, province, and territory
- Shopping cart and order management
- Deals, offers, and reviews
- Notifications and messaging
- Company and store details
- Onboarding and splash screens
- Error handling screens
- Theming and localization support

## Project Structure

```
lib/
  main.dart                # App entry point
  app/
    constants/             # App-wide constants (icons, images, URLs)
    data/
      local/               # Local data sources/services
      netwok/              # Network/API services
    dev_data/              # Development/test data
    localization/          # Localization and translations
    modules/               # Feature modules (see below)
    routes/                # App routing and navigation
    themes/                # App themes and styles
    utils/                 # Utility functions/helpers
    widgets/               # Shared widgets
assets/
  app_logo/                # App logos
  dev_icons/               # Category and feature icons
  dev_images/              # Product, banner, and province images
  fonts/                   # Custom fonts
  icons/, images/          # Additional assets
```

### Key Modules (lib/app/modules)
- **auth/**: Authentication (bindings, controllers, views, widgets)
- **home/**: Home dashboard and main navigation
- **profile/**: User profile management
- **my_cart/**: Shopping cart functionality
- **my_orders/**: Order history and details
- **category/**: Product categories
- **product_details/**: Product detail views
- **deals_and_offers/**: Promotions and deals
- **reviews/**: Product and store reviews
- **messages/**: Messaging and notifications
- **notification/**: Push and in-app notifications
- **onboarding/**: Onboarding screens
- **splash/**: Splash screen
- **company_details/**: Company information
- **store/**: Store listings and details
- **shop_by_province/**, **shop_by_store/**, **shop_by_territory/**: Region/store-based shopping
- **saved/**: Saved/favorite items
- **trades_services/**: Trades and services listings
- **error_screens/**: Error and fallback screens
- **bottom_nav/**: Bottom navigation bar

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK
- Android Studio or VS Code (recommended)

### Installation
1. Clone the repository:
   ```sh
   git clone <repository-url>
   cd kappes_office
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## Dependencies
- [Flutter](https://flutter.dev/)
- [GetX](https://pub.dev/packages/get)
- [Other dependencies as listed in pubspec.yaml]

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
## Snap Shots

<img src="https://github.com/user-attachments/assets/93798154-eccb-4d2d-92cb-43252a84f83a" width="300"/>
<img src="https://github.com/user-attachments/assets/51b38684-f870-4d12-afa5-2f1c1060c168" width="300"/>
<img src="https://github.com/user-attachments/assets/7aa00e50-6767-481a-bffe-38ee91d72978" width="300"/>
<img src="https://github.com/user-attachments/assets/0208c80e-f073-448d-9d17-41eeda5df515" width="300"/>
<img width="281" height="652" alt="Screenshot 2025-07-18 161811" src="https://github.com/user-attachments/assets/0695ee59-e06c-42d1-ae46-d924502c6f98" />

<img width="282" height="622" alt="Screenshot 2025-07-18 162248" src="https://github.com/user-attachments/assets/d6f0d09a-ad7a-4921-a001-4104cea326f6" />


## License
[MIT](LICENSE)
