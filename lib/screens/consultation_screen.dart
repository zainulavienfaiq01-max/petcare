import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  
  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': 'Hello! I am your AI Pet Assistant. You can ask me anything about pet health, feeding, grooming, or send me photos/videos for analysis.',
      'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'mediaPath': null,
      'mediaType': null,
    },
  ];

  XFile? _selectedMedia;
  String? _selectedMediaType; // 'image' or 'video'
  bool _isLoading = false;

  // Replace with actual API key
  final String apiKey = 'YOUR_GEMINI_API_KEY';

  Future<void> _pickMedia(ImageSource source, String type) async {
    try {
      XFile? pickedFile;
      if (type == 'video') {
        pickedFile = await _picker.pickVideo(source: source);
      } else {
        pickedFile = await _picker.pickImage(source: source);
      }

      if (pickedFile != null) {
        setState(() {
          _selectedMedia = pickedFile;
          _selectedMediaType = type;
        });
      }
    } catch (e) {
      debugPrint('Error picking media: $e');
    }
  }

  void _showAttachmentOptions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AttachmentOption(
                icon: Icons.camera_alt,
                label: 'Camera',
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.camera, 'image');
                },
              ),
              _AttachmentOption(
                icon: Icons.photo_library,
                label: 'Gallery',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery, 'image');
                },
              ),
              _AttachmentOption(
                icon: Icons.videocam,
                label: 'Video',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  _pickMedia(ImageSource.gallery, 'video');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeSelectedMedia() {
    setState(() {
      _selectedMedia = null;
      _selectedMediaType = null;
    });
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedMedia == null) return;

    final mediaPath = _selectedMedia?.path;
    final mediaType = _selectedMediaType;
    final fileBytes = _selectedMedia != null ? await _selectedMedia!.readAsBytes() : null;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text.isNotEmpty ? text : (mediaType == 'image' ? 'Sent an image' : 'Sent a video'),
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        'mediaPath': mediaPath,
        'mediaType': mediaType,
      });
      _messageController.clear();
      _selectedMedia = null;
      _selectedMediaType = null;
      _isLoading = true;
    });
    
    _scrollToBottom();

    if (apiKey == 'YOUR_GEMINI_API_KEY' || apiKey.isEmpty) {
      // Logic Mock Response
      await Future.delayed(const Duration(seconds: 2));
      
      if (mediaType == 'video') {
        _addBotResponse("I have analyzed the video you sent. It looks like your pet is exhibiting normal behavior, but if you notice continuous lethargy, please visit a vet.");
      } else if (mediaType == 'image') {
        _addBotResponse("Based on the image provided, your pet's appearance seems fine. However, photos can't replace a real clinical exam. Can you give me more context?");
      } else {
        _addBotResponse(_generateMockResponse(text));
      }
    } else {
      // Actual Gemini API
      try {
        final model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          systemInstruction: Content.system("You are an expert veterinary AI. Provide clear advice about pet care, and analyze any images or videos attached carefully."),
        );
        
        final content = <Part>[];
        if (text.isNotEmpty) content.add(TextPart(text));
        
        if (fileBytes != null && mediaType == 'image') {
          content.add(DataPart('image/jpeg', fileBytes));
        }

        final response = await model.generateContent([Content.multi(content)]);
        _addBotResponse(response.text ?? "I'm sorry, I couldn't process that.");
      } catch (e) {
        _addBotResponse("I encountered an error connecting to the AI service. $e");
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
        'mediaPath': null,
        'mediaType': null,
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
    if (lowerInput.contains('food') || lowerInput.contains('diet')) {
      return "Ensure your pet gets high-quality commercial food appropriate for their age. Avoid human foods like chocolate or grapes.";
    } else if (lowerInput.contains('groom') || lowerInput.contains('bath')) {
      return "Brush them a few times a week. Bathe dogs every 4-6 weeks (cats rarely need baths).";
    } else {
      return "To keep them happy and healthy, always ensure they have a good diet and plenty of exercise.";
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
              'Multimodal Pet AI',
              style: GoogleFonts.poppins(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
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
                final mType = message['mediaType'] as String?;
                final mPath = message['mediaPath'] as String?;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    padding: const EdgeInsets.all(12),
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
                        
                        // Media Display
                        if (mPath != null) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: mType == 'image'
                                ? Image.file(File(mPath), fit: BoxFit.cover, height: 150, width: double.infinity)
                                : Container(
                                    height: 100,
                                    width: double.infinity,
                                    color: Colors.black12,
                                    child: const Center(
                                      child: Icon(Icons.videocam, size: 40, color: Colors.white),
                                    ),
                                  ),
                          ),
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
                              color: isUser ? Colors.white70 : Colors.grey[500],
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
          
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text('Analysing...', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
                  ],
                ),
              ),
            ),
            
          // Input Area
          Container(
            padding: EdgeInsets.only(
              left: 10, right: 10, top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            decoration: BoxDecoration(color: isDark ? AppColors.cardDark : Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selected media preview
                if (_selectedMedia != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, left: 10),
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      children: [
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[200],
                            image: _selectedMediaType == 'image'
                                ? DecorationImage(image: FileImage(File(_selectedMedia!.path)), fit: BoxFit.cover)
                                : null,
                          ),
                          child: _selectedMediaType == 'video'
                              ? const Icon(Icons.videocam, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          right: -5, top: -5,
                          child: GestureDetector(
                            onTap: _removeSelectedMedia,
                            child: Container(
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Text input row
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_photo_alternate, color: AppColors.primaryPurple),
                      onPressed: _showAttachmentOptions,
                    ),
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
                          decoration: const InputDecoration(
                            hintText: 'Ask or describe photo...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          maxLines: 3,
                          minLines: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _isLoading ? null : _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
