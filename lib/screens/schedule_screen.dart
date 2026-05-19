import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/schedule_provider.dart';
import '../providers/pet_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'add_edit_schedule_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        centerTitle: true,
      ),
      body: Consumer2<ScheduleProvider, PetProvider>(
        builder: (context, scheduleProvider, petProvider, child) {
          final schedules = scheduleProvider.getSchedulesByDate(_selectedDay);
          
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) => setState(() => _calendarFormat = format),
                  onDaySelected: (selected, focused) => setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  }),
                  eventLoader: (day) => scheduleProvider.getSchedulesByDate(day),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.primaryPurple.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: AppColors.accentPurple,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Schedules for ${DateFormat.yMd().format(_selectedDay)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddEditScheduleScreen()),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              Expanded(
                child: schedules.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today, size: 48, color: Theme.of(context).disabledColor),
                            const SizedBox(height: 16),
                            Text('No schedules for this day', style: Theme.of(context).textTheme.bodyLarge),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = schedules[index];
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
                              trailing: IconButton(
                                icon: Icon(
                                  schedule.isCompleted ? Icons.check_circle : Icons.pending_outlined,
                                  color: schedule.isCompleted ? AppColors.success : AppColors.warning,
                                ),
                                onPressed: () => scheduleProvider.toggleCompleted(schedule.id),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditScheduleScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}