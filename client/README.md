# Client (Flutter App)

This folder contains the Flutter mobile client for CareCoreHousing.

## Run

1. Install dependencies:

```bash
flutter pub get
```

1. Run on Android emulator:

```bash
flutter run -d emulator-5554
```

## API Separation of Concerns

- `lib/api/endpoints.dart`: all API route constants and dynamic path builders.
- `lib/api/dio_client_api.dart`: one shared Dio instance and global request config.
- `lib/api/property_api.dart`: property-specific API methods and JSON mapping.

UI screens should call API service classes (like `PropertyApi`) instead of calling Dio directly.

## Base URL Notes

- Android emulator host access: `10.0.2.2`
- API version prefix used by backend: `/api/v1`
