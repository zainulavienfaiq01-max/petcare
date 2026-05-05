import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import '../providers/pet_provider.dart';
import '../models/health_record.dart';
import '../utils/colors.dart';
import '../widgets/custom_text_field.dart';

class AddEditHealthScreen extends StatefulWidget {
  final HealthRecord? record;
  
  const AddEditHealthScreen({super.key, this.record});

  @override
  State<AddEditHealthScreen> createState() => _AddEditHealthScreenState();
}

class _AddEditHealthScreenState extends State<AddEditHealthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diseaseController = TextEditingController();
  final _medicationController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedPetId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _selectedPetId = widget.record!.petId;
      _diseaseController.text = widget.record!.diseaseHistory;
      _medicationController.text = widget.record!.medication;
      _allergiesController.text = widget.record!.allergies;
      _notesController.text = widget.record!.notes;
      _selectedDate = widget.record!.checkupDate;
    }
  }

  @override
  void dispose() {
    _diseaseController.dispose();
    _medicationController.dispose();
    _allergiesController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _saveRecord() async {
    if (_selectedPetId == null) return;
    
    setState(() => _isLoading = true);
    
    final provider = Provider.of<HealthProvider>(context, listen: false);
    final record = HealthRecord(
      id: widget.record?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      petId: _selectedPetId!,
      diseaseHistory: _diseaseController.text,
      medication: _medicationController.text,
      allergies: _allergiesController.text,
      checkupDate: _selectedDate,
      notes: _notesController.text,
    );
    
    if (widget.record == null) {
      await provider.addRecord(record);
    } else {
      await provider.updateRecord(record);
    }
    
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record == null ? 'Add Health Record' : 'Edit Health Record'),
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
                    value: _selectedPetId,
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
                  
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text('Checkup Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomTextField(
                    controller: _diseaseController,
                    label: 'Disease History',
                    icon: Icons.local_hospital_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomTextField(
                    controller: _medicationController,
                    label: 'Medication',
                    icon: Icons.medication_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomTextField(
                    controller: _allergiesController,
                    label: 'Allergies',
                    icon: Icons.warning_outlined,
                    maxLines: 2,
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
                      onPressed: _isLoading ? null : _saveRecord,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(widget.record == null ? 'Save Record' : 'Update Record'),
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