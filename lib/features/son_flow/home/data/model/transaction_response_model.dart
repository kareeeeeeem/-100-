class TransactionResponseModel {
  final bool status;
  final String message;
  final List<TransactionModel> data;

  TransactionResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) => TransactionResponseModel(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] is List 
            ? (json['data'] as List).map((x) => TransactionModel.fromJson(x)).toList()
            : [],
      );
}

class TransactionModel {
  final String id;
  final dynamic amount;
  final String type;
  final String description;
  final String paymentMethod;
  final String date;
  final String status;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.paymentMethod,
    required this.date,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id']?.toString() ?? '',
        amount: json['amount'],
        type: json['type']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        paymentMethod: json['payment_method']?.toString() ?? '',
        date: json['date']?.toString() ?? '',
        status: json['status']?.toString() ?? 'مكتملة',
      );
}
