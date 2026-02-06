
class PrintLinksModel {
  final bool? status;
  final String? message;
  final PrintLinksData? data;

  PrintLinksModel({this.status, this.message, this.data});

  factory PrintLinksModel.fromJson(Map<String, dynamic> json) {
    return PrintLinksModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? PrintLinksData.fromJson(json['data']) : null,
    );
  }
}

class PrintLinksData {
  final String? withAnswersUrl;
  final String? withoutAnswersUrl;

  PrintLinksData({this.withAnswersUrl, this.withoutAnswersUrl});

  factory PrintLinksData.fromJson(Map<String, dynamic> json) {
    return PrintLinksData(
      withAnswersUrl: json['with_answers_url'],
      withoutAnswersUrl: json['without_answers_url'],
    );
  }
}
