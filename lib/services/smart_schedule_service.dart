import '../models/pet.dart';
import '../models/schedule.dart';

/// Service that generates automatic care schedules based on
/// veterinary recommendations when a new pet is added.
class SmartScheduleService {
  /// Generate all automatic schedules for a pet
  static List<Schedule> generateSchedules(Pet pet) {
    final List<Schedule> schedules = [];
    final now = DateTime.now();

    // 1. Feeding schedules
    schedules.addAll(_generateFeedingSchedules(pet, now));

    // 2. Grooming schedules
    schedules.addAll(_generateGroomingSchedules(pet, now));

    // 3. Vaccination schedules
    schedules.addAll(_generateVaccinationSchedules(pet, now));

    // 4. Doctor check-up
    schedules.addAll(_generateDoctorCheckSchedules(pet, now));

    return schedules;
  }

  /// Generate feeding schedules based on pet type & age
  /// - Puppies/Kittens (age <= 1): 3x per day
  /// - Adult pets: 2x per day
  static List<Schedule> _generateFeedingSchedules(Pet pet, DateTime now) {
    final List<Schedule> schedules = [];
    final bool isYoung = pet.age <= 1;
    final int timesPerDay = isYoung ? 3 : 2;

    // Default feeding times
    final List<List<int>> feedingTimes = isYoung
        ? [[7, 0], [12, 0], [18, 0]]   // 7AM, 12PM, 6PM
        : [[8, 0], [18, 0]];            // 8AM, 6PM

    // If user specified a custom time, use that as first feeding
    if (pet.feedingTimeMinutes != null) {
      feedingTimes[0] = [pet.feedingHour, pet.feedingMinute];
    }

    // Generate for next 7 days
    for (int day = 0; day < 7; day++) {
      final date = now.add(Duration(days: day));
      for (int i = 0; i < timesPerDay; i++) {
        final dateTime = DateTime(
          date.year, date.month, date.day,
          feedingTimes[i][0], feedingTimes[i][1],
        );
        // Skip if in the past
        if (dateTime.isBefore(now)) continue;

        schedules.add(Schedule(
          id: '${pet.id}_feed_${day}_$i',
          petId: pet.id,
          type: 'Makan',
          dateTime: dateTime,
          notes: isYoung
              ? 'Feeding ${i + 1}/$timesPerDay (young pet - needs more frequent feeding)'
              : 'Feeding ${i + 1}/$timesPerDay',
        ));
      }
    }

    return schedules;
  }

  /// Generate grooming schedules based on pet type
  /// - Cats: every 2-4 weeks (default 3 weeks)
  /// - Dogs: every 2-6 weeks (default 4 weeks)
  /// - Others: every 4 weeks
  static List<Schedule> _generateGroomingSchedules(Pet pet, DateTime now) {
    final List<Schedule> schedules = [];

    int intervalDays;
    if (pet.groomingIntervalDays != null && pet.groomingIntervalDays! > 0) {
      intervalDays = pet.groomingIntervalDays!;
    } else {
      // Defaults based on pet type
      switch (pet.type) {
        case 'Kucing':
          intervalDays = 21; // 3 weeks
          break;
        case 'Anjing':
          intervalDays = 28; // 4 weeks
          break;
        default:
          intervalDays = 28;
      }
    }

    // Generate grooming schedules for next 3 months
    DateTime nextGrooming = now.add(Duration(days: intervalDays));
    for (int i = 0; i < 4; i++) {
      final groomDate = DateTime(
        nextGrooming.year, nextGrooming.month, nextGrooming.day, 10, 0,
      );
      schedules.add(Schedule(
        id: '${pet.id}_groom_$i',
        petId: pet.id,
        type: 'Grooming',
        dateTime: groomDate,
        notes: 'Regular grooming session (every $intervalDays days)',
      ));
      nextGrooming = nextGrooming.add(Duration(days: intervalDays));
    }

    return schedules;
  }

  /// Generate vaccination schedules based on age
  /// - Young pets (age <= 1): Initial vaccine series
  /// - Adult pets: Annual booster
  static List<Schedule> _generateVaccinationSchedules(Pet pet, DateTime now) {
    final List<Schedule> schedules = [];

    if (pet.vaccinationDate != null) {
      // User specified a date → use it
      schedules.add(Schedule(
        id: '${pet.id}_vacc_custom',
        petId: pet.id,
        type: 'Vaksin',
        dateTime: pet.vaccinationDate!,
        notes: 'Scheduled vaccination',
      ));
      return schedules;
    }

    if (pet.age <= 1) {
      // Young pet: initial vaccine series at 2, 4, 6 weeks from now
      for (int i = 0; i < 3; i++) {
        final vaccDate = now.add(Duration(days: (i + 1) * 14));
        schedules.add(Schedule(
          id: '${pet.id}_vacc_initial_$i',
          petId: pet.id,
          type: 'Vaksin',
          dateTime: DateTime(vaccDate.year, vaccDate.month, vaccDate.day, 10, 0),
          notes: 'Initial vaccine series (dose ${i + 1}/3)',
        ));
      }
    } else {
      // Adult pet: annual booster
      final boosterDate = now.add(const Duration(days: 90));
      schedules.add(Schedule(
        id: '${pet.id}_vacc_annual',
        petId: pet.id,
        type: 'Vaksin',
        dateTime: DateTime(boosterDate.year, boosterDate.month, boosterDate.day, 10, 0),
        notes: 'Annual vaccination booster',
      ));
    }

    return schedules;
  }

  /// Generate doctor check-up schedules
  static List<Schedule> _generateDoctorCheckSchedules(Pet pet, DateTime now) {
    final List<Schedule> schedules = [];

    if (pet.doctorCheckDate != null) {
      schedules.add(Schedule(
        id: '${pet.id}_doctor_custom',
        petId: pet.id,
        type: 'Kontrol Dokter',
        dateTime: pet.doctorCheckDate!,
        notes: 'Scheduled vet check-up',
      ));
      return schedules;
    }

    // Default: schedule a check-up in 30 days
    final checkDate = now.add(const Duration(days: 30));
    schedules.add(Schedule(
      id: '${pet.id}_doctor_routine',
      petId: pet.id,
      type: 'Kontrol Dokter',
      dateTime: DateTime(checkDate.year, checkDate.month, checkDate.day, 9, 0),
      notes: 'Routine veterinary check-up',
    ));

    return schedules;
  }
}
