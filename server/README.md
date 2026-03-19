# Server (Laravel Backend)

This folder contains the backend API for CareCoreHousing.

## Prerequisites

- Docker Desktop (recommended for this project)
- WSL2 on Windows
- Composer (only needed for non-Docker local run)

## Recommended Run Method (Sail)

From `server/`:

1. Install dependencies:

```bash
composer install
```

1. Create environment file:

```bash
cp .env.example .env
```

1. Start containers:

```bash
./vendor/bin/sail up -d
```

1. Generate app key:

```bash
./vendor/bin/sail artisan key:generate
```

1. Prepare database with seed data:

```bash
./vendor/bin/sail artisan migrate:fresh --seed
```

Backend API is then reachable from your host machine through Sail's exposed app port.

## If `db:seed` Fails with Duplicate Email

Run this command instead:

```bash
./vendor/bin/sail artisan migrate:fresh --seed
```

This resets tables and reseeds cleanly.

## Stop Backend

```bash
./vendor/bin/sail down
```

## Non-Docker Local Run (Optional)

Use this path only if Sail is not being used:

1. Configure `.env` for local MySQL.

1. Run:

```bash
php artisan key:generate
php artisan migrate --seed
php artisan serve
```

## API Notes

- Current API version prefix: `/api/v1`
- Properties routes are defined in `routes/api.php`
- Main listing endpoint used by client:

```http
GET /api/v1/properties
```

## Development Tips

- If client is Android emulator, use `10.0.2.2` in Flutter API base URL to reach host backend.
- Keep endpoint paths centralized in client `lib/api/endpoints.dart`.
