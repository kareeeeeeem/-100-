class FavoriteToggleModel {
  final bool status;
  final String message;
  final bool isFavorited;

  FavoriteToggleModel({required this.status, required this.message, required this.isFavorited});

  factory FavoriteToggleModel.fromJson(Map<String, dynamic> json) {
    return FavoriteToggleModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      isFavorited: json['data']['is_favorited'] ?? false,
    );
  }
}