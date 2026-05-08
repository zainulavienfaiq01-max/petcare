import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import '../providers/schedule_provider.dart';
import '../services/smart_schedule_service.dart';
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

  // Smart scheduling fields
  TimeOfDay? _feedingTime;
  DateTime? _vaccinationDate;
  int _groomingIntervalDays = 0;
  DateTime? _doctorCheckDate;
  bool _enableAutoSchedule = true;

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _ageController.text = widget.pet!.age.toString();
      _weightController.text = widget.pet!.weight.toString();
      _selectedType = widget.pet!.type;
      _photoPath = widget.pet!.photoPath;
      if (widget.pet!.feedingTimeMinutes != null) {
        _feedingTime = TimeOfDay(
          hour: widget.pet!.feedingHour,
          minute: widget.pet!.feedingMinute,
        );
      }
      _vaccinationDate = widget.pet!.vaccinationDate;
      _groomingIntervalDays = widget.pet!.groomingIntervalDays ?? 0;
      _doctorCheckDate = widget.pet!.doctorCheckDate;
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

  Future<void> _selectFeedingTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _feedingTime ?? const TimeOfDay(hour: 8, minute: 0),
    );
    if (time != null) setState(() => _feedingTime = time);
  }

  Future<void> _selectVaccinationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _vaccinationDate ?? DateTime.now().add(const Duration(days: 14)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _vaccinationDate = date);
  }

  Future<void> _selectDoctorDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _doctorCheckDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _doctorCheckDate = date);
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    
    final isNewPet = widget.pet == null;
    
    final newPet = Pet(
      id: widget.pet?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      type: _selectedType,
      age: int.parse(_ageController.text),
      weight: double.parse(_weightController.text),
      photoPath: _photoPath,
      feedingTimeMinutes: _feedingTime != null
          ? _feedingTime!.hour * 60 + _feedingTime!.minute
          : null,
      vaccinationDate: _vaccinationDate,
      groomingIntervalDays: _groomingIntervalDays > 0 ? _groomingIntervalDays : null,
      doctorCheckDate: _doctorCheckDate,
    );

    if (isNewPet) {
      await petProvider.addPet(newPet);
      
      // Auto-generate smart schedules for new pets
      if (_enableAutoSchedule) {
        final schedules = SmartScheduleService.generateSchedules(newPet);
        for (final schedule in schedules) {
          await scheduleProvider.addSchedule(schedule);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🎉 ${newPet.name} added! ${schedules.length} care schedules auto-generated.',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      }
    } else {
      await petProvider.updatePet(newPet);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pet photo placeholder
              Center(
                child: GestureDetector(
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
              ),
              const SizedBox(height: 24),
              
              // Basic info section
              Text('Basic Information', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              CustomTextField(
                controller: _nameController,
                label: 'Pet Name',
                icon: Icons.pets,
                validator: (v) => _validateRequired(v, 'Pet Name'),
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Pet Type',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: AppConstants.petTypes.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text('${AppConstants.petTypeEmoji[type]} $type'),
                )).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _ageController,
                      label: 'Age (years)',
                      icon: Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) => _validateNumber(v, 'Age'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _weightController,
                      label: 'Weight (kg)',
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) => _validateNumber(v, 'Weight'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Smart scheduling section
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.accentPurple),
                  const SizedBox(width: 8),
                  Text('Smart Scheduling', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Auto-generate care schedules based on veterinary recommendations',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),

              if (widget.pet == null)
                SwitchListTile(
                  title: Text('Enable Auto-Schedule', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    'Automatically create feeding, grooming & vaccination schedules',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  value: _enableAutoSchedule,
                  onChanged: (v) => setState(() => _enableAutoSchedule = v),
                  activeColor: AppColors.accentPurple,
                  contentPadding: EdgeInsets.zero,
                ),

              const SizedBox(height: 8),

              // Feeding time
              Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text('🍖', style: TextStyle(fontSize: 20))),
                  ),
                  title: Text('Feeding Time', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    _feedingTime != null
                        ? _feedingTime!.format(context)
                        : 'Auto (based on age)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: TextButton(
                    onPressed: _selectFeedingTime,
                    child: Text(_feedingTime != null ? 'Change' : 'Set'),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Grooming interval
              Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text('✂️', style: TextStyle(fontSize: 20))),
                  ),
                  title: Text('Grooming Interval', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    _groomingIntervalDays > 0
                        ? 'Every $_groomingIntervalDays days'
                        : 'Auto (based on pet type)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: DropdownButton<int>(
                    value: _groomingIntervalDays,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 0, child: Text('Auto')),
                      DropdownMenuItem(value: 14, child: Text('2 weeks')),
                      DropdownMenuItem(value: 21, child: Text('3 weeks')),
                      DropdownMenuItem(value: 28, child: Text('4 weeks')),
                      DropdownMenuItem(value: 42, child: Text('6 weeks')),
                    ],
                    onChanged: (v) => setState(() => _groomingIntervalDays = v ?? 0),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Vaccination date
              Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text('💉', style: TextStyle(fontSize: 20))),
                  ),
                  title: Text('Vaccination', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    _vaccinationDate != null
                        ? '${_vaccinationDate!.day}/${_vaccinationDate!.month}/${_vaccinationDate!.year}'
                        : 'Auto (based on age)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: TextButton(
                    onPressed: _selectVaccinationDate,
                    child: Text(_vaccinationDate != null ? 'Change' : 'Set'),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Doctor check-up
              Card(
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text('🩺', style: TextStyle(fontSize: 20))),
                  ),
                  title: Text('Vet Check-up', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    _doctorCheckDate != null
                        ? '${_doctorCheckDate!.day}/${_doctorCheckDate!.month}/${_doctorCheckDate!.year}'
                        : 'Auto (in 30 days)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: TextButton(
                    onPressed: _selectDoctorDate,
                    child: Text(_doctorCheckDate != null ? 'Change' : 'Set'),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              
              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePet,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(widget.pet == null ? 'Add Pet' : 'Save Changes'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}