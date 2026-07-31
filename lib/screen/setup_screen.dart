import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Leaderboard')),
    const Center(child: Text('Test')),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'home_nav'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.leaderboard_outlined),
            activeIcon: const Icon(Icons.leaderboard),
            label: 'leaderboard_nav'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment),
            label: 'test_nav'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'profile_nav'.tr(),
          ),
        ],
      ),
    );
  }
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final pageController = PageController();
  int currentStep = 1;
  bool isSaving = false;

  String? pickedLanguage;
  String? gradeLevel;
  String? schoolSystem;
  String? homeCountry;
  String? studyStyle;
  String? dailyTime;
  String? goalScore;

  final languages = [
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

  final grades = [
    'grade_class_9',
    'grade_class_10',
    'grade_class_11',
    'grade_class_12',
    'grade_gap_year',
  ];

  final schools = [
    'school_neb',
    'school_ib',
    'school_cbse',
    'school_icse',
    'school_cambridge',
    'school_us_diploma',
    'school_bise',
    'school_bangladesh',
    'school_french',
    'school_australia',
    'school_arab',
    'school_vietnam',
    'school_waec',
    'school_other',
  ];

  final countries = [
    'Afghanistan', 'Algeria', 'Argentina', 'Australia', 'Bangladesh',
    'Brazil', 'Canada', 'China', 'Egypt', 'France', 'Germany', 'India',
    'Indonesia', 'Iran', 'Italy', 'Japan', 'Malaysia', 'Mexico', 'Morocco',
    'Nepal', 'Netherlands', 'Nigeria', 'Pakistan', 'Philippines', 'Poland',
    'Portugal', 'Russia', 'South Korea', 'Spain', 'Sri Lanka', 'Thailand',
    'Turkey', 'Ukraine', 'United Arab Emirates', 'United Kingdom',
    'United States', 'Vietnam', 'Other',
  ];

  final styles = [
    'style_practical',
    'style_theory',
    'style_visual',
    'style_step',
  ];

  final paces = [
    'pace_15_mins',
    'pace_30_mins',
    'pace_45_mins',
    'pace_1_hour',
  ];

  final scores = [
    'score_1200_1300',
    'score_1300_1400',
    'score_1400_1500',
    'score_1500_1600',
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void showSnack(String msgKey) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msgKey.tr()), behavior: SnackBarBehavior.floating),
    );
  }

  void onNext() {
    if (currentStep == 1) {
      if (pickedLanguage == null) {
        showSnack('pick_lang_snack');
        return;
      }
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
      return;
    }

    if (gradeLevel == null || schoolSystem == null || homeCountry == null ||
        studyStyle == null || dailyTime == null || goalScore == null) {
      showSnack('fill_choices_snack');
      return;
    }

    saveAndFinish();
  }

  Future<void> saveAndFinish() async {
    setState(() => isSaving = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('educationLevel', gradeLevel ?? '');
      await prefs.setString('educationSystem', schoolSystem ?? '');
      await prefs.setString('countryOrigin', homeCountry ?? '');
      await prefs.setString('appLanguage', pickedLanguage ?? '');
      await prefs.setString('learningStyle', studyStyle ?? '');
      await prefs.setString('dailyCommitment', dailyTime ?? '');
      await prefs.setString('targetSatScore', goalScore ?? '');
      await prefs.setBool('setupComplete', true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    } catch (e) {
      showSnack('error_snack');
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: currentStep == 2 && !isSaving
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                onPressed: () => pageController.previousPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn,
                ),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
              child: Text(
                'Step $currentStep of 2',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: isSaving
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2563EB)))
            : Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF2563EB),
                        child: Text('1', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        width: 45,
                        height: 2,
                        color: currentStep == 2 ? const Color(0xFF2563EB) : Colors.grey.shade300,
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: currentStep == 2 ? const Color(0xFF2563EB) : Colors.white,
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: currentStep == 2 ? Colors.white : Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (page) => setState(() => currentStep = page + 1),
                      children: [
                        buildLanguagePicker(),
                        buildProfileForm(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: onNext,
                        child: Text(
                          currentStep == 1 ? 'continue_btn'.tr() : 'finish_setup_btn'.tr(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget buildLanguagePicker() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'welcome_title'.tr(),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          Text(
            'welcome_subtitle'.tr(),
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.3,
            ),
            itemCount: languages.length,
            itemBuilder: (context, i) {
              final lang = languages[i];
              final name = lang['name']!;
              final flag = lang['flag']!;
              final code = lang['code']!;
              final picked = pickedLanguage == name;

              return InkWell(
                onTap: () {
                  setState(() {
                    pickedLanguage = name;
                  });
                  context.setLocale(Locale(code));
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: picked ? const Color(0xFF2563EB) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: picked ? Colors.transparent : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(flag, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: picked ? Colors.white : const Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildProfileForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'setup_title'.tr(),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'setup_subtitle'.tr(),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          buildDropdown('current_grade_label'.tr(), 'current_grade_sub'.tr(), grades, gradeLevel, (v) => setState(() => gradeLevel = v)),
          buildDropdown('school_system_label'.tr(), 'school_system_sub'.tr(), schools, schoolSystem, (v) => setState(() => schoolSystem = v)),
          buildDropdown('country_label'.tr(), 'country_sub'.tr(), countries, homeCountry, (v) => setState(() => homeCountry = v)),
          buildDropdown('learning_style_label'.tr(), 'learning_style_sub'.tr(), styles, studyStyle, (v) => setState(() => studyStyle = v)),
          buildDropdown('daily_goal_label'.tr(), 'daily_goal_sub'.tr(), paces, dailyTime, (v) => setState(() => dailyTime = v)),
          buildDropdown('target_score_label'.tr(), 'target_score_sub'.tr(), scores, goalScore, (v) => setState(() => goalScore = v)),
        ],
      ),
    );
  }

  Widget buildDropdown(String label, String hint, List<String> options, String? value, ValueChanged<String?> onChanged) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 2),
            Text(hint, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: value,
              hint: Text('choose_option_hint'.tr(), style: const TextStyle(fontSize: 14)),
              decoration: InputDecoration(
                fillColor: const Color(0xFFF8FAFC),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              items: options.map((e) {
                final displayText = countries.contains(e) ? e : e.tr();
                return DropdownMenuItem(
                  value: e, 
                  child: Text(displayText, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}