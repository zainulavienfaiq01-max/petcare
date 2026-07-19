import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/schedule_provider.dart';
import '../providers/pet_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../models/schedule.dart';
import 'add_edit_schedule_screen.dart';

enum ScheduleSort { nearestTime, latestTime, petName, activityType }

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  String _activeFilter = 'all'; // all, today, tomorrow, this_week, completed, overdue, calendar
  ScheduleSort _currentSort = ScheduleSort.nearestTime;

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocaleProvider>(context);
    final t = locale.translate;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(t('nav_schedule')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: t('sort_by'),
            onPressed: () => _showSortBottomSheet(context, t, isDark),
          ),
        ],
      ),
      body: Consumer2<ScheduleProvider, PetProvider>(
        builder: (context, scheduleProvider, petProvider, child) {
          final allSchedules = scheduleProvider.schedules;
          final schedules = _getFilteredAndSortedSchedules(allSchedules, petProvider);

          return Column(
            children: [
              // ── Horizontally Scrollable Filter Chips ─────────────────────
              _buildFilterChips(t, isDark),

              Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    _activeFilter = 'calendar'; // Switch filter to calendar day selection
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
                    markerDecoration: const BoxDecoration(
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _getSectionTitle(t),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
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
              
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: schedules.isEmpty
                      ? _buildEmptyState(t, isDark)
                      : ListView.builder(
                          key: ValueKey('$_activeFilter-$_currentSort-${schedules.length}'),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        schedule.type,
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _buildStatusBadge(schedule, t),
                                  ],
                                ),
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

  /// Horizontally scrollable chip row
  Widget _buildFilterChips(String Function(String) t, bool isDark) {
    final filters = [
      {'key': 'all', 'label': t('filter_all'), 'icon': Icons.all_inclusive},
      {'key': 'today', 'label': t('filter_today'), 'icon': Icons.today},
      {'key': 'tomorrow', 'label': t('filter_tomorrow'), 'icon': Icons.calendar_today},
      {'key': 'this_week', 'label': t('filter_this_week'), 'icon': Icons.date_range},
      {'key': 'completed', 'label': t('filter_completed'), 'icon': Icons.check_circle_outline},
      {'key': 'overdue', 'label': t('filter_overdue'), 'icon': Icons.error_outline},
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 10, bottom: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _activeFilter == filter['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                filter['label'] as String,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                ),
              ),
              avatar: Icon(
                filter['icon'] as IconData,
                size: 15,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
              ),
              backgroundColor: isDark ? AppColors.cardDark : AppColors.softGrey,
              selectedColor: AppColors.accentPurple,
              checkmarkColor: Colors.white,
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.accentPurple
                      : (isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.divider),
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  _activeFilter = filter['key'] as String;
                });
              },
            ),
          );
        },
      ),
    );
  }

  /// Show standard modern bottom sheet for choosing sort options
  void _showSortBottomSheet(BuildContext context, String Function(String) t, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        final sortOptions = [
          {'value': ScheduleSort.nearestTime, 'label': t('sort_nearest_time'), 'icon': Icons.access_time},
          {'value': ScheduleSort.latestTime, 'label': t('sort_latest_time'), 'icon': Icons.history},
          {'value': ScheduleSort.petName, 'label': t('sort_pet_name'), 'icon': Icons.pets},
          {'value': ScheduleSort.activityType, 'label': t('sort_activity_type'), 'icon': Icons.category},
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    t('sort_by'),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Divider(),
                ...sortOptions.map((opt) {
                  final isSelected = _currentSort == opt['value'];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    leading: Icon(
                      opt['icon'] as IconData,
                      color: isSelected ? AppColors.accentPurple : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                    ),
                    title: Text(
                      opt['label'] as String,
                      style: GoogleFonts.poppins(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? AppColors.accentPurple : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: AppColors.accentPurple)
                        : null,
                    onTap: () {
                      setState(() {
                        _currentSort = opt['value'] as ScheduleSort;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Custom badge for status display
  Widget _buildStatusBadge(Schedule schedule, String Function(String) t) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final scheduleDate = DateTime(schedule.dateTime.year, schedule.dateTime.month, schedule.dateTime.day);

    Color color;
    String label;

    if (schedule.isCompleted) {
      color = AppColors.success;
      label = t('status_completed');
    } else if (scheduleDate.isBefore(todayStart)) {
      color = AppColors.error;
      label = t('status_overdue');
    } else if (scheduleDate.isAtSameMomentAs(todayStart)) {
      color = AppColors.warning;
      label = t('status_today');
    } else {
      color = AppColors.info;
      label = t('status_upcoming');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Empty state widget if filter yields no schedules
  Widget _buildEmptyState(String Function(String) t, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: isDark ? Colors.grey[600] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              t('no_schedules_category'),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Logic to filter and sort schedules
  List<Schedule> _getFilteredAndSortedSchedules(List<Schedule> allSchedules, PetProvider petProvider) {
    List<Schedule> filtered = [];
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final sevenDaysLater = todayStart.add(const Duration(days: 7));

    if (_activeFilter == 'all') {
      filtered = List.from(allSchedules);
    } else if (_activeFilter == 'today') {
      filtered = allSchedules.where((s) =>
        s.dateTime.year == now.year &&
        s.dateTime.month == now.month &&
        s.dateTime.day == now.day
      ).toList();
    } else if (_activeFilter == 'tomorrow') {
      final tomorrow = now.add(const Duration(days: 1));
      filtered = allSchedules.where((s) =>
        s.dateTime.year == tomorrow.year &&
        s.dateTime.month == tomorrow.month &&
        s.dateTime.day == tomorrow.day
      ).toList();
    } else if (_activeFilter == 'this_week') {
      filtered = allSchedules.where((s) {
        final date = DateTime(s.dateTime.year, s.dateTime.month, s.dateTime.day);
        return !date.isBefore(todayStart) && !date.isAfter(sevenDaysLater);
      }).toList();
    } else if (_activeFilter == 'completed') {
      filtered = allSchedules.where((s) => s.isCompleted).toList();
    } else if (_activeFilter == 'overdue') {
      filtered = allSchedules.where((s) {
        final date = DateTime(s.dateTime.year, s.dateTime.month, s.dateTime.day);
        return date.isBefore(todayStart) && !s.isCompleted;
      }).toList();
    } else if (_activeFilter == 'calendar') {
      filtered = allSchedules.where((s) =>
        s.dateTime.year == _selectedDay.year &&
        s.dateTime.month == _selectedDay.month &&
        s.dateTime.day == _selectedDay.day
      ).toList();
    }

    // Apply Sorting
    switch (_currentSort) {
      case ScheduleSort.nearestTime:
        filtered.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        break;
      case ScheduleSort.latestTime:
        filtered.sort((a, b) => b.dateTime.compareTo(a.dateTime));
        break;
      case ScheduleSort.petName:
        filtered.sort((a, b) {
          final petA = petProvider.getPetById(a.petId)?.name.toLowerCase() ?? '';
          final petB = petProvider.getPetById(b.petId)?.name.toLowerCase() ?? '';
          return petA.compareTo(petB);
        });
        break;
      case ScheduleSort.activityType:
        filtered.sort((a, b) => a.type.toLowerCase().compareTo(b.type.toLowerCase()));
        break;
    }

    return filtered;
  }

  /// Get title for current active list display
  String _getSectionTitle(String Function(String) t) {
    if (_activeFilter == 'calendar') {
      return 'Schedules for ${DateFormat.yMd().format(_selectedDay)}';
    }
    
    switch (_activeFilter) {
      case 'all':
        return 'All Schedules';
      case 'today':
        return "Today's Schedules";
      case 'tomorrow':
        return "Tomorrow's Schedules";
      case 'this_week':
        return 'Schedules for This Week';
      case 'completed':
        return 'Completed Schedules';
      case 'overdue':
        return 'Overdue Schedules';
      default:
        return 'Schedules';
    }
  }
}