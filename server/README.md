# **Server (Laravel Backend)**

This folder contains the backend API for **CareCoreHousing**, built with **Laravel**. It handles all core functionality such as authentication, property management, and communication with other services (AI recommendations, chat, etc.).

---

## **Features**

* **User Authentication**

  * Register, login, password reset
  * JWT or Laravel Fortify for secure API access

* **Property Management**

  * CRUD operations for property listings
  * Filter and search properties by location, price, type, etc.
  * Manage user favorites

* **Tenant ↔ Landlord Interaction**

  * Submit rental applications
  * Send inquiries (message relay goes through Node.js WebSocket server)

* **Integration with AI Service(Optional)**

  * Calls Python AI microservice for property recommendations

* **Admin Features (Optional)**

  * Moderate listings and users
  * Generate reports

---

## **Folder Structure**

```
server/
├── app/           # Main application code (Models, Controllers, Services)
├── routes/        # API route definitions
├── database/      # Migrations, seeds, factories
├── config/        # Configuration files
├── tests/         # Unit and feature tests
└── ...
```

---

## **Setup Instructions**

1. **Clone the repo**

```bash
git clone <repo-url>
cd CareCoreHousing/server
```

2. **Install dependencies**

```bash
composer install
```

3. **Configure environment**

```bash
cp .env.example .env
# Update DB, API keys, and other settings
```

4. **Generate app key**

```bash
php artisan key:generate
```

5. **Run migrations**

```bash
php artisan migrate
```

6. **Start the server**

```bash
php artisan serve
```

> The server will run on `http://localhost:8000` by default.

---

## **API Documentation**

* All endpoints are prefixed with `/api/`
* Example endpoints:

  * `POST /api/register` – Create a new user
  * `POST /api/login` – Authenticate user
  * `GET /api/properties` – List properties
  * `POST /api/properties` – Add a property
* Use **Postman or Swagger** for testing and API docs.

---

## **Notes**

* Laravel communicates with:

  * **Python AI service** for recommendations
  * **Node.js WebSocket server** for real-time chat
* Use **separate `.env` for each environment** (dev, staging, production)
* Make sure the database is shared properly if using multiple services