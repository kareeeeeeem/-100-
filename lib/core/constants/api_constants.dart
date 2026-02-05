class ApiConstants {
  static const String baseUrl = 'https://100-academy.com/api/$_apiVersion/';
  static const String _apiVersion = 'v1';
  static const String imageBaseUrl = 'https://100-academy.com/storage';
  
  static const Duration connectTimeout = Duration(seconds: 45);
  static const Duration receiveTimeout = Duration(seconds: 45);
  static const Duration sendTimeout = Duration(seconds: 45);
  
  static const String requiresAuthKey = 'requiresAuthKey';
  static const String authRefreshToken = ''; 
  
  // Auth & General
  static const String login = 'login';
  static const String socialLogin = 'login/social';
  static const String register = 'register';
  static const String logout = 'logout';
  static const String deleteAccount = 'delete-account';
  
  // Home & Courses
  static const String home = 'home';
  static const String categories = 'categories';
  static const String courses = 'courses';
  static String courseDetails(int id) => 'courses/$id';
  static const String myCourses = 'my-courses';
  static const String transactions = 'transactions';
  static const String checkout = 'checkout';
  static const String paymentCheckout = 'payment/checkout';
  
  // Profile
  static const String profile = 'profile';
  static const String updateProfile = 'profile/update'; // POST
  static const String changePassword = 'profile/change-password';
  
  // Notifications
  static const String notifications = 'notifications';
  static String markAsRead(int id) => 'notifications/$id/mark-as-read';
  
  // Instructor
  static String instructorProfile(String id) => 'instructors/$id';

  // Live Sessions
  static const String liveSessions = 'live-sessions';
  static String sectionLiveSessions(String sectionId) => 'sections/$sectionId/live-sessions';
  static String joinLiveSession(String id) => 'live-sessions/$id/join';
  
  // Community & Favorites
  static String courseComments(int id) => 'courses/$id/comments';
  static const String postComment = 'comments';

  // Dashboard
  static const String dashboardStats = 'dashboard/stats';

  // Parent Flow Endpoints
  static const String parentProfile = 'v1/mobile-parent/profile';
  static const String parentChildren = 'v1/mobile-parent/children';
  static const String parentPayments = 'v1/mobile-parent/payments';
  static const String parentCourses = 'v1/mobile-parent/courses';
  static String childDetails(int id) => 'v1/mobile-parent/children/$id';
  static String childExamResults(int id) => 'v1/mobile-parent/children/$id/exam-results';

  // Exams
  static const String examsList = 'exams';
  static String sectionExams(String sectionId) => 'sections/$sectionId/exams';
  static String examDetails(String id) => 'exams/$id';
  static String submitExam(String id) => 'exams/$id/submit';
  static String examResults(String id) => 'exams/results/$id';
}