import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/schedule_provider.dart';
import '../providers/pet_provider.dart';
import '../models/schedule.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';

class AddEditScheduleScreen extends StatefulWidget {
  const AddEditScheduleScreen({super.key});

  @override
  State<AddEditScheduleScreen> createState() => _AddEditScheduleScreenState();
}

class _AddEditScheduleScreenState extends State<AddEditScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  
  String? _selectedPetId;
  String _selectedType = AppConstants.scheduleTypes.first;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isLoading = false;

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) setState(() => _selectedTime = time);
  }

  Future<void> _saveSchedule() async {
    if (_selectedPetId == null) return;
    
    setState(() => _isLoading = true);
    
    final provider = Provider.of<ScheduleProvider>(context, listen: false);
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    
    final schedule = Schedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petId: _selectedPetId!,
      type: _selectedType,
      dateTime: dateTime,
      notes: _notesController.text,
    );
    
    await provider.addSchedule(schedule);
    
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
        centerTitle: true,
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          final pets = petProvider.pets;
          
          if (pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 64, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  Text('Please add a pet first', style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _selectedPetId,
                    decoration: const InputDecoration(
                      labelText: 'Select Pet',
                      prefixIcon: Icon(Icons.pets),
                    ),
                    items: pets.map((pet) => DropdownMenuItem(
                      value: pet.id,
                      child: Text(pet.name),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedPetId = value),
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Schedule Type',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: AppConstants.scheduleTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text('$type ${AppConstants.scheduleTypeEmoji[type]}'),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(DateFormat.yMd().format(_selectedDate)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 8),
                  
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(_selectedTime.format(context)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _selectTime,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomTextField(
                    controller: _notesController,
                    label: 'Notes',
                    icon: Icons.note_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveSchedule,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save Schedule'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}