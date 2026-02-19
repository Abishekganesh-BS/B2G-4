# Maternal Health Platform — Frontend

The Flutter mobile application for the Maternal & Infant Health Platform. Provides a modern, responsive UI for health tracking, AI-powered recommendations, and secure authentication.

## Tech Stack

- **Framework:** Flutter (SDK ≥ 3.3.0)
- **State Management:** Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **Navigation:** GoRouter
- **HTTP Client:** Dio
- **Typography:** Google Fonts

## Features

| Screen         | Route         | Description                              |
|----------------|---------------|------------------------------------------|
| Login          | `/login`      | Email + password authentication          |
| Register       | `/register`   | New user registration                    |
| Home           | `/`           | Dashboard with health module navigation  |
| Metabolic      | `/metabolic`  | Glucose & metabolic health tracking      |
| Lifestyle      | `/lifestyle`  | Lifestyle and wellness insights          |
| Mental Health  | `/mental`     | Mental well-being screening              |
| Pediatric      | `/pediatric`  | Infant health monitoring                 |

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run in development (with backend running)
flutter run

# Build Android APK
flutter build apk
```

> **Note:** The backend server and PostgreSQL database must be running for API features to work. See the [root README](../README.md) for full setup instructions.

## Project Structure

```
lib/
├── features/
│   ├── auth/           # Login & Register screens
│   ├── home/           # Home dashboard
│   ├── metabolic/      # Metabolic health screen
│   ├── lifestyle/      # Lifestyle screen
│   ├── mental/         # Mental well-being screen
│   └── pediatric/      # Pediatric care screen
├── services/           # API service layer (auth_service.dart)
├── main.dart           # App entry point (ProviderScope + MaternalHealthApp)
├── router.dart         # GoRouter route definitions
└── theme.dart          # App-wide theme configuration
```

## Testing

```bash
# Run widget tests
flutter test
```
