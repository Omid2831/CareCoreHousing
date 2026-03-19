# API Layer Guide

This folder is the single place for backend communication.

## Files

- `endpoints.dart`
  - Stores route constants and dynamic path builders.
  - Example: `Endpoints.properties`, `Endpoints.propertyById(id)`.

- `dio_client_api.dart`
  - Stores one shared Dio client with base URL, headers, and timeouts.

- `property_api.dart`
  - Stores property domain API calls.
  - Converts raw responses into strongly typed `Property` models.

## Rule

Do not call `Dio()` directly from screens, widgets, or providers.
Always call feature API classes (for example `PropertyApi`) so networking and mapping stay centralized.
