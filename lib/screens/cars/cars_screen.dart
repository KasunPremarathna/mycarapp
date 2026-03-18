import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/car_service.dart';
import '../../services/service_record_service.dart';
import '../service/add_service_screen.dart';
import '../service/service_history_screen.dart';
import '../reminder/set_reminder_screen.dart';
import 'add_car_screen.dart';
import '../../theme/app_theme.dart';

class CarsScreen extends StatelessWidget {
  final CarService carService;
  final ServiceRecordService serviceService;

  const CarsScreen({
    super.key,
    required this.carService,
    required this.serviceService,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'All Cars',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          AddCarScreen(carService: carService)),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Car'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<CarModel>>(
              stream: carService.getCars(),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final cars = snap.data ?? [];
                if (cars.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car,
                            size: 64, color: Color(0xFFD1D5DB)),
                        SizedBox(height: 16),
                        Text('No cars added yet',
                            style: TextStyle(
                                fontSize: 18, color: AppTheme.textSecondary)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (ctx, i) => _CarListTile(
                    car: cars[i],
                    carService: carService,
                    serviceService: serviceService,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CarListTile extends StatelessWidget {
  final CarModel car;
  final CarService carService;
  final ServiceRecordService serviceService;

  const _CarListTile({
    required this.car,
    required this.carService,
    required this.serviceService,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.directions_car, color: AppTheme.primaryColor),
        ),
        title: Text(car.carModel,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${car.carNumber} • ${car.carYear}'),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (action) {
            switch (action) {
              case 'history':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ServiceHistoryScreen(
                            car: car, serviceService: serviceService)));
                break;
              case 'add_service':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddServiceScreen(
                            car: car, serviceService: serviceService)));
                break;
              case 'reminder':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SetReminderScreen(car: car)));
                break;
              case 'edit':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddCarScreen(
                            carService: carService, existingCar: car)));
                break;
              case 'delete':
                carService.deleteCar(car.id);
                break;
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'history', child: Text('View History')),
            PopupMenuItem(value: 'add_service', child: Text('Add Service')),
            PopupMenuItem(value: 'reminder', child: Text('Set Reminder')),
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }
}
