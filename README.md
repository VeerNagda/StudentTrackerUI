# ui

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the [online documentation](https://docs.flutter.dev/), which offers tutorials, samples, guidance on mobile development, and a full API reference.

For Google Map:

1. Visit the Google Cloud Platform and activate Maps SDK for Android and iOS.
2. For Android, add meta-data to manifest.xml (`<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR_API_KEY" />`).
3. For iOS, in appDelegate (`GMSServices.provideAPIKey("YOUR_API_KEY")`).
4. For web, in index.html (`<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY"></script>`).
5. Add dependencies:
    - `google_places_flutter: ^2.0.6`
    - `google_maps_flutter: ^2.5.1`
    - `google_maps_flutter_web: ^0.5.4+3`

Dart Naming Convention to be used:
- Use snake_case (lowercase with underscores) for libraries, directories, packages, and source files.
- Start private variable names with underscores.
- Use lowerCamelCase for constants, variables, parameters, and named parameters.
- Use UpperCamelCase for classes, types, extension names, and enums.
- Always use clear and meaningful names to improve code readability.

### Directory Structure:

- **lib/**: This is where the main code of your Flutter application resides.
    - **main.dart**: The entry point of your Flutter application.
    - **screens/**: Contains all the UI screens or pages of your application.
    - **widgets/**: Contains reusable UI components/widgets used across multiple screens.
    - **models/**: Contains data models used within your application.
    - **services/**: Contains classes responsible for handling business logic, data fetching, and interacting with external services.
    - **utils/**: Contains utility classes, helper functions, or constants used throughout the application.
- **assets/**: Stores static assets like images, fonts, etc., that are used in the application.
- **test/**: Contains unit, widget, and integration tests for your application.
- **android/** and **ios/**: Contains platform-specific configuration and native code for Android and iOS respectively.
- **pubspec.yaml**: YAML file containing dependencies, assets, and other metadata for the Flutter project.

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