import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/pet_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/stat_card.dart';
import 'consultation_screen.dart';
import 'news_screen.dart';
import 'pet_library_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final t = locale.translate;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName, style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: Consumer2<PetProvider, ScheduleProvider>(
        builder: (context, petProvider, scheduleProvider, child) {
          final pets = petProvider.pets;
          final todaySchedules = scheduleProvider.todaySchedules;
          final upcomingVaccines = scheduleProvider.schedules.where((s) => s.type == 'Vaksin' && !s.isCompleted).take(3).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t('welcome_back'),
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                ),
                Text(
                  DateFormat('EEEE, MMMM d').format(DateTime.now()),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 24),
                
                Text('Your Pets', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: pets.isEmpty
                      ? Center(child: Text('No pets added yet', style: Theme.of(context).textTheme.bodyMedium))
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: pets.length,
                          itemBuilder: (context, index) {
                            final pet = pets[index];
                            return Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
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
                                        style: const TextStyle(fontSize: 32),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    pet.name,
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                
                const SizedBox(height: 24),
                Text(t('quick_actions'), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        context,
                        title: t('consultation'),
                        icon: Icons.health_and_safety,
                        color: Colors.blue,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ConsultationScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildQuickActionCard(
                        context,
                        title: t('pet_news'),
                        icon: Icons.article,
                        color: Colors.orange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewsScreen()),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildQuickActionCard(
                        context,
                        title: t('pet_library'),
                        icon: Icons.auto_stories,
                        color: AppColors.accentPurple,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PetLibraryScreen()),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Text(t('statistics'), style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StatCard(
                      title: 'Total Pets',
                      value: pets.length.toString(),
                      icon: Icons.pets,
                      gradient: AppColors.cardGradient1,
                    ),
                    StatCard(
                      title: "Today's Tasks",
                      value: todaySchedules.length.toString(),
                      icon: Icons.today,
                      gradient: AppColors.cardGradient2,
                    ),
                    StatCard(
                      title: 'Completed',
                      value: scheduleProvider.schedules.where((s) => s.isCompleted).length.toString(),
                      icon: Icons.check_circle,
                      gradient: AppColors.cardGradient3,
                    ),
                    StatCard(
                      title: 'Upcoming Vaccines',
                      value: upcomingVaccines.length.toString(),
                      icon: Icons.vaccines,
                      gradient: AppColors.cardGradient4,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                Text('Today\'s Schedule', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                todaySchedules.isEmpty
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(Icons.calendar_today, size: 48, color: Theme.of(context).disabledColor),
                              const SizedBox(height: 12),
                              Text('No schedules for today', style: Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: todaySchedules.length,
                        itemBuilder: (context, index) {
                          final schedule = todaySchedules[index];
                          final pet = petProvider.getPetById(schedule.petId);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                                child: Text(AppConstants.scheduleTypeEmoji[schedule.type] ?? '📅'),
                              ),
                              title: Text(schedule.type, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                              subtitle: Text('${pet?.name ?? 'Unknown'} • ${DateFormat('HH:mm').format(schedule.dateTime)}'),
                              trailing: Icon(
                                schedule.isCompleted ? Icons.check_circle : Icons.pending_outlined,
                                color: schedule.isCompleted ? AppColors.success : AppColors.warning,
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}