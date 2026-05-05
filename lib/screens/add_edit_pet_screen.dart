import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/pet_provider.dart';
import '../models/pet.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';

class AddEditPetScreen extends StatefulWidget {
  final Pet? pet;
  
  const AddEditPetScreen({super.key, this.pet});

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  
  String _selectedType = AppConstants.petTypes.first;
  String? _photoPath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _ageController.text = widget.pet!.age.toString();
      _weightController.text = widget.pet!.weight.toString();
      _selectedType = widget.pet!.type;
      _photoPath = widget.pet!.photoPath;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _photoPath = pickedFile.path);
    }
  }

  String? _validateRequired(String? value, String field) {
    if (value == null || value.isEmpty) return '$field is required';
    return null;
  }

  String? _validateNumber(String? value, String field) {
    if (value == null || value.isEmpty) return '$field is required';
    if (double.tryParse(value) == null) return 'Please enter a valid number';
    return null;
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final provider = Provider.of<PetProvider>(context, listen: false);
    final newPet = Pet(
      id: widget.pet?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      type: _selectedType,
      age: int.parse(_ageController.text),
      weight: double.parse(_weightController.text),
    );

    if (widget.pet == null) {
      await provider.addPet(newPet);
    } else {
      await provider.updatePet(newPet);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Add Pet' : 'Edit Pet'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient1,
                    shape: BoxShape.circle,
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Center(
                    child: Text(
                      AppConstants.petTypeEmoji[_selectedType] ?? '🐾',
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              CustomTextField(
                controller: _nameController,
                label: 'Pet Name',
                icon: Icons.pets,
                validator: (v) => _validateRequired(v, 'Pet Name'),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Pet Type',
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: AppConstants.petTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _ageController,
                label: 'Age (years)',
                icon: Icons.cake_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => _validateNumber(v, 'Age'),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: _weightController,
                label: 'Weight (kg)',
                icon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => _validateNumber(v, 'Weight'),
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePet,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.pet == null ? 'Add Pet' : 'Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}