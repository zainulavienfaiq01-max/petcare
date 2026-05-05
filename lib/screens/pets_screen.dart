import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/pet_provider.dart';
import '../models/pet.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'add_edit_pet_screen.dart';
import 'pet_detail_screen.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
        centerTitle: true,
      ),
      body: Consumer<PetProvider>(
        builder: (context, provider, child) {
          final pets = provider.pets;
          
          if (pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pets, size: 64, color: Theme.of(context).disabledColor),
                  const SizedBox(height: 16),
                  Text('No pets added yet', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddEditPetScreen()),
                    ),
                    child: const Text('Add Your First Pet'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: index % 4 == 0 ? AppColors.cardGradient1 : 
                           index % 4 == 1 ? AppColors.cardGradient2 :
                           index % 4 == 2 ? AppColors.cardGradient3 : AppColors.cardGradient4,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Center(
                      child: Text(
                        AppConstants.petTypeEmoji[pet.type] ?? '🐾',
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  title: Text(pet.name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${pet.type} • ${pet.age} years old', style: Theme.of(context).textTheme.bodyMedium),
                      Text('${pet.weight} kg', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PetDetailScreen(pet: pet)),
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
          MaterialPageRoute(builder: (_) => const AddEditPetScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}