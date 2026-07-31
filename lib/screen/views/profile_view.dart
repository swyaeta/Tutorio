import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfileView extends StatefulWidget {
  final Map<String, dynamic>? profile;

  const ProfileView({super.key, required this.profile});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String? currentLanguage;

  final List<Map<String, String>> languages = [
    {'name': 'Arabic', 'flag': '🇸🇦', 'code': 'ar'},
    {'name': 'Bengali', 'flag': '🇧🇩', 'code': 'bn'},
    {'name': 'Dutch', 'flag': '🇳🇱', 'code': 'nl'},
    {'name': 'English', 'flag': '🇺🇸', 'code': 'en'},
    {'name': 'Tagalog', 'flag': '🇵🇭', 'code': 'tl'},
    {'name': 'French', 'flag': '🇫🇷', 'code': 'fr'},
    {'name': 'German', 'flag': '🇩🇪', 'code': 'de'},
    {'name': 'Hausa', 'flag': '🇳🇬', 'code': 'ha'},
    {'name': 'Hindi', 'flag': '🇮🇳', 'code': 'hi'},
    {'name': 'Indonesian', 'flag': '🇮🇩', 'code': 'id'},
    {'name': 'Italian', 'flag': '🇮🇹', 'code': 'it'},
    {'name': 'Japanese', 'flag': '🇯🇵', 'code': 'ja'},
    {'name': 'Korean', 'flag': '🇰🇷', 'code': 'ko'},
    {'name': 'Malay', 'flag': '🇲🇾', 'code': 'ms'},
    {'name': 'Mandarin', 'flag': '🇨🇳', 'code': 'zh'},
    {'name': 'Nepali', 'flag': '🇳🇵', 'code': 'ne'},
    {'name': 'Farsi', 'flag': '🇮🇷', 'code': 'fa'},
    {'name': 'Polish', 'flag': '🇵🇱', 'code': 'pl'},
    {'name': 'Portuguese', 'flag': '🇧🇷', 'code': 'pt'},
    {'name': 'Urdu', 'flag': '🇵🇰', 'code': 'ur'},
    {'name': 'Russian', 'flag': '🇷🇺', 'code': 'ru'},
    {'name': 'Swahili', 'flag': '🇰🇪', 'code': 'sw'},
    {'name': 'Tamil', 'flag': '🇮🇳', 'code': 'ta'},
    {'name': 'Telugu', 'flag': '🇮🇳', 'code': 'te'},
    {'name': 'Thai', 'flag': '🇹🇭', 'code': 'th'},
    {'name': 'Turkish', 'flag': '🇹🇷', 'code': 'tr'},
    {'name': 'Vietnamese', 'flag': '🇻🇳', 'code': 'vi'},
  ];

  @override
  void initState() {
    super.initState();
    currentLanguage = widget.profile?['appLanguage'] ?? 'English';
  }

  Future<void> _updateLanguage(String newLangName, String langCode) async {
    setState(() {
      currentLanguage = newLangName;
    });

    await context.setLocale(Locale(langCode));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('appLanguage', newLangName);
    } catch (e) {
      debugPrint('Failed to save language choice locally: $e');
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      debugPrint('Logout failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to log out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Icon(Icons.account_circle, size: 96, color: Color(0xFF94A3B8)),
          const SizedBox(height: 16),
          Text(
            user?.displayName ?? "Learner",
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? "",
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
          ),
          const SizedBox(height: 32),

          // Profile Settings Info Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1632),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2C4F60).withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "profile_settings".tr(),
                  style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Divider(color: Colors.grey, height: 24),
                _row("education".tr(), widget.profile?['educationLevel']),
                _row("school_system".tr(), widget.profile?['educationSystem']),
                _row("learning_style".tr(), widget.profile?['learningStyle']),
                _row("daily_goal".tr(), widget.profile?['dailyCommitment']),
                _row("target_score".tr(), widget.profile?['targetSatScore']),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // App Language Picker
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1632),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2C4F60).withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.language, color: Colors.blue, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "App Language".tr(),
                      style: const TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: ValueKey(currentLanguage),
                  initialValue: languages.any((l) => l['name'] == currentLanguage)
                      ? currentLanguage
                      : 'English',
                  dropdownColor: const Color(0xFF1A1632),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    fillColor: const Color(0xFF0F0C20),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                  ),
                  items: languages.map((lang) {
                    return DropdownMenuItem<String>(
                      value: lang['name'],
                      child: Text('${lang['flag']}   ${lang['name']?.tr()}'),
                    );
                  }).toList(),
                  onChanged: (selectedName) {
                    if (selectedName != null) {
                      final selectedLang = languages.firstWhere(
                        (l) => l['name'] == selectedName,
                        orElse: () => {'code': 'en'},
                      );
                      _updateLanguage(selectedName, selectedLang['code']!);
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _handleLogout(context),
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              label: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D1520),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.3)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String? val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15)),
          Text(
            val ?? "not_set".tr(),
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}