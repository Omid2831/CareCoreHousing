// ignore: dangling_library_doc_comments, slash_for_doc_comments
/**
 * API endpoints used in the application
 * This file contains the API endpoints for the application.
 * These endpoints will be used to make API requests to the server.
 */

class Endpoints {
  // Base URL for Android emulator - use 10.0.2.2 to reach host localhost
  static const String baseUrl = 'http://10.0.2.2/api/v1';

  // Properties endpoints
  static const String properties = '/properties';
  static const String property = '/properties'; // + id
  static const String myProperties = '/my-properties';
  static String propertyById(int id) => '$property/$id';

  // Favorites endpoints
  static const String favorites = '/favorites';

  // Notifications endpoints
  static const String notifications = '/notifications';
  static const String unreadNotifications = '/notifications/unread';
  static const String markAsRead = '/notifications'; // + id + /read
  static const String markAllAsRead = '/notifications/read-all';
  static String markNotificationAsRead(int id) => '$markAsRead/$id/read';

  // Rental agreements endpoints
  static const String rentalAgreements = '/rental-agreements';
}
