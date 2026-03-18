import 'package:cloud_firestore/cloud_firestore.dart';

class FuelModel {
  final String id;
  final String carId;
  final String carModel;
  final double fuelLiters;
  final double cost;
  final DateTime createdAt;

  FuelModel({
    required this.id,
    required this.carId,
    required this.carModel,
    required this.fuelLiters,
    required this.cost,
    required this.createdAt,
  });

  factory FuelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FuelModel(
      id: doc.id,
      carId: data['carId'] ?? '',
      carModel: data['carModel'] ?? '',
      fuelLiters: (data['fuelLiters'] as num?)?.toDouble() ?? 0.0,
      cost: (data['cost'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'carId': carId,
        'carModel': carModel,
        'fuelLiters': fuelLiters,
        'cost': cost,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
