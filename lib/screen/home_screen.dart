import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_screen.dart';
import 'setup_screen.dart';
import 'views/leaderboard_view.dart';
import 'views/test_view.dart';
import 'views/profile_view.dart';

// for diff modules for math and english
import 'math_module1.dart';
import 'math_module2.dart';
import 'english_module1.dart';
import 'english_module2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoadingProfile = true;
  Map<String, dynamic>? _userProfile;
  int _activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _syncUserProfile();
  }

  Future<void> _syncUserProfile() async {
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      _redirectToLogin();
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final bool isSetupComplete = prefs.getBool('setupComplete') ?? false;

      if (!isSetupComplete) {
        _redirectToSetup();
        return;
      }

      final profileData = {
        'educationLevel': prefs.getString('educationLevel') ?? '',
        'educationSystem': prefs.getString('educationSystem') ?? '',
        'countryOrigin': prefs.getString('countryOrigin') ?? '',
        'appLanguage': prefs.getString('appLanguage') ?? '',
        'learningStyle': prefs.getString('learningStyle') ?? '',
        'dailyCommitment': prefs.getString('dailyCommitment') ?? '',
        'targetSatScore': prefs.getString('targetSatScore') ?? '',
        'setupComplete': true,
      };

      if (mounted) {
        setState(() {
          _userProfile = profileData;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      debugPrint('Error pulling user profile: $e');
      _redirectToSetup();
    }
  }

  void _redirectToLogin() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _redirectToSetup() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SetupScreen()),
    );
  }

  String _greetingPrefix() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'greeting_morning'.tr();
    if (hour < 17) return 'greeting_afternoon'.tr();
    return 'greeting_evening'.tr();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabPages = [
      _buildDashboardTab(),
      LeaderboardView(
        allUsers: const [],
        filteredUsers: const [],
        isLoading: false,
        onSearchChanged: (query) {},
      ),
      const TestView(),
      ProfileView(profile: _userProfile),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: _isLoadingProfile
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2563EB),
                  strokeWidth: 2.5,
                ),
              )
            : tabPages[_activeTabIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.0)),
        ),
        child: BottomNavigationBar(
          currentIndex: _activeTabIndex,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: const Color(0xFF94A3B8),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          onTap: (index) => setState(() => _activeTabIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.grid_view_rounded),
              label: 'home_nav'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_rounded),
              label: 'leaderboard_nav'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.assignment_rounded),
              label: 'test_nav'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline_rounded),
              label: 'profile_nav'.tr(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    final userName = _auth.currentUser?.displayName ??
        _auth.currentUser?.email?.split('@').first ??
        "Learner";

    const Color defaultAccent = Color(0xFF2563EB);
    const Color defaultBadgeBg = Color(0xFFEFF6FF);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_greetingPrefix()}, $userName ',
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            'sat_goal_sub'.tr(),
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 48),

          Transform.translate(
            offset: const Offset(-8, 0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E40AF), Color(0xFF2563EB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : 'L',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ready to Practice?",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Target: ${_userProfile?['targetSatScore'] ?? '1400+'}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.85),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "SAT",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "Ready",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF93C5FD),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 240, 
                  child: _buildModuleTile(
                    categoryTag: "MATH:",
                    icon: Icons.functions_rounded, 
                    title: "Module 1",
                    subtitle: "Algebra & Linear Functions",
                    accentColor: defaultAccent,
                    badgeBgColor: defaultBadgeBg,
                    onTap: () => _navigateToModule(const MathModule1()),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 240,
                  child: _buildModuleTile(
                    categoryTag: "MATH:",
                    icon: Icons.square_foot_rounded, 
                    title: "Module 2",
                    subtitle: "Geometry & Advanced Math",
                    accentColor: defaultAccent,
                    badgeBgColor: defaultBadgeBg,
                    onTap: () => _navigateToModule(const MathModule2()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 240, 
                  child: _buildModuleTile(
                    categoryTag: "READING & WRITING",
                    icon: Icons.auto_stories_rounded,
                    title: "Module 1",
                    subtitle: "Reading & Vocabulary",
                    accentColor: const Color.fromARGB(255, 235, 116, 37),
                    badgeBgColor: const Color.fromARGB(255, 250, 234, 200),
                    onTap: () => _navigateToModule(const EnglishModule1()),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 240, 
                  child: _buildModuleTile(
                    categoryTag: "READING & WRITING",
                    icon: Icons.edit_note_rounded,
                    title: "Module 2",
                    subtitle: "Grammar & Expression",
                    accentColor: const Color.fromARGB(255, 235, 116, 37),
                    badgeBgColor: const Color.fromARGB(255, 250, 234, 200),
                    onTap: () => _navigateToModule(const EnglishModule2()),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToModule(Widget destinationScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destinationScreen),
    );
  }

  Widget _buildModuleTile({
    required String categoryTag,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    required Color badgeBgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: accentColor.withValues(alpha: 0.05),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        categoryTag,
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: accentColor,
                      ),
                    ),
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}