import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';
import 'auth_service.dart';

class CarService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _authService;

  CarService(this._authService);

  CollectionReference get _carsRef =>
      _db.collection('users').doc(_authService.userId).collection('cars');

  Stream<List<CarModel>> getCars() {
    return _carsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => CarModel.fromFirestore(d)).toList());
  }

  Future<void> addCar(CarModel car) async {
    await _carsRef.add(car.toMap());
  }

  Future<void> updateCar(CarModel car) async {
    await _carsRef.doc(car.id).update(car.toMap());
  }

  Future<void> deleteCar(String carId) async {
    await _carsRef.doc(carId).delete();
  }
}
