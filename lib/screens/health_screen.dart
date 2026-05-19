import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import '../providers/pet_provider.dart';
import '../utils/colors.dart';
import 'add_edit_health_screen.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records'),
        centerTitle: true,
      ),
      body: Consumer2<HealthProvider, PetProvider>(
        builder: (context, healthProvider, petProvider, child) {
          final records = healthProvider.records;
          
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 64, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  Text('No health records yet', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEditHealthScreen()),
                    ),
                    child: const Text('Add Health Record'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final pet = petProvider.getPetById(record.petId);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, color: AppColors.error),
                  ),
                  title: Text(
                    '${pet?.name ?? 'Unknown'} - Checkup',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${DateFormat.yMd().format(record.checkupDate)}'),
                      if (record.diseaseHistory.isNotEmpty)
                        Text('Disease: ${record.diseaseHistory}'),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddEditHealthScreen(record: record)),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditHealthScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}