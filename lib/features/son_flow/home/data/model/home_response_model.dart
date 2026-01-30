class HomeResponseModel {
  final bool status;
  final String message;
  final HomeData data;

  HomeResponseModel({required this.status, required this.message, required this.data});

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) => HomeResponseModel(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: HomeData.fromJson(json['data'] ?? {}),
      );
}
class HomeData {
  final List<SliderModel> slider;
  final List<CategoryModel> categories;
  final List<CourseModel> featuredCourses;
  final List<CourseModel> upcomingCourses;

  HomeData({
    required this.slider, 
    required this.categories, 
    required this.featuredCourses,
    required this.upcomingCourses,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        // استخدمت ?? [] لضمان أنه في حالة عدم وجود المفتاح لا يعطي Null
        slider: List<SliderModel>.from((json['slider'] ?? []).map((x) => SliderModel.fromJson(x))),
        categories: List<CategoryModel>.from((json['categories'] ?? []).map((x) => CategoryModel.fromJson(x))),
        featuredCourses: List<CourseModel>.from((json['featured_courses'] ?? []).map((x) => CourseModel.fromJson(x))),
        upcomingCourses: List<CourseModel>.from((json['upcoming_courses'] ?? []).map((x) => CourseModel.fromJson(x))),
      );
}
class SliderModel {
  final String image, link;
  SliderModel({required this.image, required this.link});
  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        image: json['image'] ?? '',
        link: json['link'] ?? '',
      );
}

class CategoryModel {
  final String id, name;
  final String? icon;
  CategoryModel({required this.id, required this.name, this.icon});
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'].toString(),
        name: json['name'] ?? '',
        icon: json['icon'],
      );
}

class CourseModel {
  final String id, title, thumbnail, duration, instructorName;
  final String priceLabel;
  final bool isFree;

  CourseModel({
    required this.id, required this.title, required this.thumbnail,
    required this.duration, required this.instructorName,
    required this.priceLabel, required this.isFree,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'].toString(),
        title: json['title'] ?? '',
        thumbnail: json['thumbnail'] ?? '',
        duration: json['duration'] ?? '',
        instructorName: json['instructor']?['name'] ?? 'مدرب أكاديمية 100',
        priceLabel: json['price']?['label'] ?? '',
        isFree: json['price']?['is_free'] ?? false,
      );
}