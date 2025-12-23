/// Firebase configuration for the Assets Dashboard
/// 
/// This class contains the Firebase project configuration
/// obtained from Firebase Console.
class FirebaseConfig {
  // Private constructor to prevent instantiation
  FirebaseConfig._();

  /// Firebase project configuration
  static const Map<String, String> firebaseConfig = {
    'apiKey': 'AIzaSyCkDcoZrVK-8b-gG4z0kXq6NTl1Wpd3V38',
    'authDomain': 'assets-dashborad.firebaseapp.com',
    'projectId': 'assets-dashborad',
    'storageBucket': 'assets-dashborad.firebasestorage.app',
    'messagingSenderId': '492738784178',
    'appId': '1:492738784178:web:450572cd6ddca566a812ab',
    'measurementId': 'G-JDXFRBK6P6',
  };

  /// Get API Key
  static String get apiKey => firebaseConfig['apiKey']!;

  /// Get Auth Domain
  static String get authDomain => firebaseConfig['authDomain']!;

  /// Get Project ID
  static String get projectId => firebaseConfig['projectId']!;

  /// Get Storage Bucket
  static String get storageBucket => firebaseConfig['storageBucket']!;

  /// Get Messaging Sender ID
  static String get messagingSenderId => firebaseConfig['messagingSenderId']!;

  /// Get App ID
  static String get appId => firebaseConfig['appId']!;

  /// Get Measurement ID
  static String get measurementId => firebaseConfig['measurementId']!;
}
