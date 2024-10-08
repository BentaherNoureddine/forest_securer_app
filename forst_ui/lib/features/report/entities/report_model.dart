import 'package:equatable/equatable.dart';

import 'category_model.dart';

class Report extends Equatable {
  final int id;

  final String description;

  final Category category;

  final String reporterId;

  final String? photo;

  final String address;

  final String title;

  final String lng;

  final String lat;

  final DateTime createdAt;

  const Report(
      {required this.id,
      required this.createdAt,
      required this.category,
      required this.description,
      required this.lng,
      required this.lat,
      required this.photo,
      required this.title,
      required this.address,
      required this.reporterId});

  @override
  List<Object?> get props =>
      [id, description, lng, lat, photo, reporterId, address, title, category];

  static Report fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['createdAt'] as String);
    final categoryString = json['category'] as String;
    final category =
        Category.values.firstWhere((c) => c.name == categoryString);

    return Report(
        id: json['id'] as int,
        createdAt: createdAt,
        description: json['description'] as String,
        category: category,
        lat: json['lat'] as String,
        lng: json['lng'] as String,
        title: json['title'] as String,
        address: json['address'] as String,
        photo: json['imagePath'],
        reporterId: json['reporterId']);
  }
}
