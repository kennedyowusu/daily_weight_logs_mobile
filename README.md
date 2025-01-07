Weight Log Mobile App Documentation

## Weight Log Mobile App

This is the frontend of the Weight Log application, a mobile app built with Flutter. The app provides an intuitive interface for users to manage their health data and weight logs.

**Screen Shots**

## Weight Screens
![Home](/assets/images/screentshots/home.png)

![Add Weight](/assets/images/screentshots/add_weight.png)

![All Weight Logged](/assets/images/screentshots/all_log_weights.png)

![Weight Log Range](/assets/images/screentshots/week_long_weight.png)

## Height Screens
![Add Height](/assets/images/screentshots/add_height.png)

![Add Height Loading State](/assets/images/screentshots/adding_height.png)

![Select Goal](/assets/images/screentshots/select_goal.png)

# Authentication Screens
![Login](/assets/images/screentshots/login.png)

![Register](/assets/images/screentshots/registration.png)

![Forgot Password](/assets/images/screentshots/forget_password.png)


Features

User authentication (registration, login, logout).
Profile management.
Log and visualize weight changes over time.
Set and manage health goals.
View BMI and historical logs.
Responsive UI with a focus on user experience.

Requirements

Flutter SDK
Android Studio or Xcode for running the app on emulators or devices.

Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/kennedyowusu/daily_weight_logs_mobile
   cd weight-log-mobile
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up the API base URL:
   Update the `baseUrl` in `lib/common/constants/endpoints.dart` to point to your backend API.

4. Run the app:
   ```bash
   flutter run
   ```

Architecture

The app follows a feature-first approach, and Riverpod App Architecture with `Riverpod` for state management.

Folder Structure
**common**: Contains shared utilities, constants, and widgets.
**features**: Each feature (e.g., authentication, height logs) is self-contained with its own data, domain, application and presentation layers.
**router**: Manages app navigation.

State Management
The app uses `Riverpod` for managing state efficiently across the app.

Key Screens

**Login Screen**: Allows users to log in to their accounts.
**Height Log Screen**: Enables users to set height and weight goals.
**Weight Log Screen**: Displays weight logs with graphs and BMI visualization.
**Profile Screen**: Allows users to view and edit their profile details.

API Integration

The app interacts with the backend using the `APIService` class located in `lib/services/api_services.dart`. It handles authentication and secure storage of access tokens.

Testing

Run the tests using the Flutter test command:
flutter test

Build

To build the app for release:
Android: `flutter build apk`
iOS: `flutter build ios`

License

This project is licensed under the MIT License.

https://github.com/kennedyowusu/daily_weight_logs_mobile/blob/main/LICENSE

