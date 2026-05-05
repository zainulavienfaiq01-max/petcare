import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/pet_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/health_provider.dart';
import '../models/pet.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'add_edit_pet_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;
  
  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddEditPetScreen(pet: pet)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient1,
                  shape: BoxShape.circle,
                  boxShadow: AppColors.cardShadow,
                ),
                child: Center(
                  child: Text(
                    AppConstants.petTypeEmoji[pet.type] ?? '🐾',
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pet Information', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _buildInfoRow('Type', pet.type, Icons.category_outlined),
                    _buildInfoRow('Age', '${pet.age} years', Icons.cake_outlined),
                    _buildInfoRow('Weight', '${pet.weight} kg', Icons.monitor_weight_outlined),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            Consumer2<ScheduleProvider, HealthProvider>(
              builder: (context, scheduleProvider, healthProvider, child) {
                final petSchedules = scheduleProvider.getSchedulesByPet(pet.id);
                final petHealth = healthProvider.getRecordsByPet(pet.id);
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recent Schedules', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 12),
                            petSchedules.isEmpty
                                ? const Text('No schedules yet')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: petSchedules.length > 3 ? 3 : petSchedules.length,
                                    itemBuilder: (context, index) {
                                      final s = petSchedules[index];
                                      return ListTile(
                                        leading: Icon(
                                          s.isCompleted ? Icons.check_circle : Icons.pending_outlined,
                                          color: s.isCompleted ? AppColors.success : AppColors.warning,
                                        ),
                                        title: Text(s.type),
                                        subtitle: Text(DateFormat('MMM d, yyyy • HH:mm').format(s.dateTime)),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Health Records', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 12),
                            petHealth.isEmpty
                                ? const Text('No health records yet')
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: petHealth.length > 3 ? 3 : petHealth.length,
                                    itemBuilder: (context, index) {
                                      final h = petHealth[index];
                                      return ListTile(
                                        leading: const Icon(Icons.favorite, color: AppColors.error),
                                        title: Text('Checkup: ${DateFormat.yMd().format(h.checkupDate)}'),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryPurple),
          const SizedBox(width: 12),
          Text('$label: ', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}