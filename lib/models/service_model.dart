import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  final String id;
  final String carId;
  final String carModel;
  final DateTime serviceDate;
  final String description;
  final double serviceCost;
  final DateTime? nextServiceDate;
  final DateTime createdAt;

  ServiceModel({
    required this.id,
    required this.carId,
    required this.carModel,
    required this.serviceDate,
    required this.description,
    required this.serviceCost,
    this.nextServiceDate,
    required this.createdAt,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      carId: data['carId'] ?? '',
      carModel: data['carModel'] ?? '',
      serviceDate:
          (data['serviceDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      description: data['description'] ?? '',
      serviceCost: (data['serviceCost'] as num?)?.toDouble() ?? 0.0,
      nextServiceDate:
          (data['nextServiceDate'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'carId': carId,
        'carModel': carModel,
        'serviceDate': Timestamp.fromDate(serviceDate),
        'description': description,
        'serviceCost': serviceCost,
        'nextServiceDate':
            nextServiceDate != null ? Timestamp.fromDate(nextServiceDate!) : null,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
