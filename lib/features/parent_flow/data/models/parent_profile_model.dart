class ParentProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;

  ParentProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
  });

  factory ParentProfileModel.fromJson(Map<String, dynamic> json) {
    return ParentProfileModel(
      id: json['id'].toString(), // Convert to string safe
      name: (json['name']?.toString() ?? '').trim(),
      email: (json['email']?.toString() ?? '').trim(),
      phone: (json['phone']?.toString() ?? '').trim(),
      image: (json['image']?.toString())?.trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
    };
  }
}
