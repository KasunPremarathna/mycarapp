import 'package:cloud_firestore/cloud_firestore.dart';

class CarModel {
  final String id;
  final String carNumber;
  final String carModel;
  final String carYear;
  final String carCategory;
  final DateTime createdAt;

  CarModel({
    required this.id,
    required this.carNumber,
    required this.carModel,
    required this.carYear,
    required this.carCategory,
    required this.createdAt,
  });

  factory CarModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CarModel(
      id: doc.id,
      carNumber: data['carNumber'] ?? '',
      carModel: data['carModel'] ?? '',
      carYear: data['carYear'] ?? '',
      carCategory: data['carCategory'] ?? 'Petrol',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  Map<String, dynamic> toMap() => {
        'carNumber': carNumber,
        'carModel': carModel,
        'carYear': carYear,
        'carCategory': carCategory,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
