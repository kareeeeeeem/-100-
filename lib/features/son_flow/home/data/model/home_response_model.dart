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
        image: (json['image']?.toString() ?? '').trim(),
        link: (json['link']?.toString() ?? '').trim(),
      );
}

class CategoryModel {
  final String id, name;
  final String? icon;
  CategoryModel({required this.id, required this.name, this.icon});
  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: (json['id'] ?? 0).toString(),
        name: (json['name'] ?? '').trim(),
        icon: (json['icon']?.toString())?.trim(),
      );
}

class CourseModel {
  final int id;
  final String title;
  final String? thumbnail;
  final String duration;
  final InstructorModel? instructor;
  final PriceModel? price;
  final String? lessonsCount;
  final String? progressPercentage;
  final bool isFavorited;

  CourseModel({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.duration,
    this.instructor,
    this.price,
    this.lessonsCount,
    this.progressPercentage,
    this.isFavorited = false,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
        id: json['id'] ?? 0,
        title: (json['title'] ?? '').trim(),
        thumbnail: (json['thumbnail']?.toString())?.trim(),
        duration: json['duration'] is Map ? (json['duration']['value'] ?? '').toString().trim() : (json['duration'] ?? '').toString().trim(),
        instructor: json['instructor'] != null ? InstructorModel.fromJson(json['instructor']) : null,
        price: json['price'] != null ? PriceModel.fromJson(json['price']) : null,
        lessonsCount: json['lessons_count']?.toString().trim(),
        progressPercentage: json['progress_percentage']?.toString().trim(),
        isFavorited: json['is_favorited'] ?? false,
      );

  // Helper getters for compatibility with existing UI
  String get instructorName => instructor?.name ?? 'مدرب أكاديمية 100';
  String get priceLabel => price?.label ?? '';
  bool get isFree => price?.isFree ?? false;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'thumbnail': thumbnail,
    'duration': duration,
    'instructor': instructor?.toJson(),
    'price': price?.toJson(),
    'lessons_count': lessonsCount,
    'progress_percentage': progressPercentage,
    'is_favorited': isFavorited,
  };
}

class InstructorModel {
  final String name;
  final String? image;

  InstructorModel({required this.name, this.image});

  factory InstructorModel.fromJson(Map<String, dynamic> json) => InstructorModel(
    name: (json['name'] ?? '').trim(),
    image: (json['image']?.toString())?.trim(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'image': image,
  };
}

class PriceModel {
  final String value;
  final bool isFree;
  final String label;

  PriceModel({required this.value, required this.isFree, required this.label});

  factory PriceModel.fromJson(Map<String, dynamic> json) => PriceModel(
    value: json['value']?.toString() ?? '1',
    isFree: json['is_free'] ?? false,
    label: json['label'] is Map ? json['label']['value'] ?? '' : json['label'] ?? '', // Handle anyOf case in spec
  );

  Map<String, dynamic> toJson() => {
    'value': value,
    'is_free': isFree,
    'label': label,
  };
}