import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/car_service.dart';
import '../../theme/app_theme.dart';

class AddCarScreen extends StatefulWidget {
  final CarService carService;
  final CarModel? existingCar;

  const AddCarScreen({
    super.key,
    required this.carService,
    this.existingCar,
  });

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _carNumberCtrl = TextEditingController();
  final _carModelCtrl = TextEditingController();
  final _carYearCtrl = TextEditingController();
  String _selectedCategory = 'Petrol';
  bool _isLoading = false;

  final List<String> _categories = ['Petrol', 'Electric', 'Hybrid', 'Diesel'];

  @override
  void initState() {
    super.initState();
    if (widget.existingCar != null) {
      _carNumberCtrl.text = widget.existingCar!.carNumber;
      _carModelCtrl.text = widget.existingCar!.carModel;
      _carYearCtrl.text = widget.existingCar!.carYear;
      _selectedCategory = widget.existingCar!.carCategory;
    }
  }

  @override
  void dispose() {
    _carNumberCtrl.dispose();
    _carModelCtrl.dispose();
    _carYearCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final car = CarModel(
      id: widget.existingCar?.id ?? '',
      carNumber: _carNumberCtrl.text.trim().toUpperCase(),
      carModel: _carModelCtrl.text.trim(),
      carYear: _carYearCtrl.text.trim(),
      carCategory: _selectedCategory,
      createdAt: widget.existingCar?.createdAt ?? DateTime.now(),
    );

    try {
      if (widget.existingCar != null) {
        await widget.carService.updateCar(car);
      } else {
        await widget.carService.addCar(car);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingCar != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Car' : 'Add New Car'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              _buildField(
                controller: _carNumberCtrl,
                label: 'Car Number *',
                hint: 'e.g. CAS-0000',
                icon: Icons.numbers,
                validator: (v) => v!.isEmpty ? 'Please enter car number' : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _carModelCtrl,
                label: 'Car Model *',
                hint: 'e.g. Toyota Corolla',
                icon: Icons.directions_car,
                validator: (v) => v!.isEmpty ? 'Please enter car model' : null,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _carYearCtrl,
                label: 'Car Year *',
                hint: 'e.g. 2022',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Please enter year';
                  if (int.tryParse(v) == null) return 'Enter a valid year';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Car Category',
                  prefixIcon: const Icon(Icons.local_gas_station,
                      color: AppTheme.primaryColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                ),
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v!),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(isEdit ? 'Update Car' : 'Add Car'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
      ),
    );
  }
}
