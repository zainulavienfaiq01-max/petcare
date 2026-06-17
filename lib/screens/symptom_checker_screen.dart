import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/disease_data_service.dart';
import '../providers/audio_provider.dart';
import '../utils/colors.dart';
import 'disease_detail_screen.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final List<String> _availableSymptoms = [];
  final Set<String> _selectedSymptoms = {};
  List<DiseaseInfo> _matchedDiseases = [];
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    _extractSymptoms();
  }

  void _extractSymptoms() {
    final Set<String> symptoms = {};
    for (var disease in DiseaseDataService.diseases) {
      for (var s in disease.symptoms) {
        // Normalize slightly to prevent duplicates like 'fever' and 'Fever'
        symptoms.add(s.trim());
      }
    }
    _availableSymptoms.addAll(symptoms.toList()..sort());
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
      _hasChecked = false; // Reset results when selections change
    });
  }

  void _checkSymptoms() {
    context.read<AudioProvider>().playActionClick();
    if (_selectedSymptoms.isEmpty) {
      setState(() {
        _matchedDiseases = [];
        _hasChecked = true;
      });
      return;
    }

    final Map<DiseaseInfo, int> matchScores = {};
    
    for (var disease in DiseaseDataService.diseases) {
      int score = 0;
      for (var symptom in _selectedSymptoms) {
        if (disease.symptoms.contains(symptom)) {
          score++;
        }
      }
      if (score > 0) {
        matchScores[disease] = score;
      }
    }

    final sortedMatches = matchScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    setState(() {
      _matchedDiseases = sortedMatches.map((e) => e.key).toList();
      _hasChecked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Symptom Checker',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your pet experiencing?',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select all symptoms that apply to find potential causes. This is not a substitute for a professional veterinary diagnosis.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Symptoms Wrap
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSymptoms.map((symptom) {
                      final isSelected = _selectedSymptoms.contains(symptom);
                      return ChoiceChip(
                        label: Text(symptom),
                        selected: isSelected,
                        onSelected: (_) => _toggleSymptom(symptom),
                        selectedColor: AppColors.primaryPurple.withValues(alpha: 0.2),
                        labelStyle: GoogleFonts.poppins(
                          color: isSelected 
                              ? AppColors.primaryPurple 
                              : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 13,
                        ),
                        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppColors.primaryPurple : Colors.grey.withValues(alpha: 0.3),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _selectedSymptoms.isEmpty ? null : _checkSymptoms,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Check Symptoms',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  if (_hasChecked) ...[
                    Text(
                      'Potential Matches',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_matchedDiseases.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No specific diseases matched these symptoms. Please consult a vet if symptoms persist.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _matchedDiseases.length,
                        itemBuilder: (context, index) {
                          final disease = _matchedDiseases[index];
                          // Calculate match percentage roughly based on matched symptoms
                          int matchCount = disease.symptoms.where((s) => _selectedSymptoms.contains(s)).length;
                          String matchLabel = '$matchCount/${_selectedSymptoms.length} matching';
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(disease.emoji, style: const TextStyle(fontSize: 22)),
                                ),
                              ),
                              title: Text(
                                disease.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                              subtitle: Text(
                                matchLabel,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.primaryPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
                              onTap: () {
                                context.read<AudioProvider>().playActionClick();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DiseaseDetailScreen(disease: disease),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
