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

  void _deletePet(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Pet'),
        content: Text('Are you sure you want to delete ${pet.name}? All related schedules and health records will remain.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<PetProvider>(context, listen: false).deletePet(pet.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

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
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () => _deletePet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet avatar
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
            const SizedBox(height: 16),
            Center(
              child: Text(
                pet.name,
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            
            // Pet Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pet Information', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    _buildInfoRow('Type', '${AppConstants.petTypeEmoji[pet.type] ?? ""} ${pet.type}', Icons.category_outlined),
                    _buildInfoRow('Age', '${pet.age} years', Icons.cake_outlined),
                    _buildInfoRow('Weight', '${pet.weight} kg', Icons.monitor_weight_outlined),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Care Schedule Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: AppColors.accentPurple, size: 20),
                        const SizedBox(width: 8),
                        Text('Care Settings', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Feeding',
                      pet.feedingTimeMinutes != null
                          ? 'Custom: ${pet.feedingHour.toString().padLeft(2, '0')}:${pet.feedingMinute.toString().padLeft(2, '0')}'
                          : 'Auto (${pet.age <= 1 ? "3x/day" : "2x/day"})',
                      Icons.restaurant,
                    ),
                    _buildInfoRow(
                      'Grooming',
                      pet.groomingIntervalDays != null
                          ? 'Every ${pet.groomingIntervalDays} days'
                          : 'Auto (${pet.type == "Kucing" ? "3 weeks" : "4 weeks"})',
                      Icons.content_cut,
                    ),
                    if (pet.vaccinationDate != null)
                      _buildInfoRow(
                        'Next Vaccine',
                        DateFormat('MMM d, yyyy').format(pet.vaccinationDate!),
                        Icons.vaccines,
                      ),
                    if (pet.doctorCheckDate != null)
                      _buildInfoRow(
                        'Next Check-up',
                        DateFormat('MMM d, yyyy').format(pet.doctorCheckDate!),
                        Icons.local_hospital,
                      ),
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
                    // Schedules
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Upcoming Schedules', style: Theme.of(context).textTheme.titleLarge),
                                if (petSchedules.isNotEmpty)
                                  Text(
                                    '${petSchedules.length} total',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            petSchedules.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'No schedules yet',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: petSchedules.length > 5 ? 5 : petSchedules.length,
                                    itemBuilder: (context, index) {
                                      final s = petSchedules[index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: CircleAvatar(
                                          backgroundColor: s.isCompleted
                                              ? AppColors.success.withValues(alpha: 0.1)
                                              : AppColors.warning.withValues(alpha: 0.1),
                                          child: Icon(
                                            s.isCompleted ? Icons.check_circle : Icons.pending_outlined,
                                            color: s.isCompleted ? AppColors.success : AppColors.warning,
                                          ),
                                        ),
                                        title: Text(
                                          '${AppConstants.scheduleTypeEmoji[s.type] ?? "📅"} ${s.type}',
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Text(DateFormat('MMM d, yyyy • HH:mm').format(s.dateTime)),
                                        trailing: IconButton(
                                          icon: Icon(
                                            s.isCompleted ? Icons.undo : Icons.check,
                                            size: 20,
                                          ),
                                          onPressed: () => scheduleProvider.toggleCompleted(s.id),
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Health Records
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Health Records', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 12),
                            petHealth.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      'No health records yet',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: petHealth.length > 3 ? 3 : petHealth.length,
                                    itemBuilder: (context, index) {
                                      final h = petHealth[index];
                                      return ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const CircleAvatar(
                                          backgroundColor: Color(0x1AEF5350),
                                          child: Icon(Icons.favorite, color: AppColors.error),
                                        ),
                                        title: Text(
                                          'Checkup: ${DateFormat.yMd().format(h.checkupDate)}',
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: h.diseaseHistory.isNotEmpty
                                            ? Text(h.diseaseHistory)
                                            : null,
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
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}