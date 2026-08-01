import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'login_screen.dart';
import 'setup_screen.dart';
import 'views/leaderboard_view.dart';
import 'views/test_view.dart';
import 'views/profile_view.dart';
 // for diff english and math modules
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
  Map<String, dynamic>? _topScorerProfile;
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
      await prefs.reload();
      
      final bool isSetupComplete = prefs.getBool('setupComplete') ?? false;

      if (!isSetupComplete) {
        _redirectToSetup();
        return;
      }
      // this is for our options 
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
  // this is for greeting the user acc to their timeline
  String _greetingPrefix() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'greeting_morning'.tr();
    if (hour < 17) return 'greeting_afternoon'.tr();
    return 'greeting_evening'.tr();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProfile) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2563EB),
            strokeWidth: 2.5,
          ),
        ),
      );
    }

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

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        resizeToAvoidBottomInset: false,
        body: IndexedStack(
          index: _activeTabIndex,
          children: tabPages.map((page) {
            return Navigator(
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (context) => page,
                );
              },
            );
          }).toList(),
        ),
        bottomNavigationBar: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.0)),
            ),
            child: SafeArea(
              top: false,
              bottom: true,
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
          ),
        ),
      ),
    );
  }
 // this for our leaderboard and it shows who got the highest score of the day
  Widget _buildDashboardTab() {
    final currentUser = _auth.currentUser;
    final userName = currentUser?.displayName ??
        currentUser?.email?.split('@').first ??
        "Learner";
    final String? userPhotoUrl = currentUser?.photoURL;

    final String heroName = _topScorerProfile?['userName'] ?? "No Scorer Today";
    final String? heroPhotoUrl = _topScorerProfile?['photoUrl'] ?? userPhotoUrl;
    final dynamic rawScore = _topScorerProfile?['score'] ?? 0;
    final String heroScoreText = rawScore == 0 ? "0" : "$rawScore";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 100.0),
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
                      backgroundImage: (heroPhotoUrl != null && heroPhotoUrl.isNotEmpty)
                          ? NetworkImage(heroPhotoUrl)
                          : null,
                      child: (heroPhotoUrl == null || heroPhotoUrl.isEmpty)
                          ? Text(
                              heroName.isNotEmpty && heroName != "No Scorer Today"
                                  ? heroName[0].toUpperCase()
                                  : 'N',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            heroName,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Highest score of the day",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          heroScoreText,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Text(
                          "out of 1600",
                          style: TextStyle(
                            fontSize: 11,
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
         // this is for my first math module
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
                    accentColor: const Color(0xFF2563EB),
                    badgeBgColor: const Color(0xFFEFF6FF),
                    onTap: () => _navigateToModule(const MathModule1()),
                  ),
                ),
              ),
              // this for my second math module
              const SizedBox(width: 14),
              Expanded(
                child: SizedBox(
                  height: 240,
                  child: _buildModuleTile(
                    categoryTag: "MATH:",
                    icon: Icons.square_foot_rounded,
                    title: "Module 2",
                    subtitle: "Geometry & Advanced Math",
                    accentColor: const Color(0xFF2563EB),
                    badgeBgColor: const Color(0xFFEFF6FF),
                    onTap: () => _navigateToModule(const MathModule2()),
                  ),
                ),
              ),
            ],
          ),
          // this is for my first english module
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
              // this is for my second english module
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