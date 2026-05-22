import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/colors.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello! I am your AI Pet Assistant. You can ask me anything about pet health, feeding, grooming, or general care.',
      'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    },
  ];

  bool _isLoading = false;

  // IMPORTANT: Replace this with your actual Gemini API Key from Google AI Studio.
  // If left as default, it will fall back to a mock intelligent response system.
  final String apiKey = 'YOUR_GEMINI_API_KEY';

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
      _messageController.clear();
      _isLoading = true;
    });
    
    _scrollToBottom();

    if (apiKey == 'YOUR_GEMINI_API_KEY' || apiKey.isEmpty) {
      // Fallback Mock AI that simulates intelligent responses
      await Future.delayed(const Duration(seconds: 2));
      _addBotResponse(_generateMockResponse(text));
    } else {
      // Use actual Gemini API
      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          systemInstruction: Content.system("You are an expert, helpful, and friendly veterinary AI assistant for the PetCare mobile app. Provide clear, accurate, and actionable advice related to pet care, feeding, grooming, and health monitoring. Be concise but informative."),
        );
        
        // Build chat history
        final content = [
          Content.text(text),
        ];
        
        final response = await model.generateContent(content);
        _addBotResponse(response.text ?? "I'm sorry, I couldn't process that.");
      } catch (e) {
        _addBotResponse("I encountered an error connecting to the AI service. Please check your API key or internet connection.");
      }
    }
  }

  void _addBotResponse(String text) {
    if (!mounted) return;
    setState(() {
      _messages.add({
        'isUser': false,
        'text': text,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateMockResponse(String input) {
    final lowerInput = input.toLowerCase();
    if (lowerInput.contains('food') || lowerInput.contains('feed') || lowerInput.contains('diet')) {
      return "For a balanced diet, ensure your pet gets high-quality commercial food appropriate for their age, size, and breed. Always provide fresh water. Avoid human foods like chocolate, grapes, or onions, which are toxic to dogs and cats.";
    } else if (lowerInput.contains('groom') || lowerInput.contains('bath') || lowerInput.contains('brush')) {
      return "Regular grooming keeps your pet's coat healthy! Brush them a few times a week to prevent matting. Bathe dogs every 4-6 weeks (cats rarely need baths unless they get into something messy). Don't forget to trim their nails regularly!";
    } else if (lowerInput.contains('sick') || lowerInput.contains('vomit') || lowerInput.contains('health')) {
      return "If your pet is showing signs of illness like vomiting, lethargy, or loss of appetite for more than 24 hours, it's best to consult a veterinarian immediately. While I can give general advice, I cannot diagnose medical conditions.";
    } else if (lowerInput.contains('vaccin')) {
      return "Vaccinations are crucial for preventing serious diseases like Parvovirus and Rabies. Puppies and kittens need a series of shots, followed by annual or tri-annual boosters depending on the vaccine. Check the 'Schedule' tab to keep track of them!";
    } else {
      return "That's an interesting question about your pet! To keep them happy and healthy, always ensure they have a good diet, plenty of exercise, and lots of love. Is there a specific health or grooming topic you'd like to know more about?";
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Consultation',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Powered by Intelligent Pet AI',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Assistant provides general advice. For emergencies, visit a vet.')),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Chat area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['isUser'] as bool;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUser 
                        ? AppColors.primaryPurple 
                        : (isDark ? AppColors.cardDark : Colors.white),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isUser ? 20 : 0),
                        bottomRight: Radius.circular(isUser ? 0 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isUser) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.psychology, size: 16, color: AppColors.primaryPurple),
                              const SizedBox(width: 6),
                              Text(
                                'AI Assistant',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          message['text'] as String,
                          style: GoogleFonts.poppins(
                            color: isUser 
                              ? Colors.white 
                              : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            message['time'] as String,
                            style: GoogleFonts.poppins(
                              color: isUser 
                                ? Colors.white.withValues(alpha: 0.7) 
                                : Colors.grey[500],
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Typing indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'AI is thinking...',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
          // Input area
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(context).padding.bottom + 12,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark : Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.poppins(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask about your pet...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _isLoading ? null : _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isLoading ? Colors.grey : AppColors.primaryPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
