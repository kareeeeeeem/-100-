class AppConstants {
  static const String en = 'en';
  static const String ar = 'ar';
  static const String somethingWentWrong = 'حدث خطأ ما من فضلك حاول لاحقا';
  static const String thisTookSoLongPleaseTryAgain =
      'هذا يستغرق وقت طويل من فضلك حاول لاحقا';
  static const String noInternetConnection = 'لا يوجد اتصال بالإنترنت';
  static const String requestWasCancelled = 'تم إلغاء الطلب';
  static final emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
}
