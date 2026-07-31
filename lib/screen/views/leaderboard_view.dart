import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LeaderboardView extends StatelessWidget {
  final List<Map<String, dynamic>> allUsers;
  final List<Map<String, dynamic>> filteredUsers;
  final bool isLoading;
  final Function(String)? onSearchChanged;

  const LeaderboardView({
    super.key,
    required this.allUsers,
    required this.filteredUsers,
    required this.isLoading,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 4.0),
          child: Text(
            "global_leaderboard".tr(),
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "leaderboard_update_notice".tr(),
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, fontStyle: FontStyle.italic),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            style: const TextStyle(color: Colors.white),
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1A1632),
              hintText: "search_hint".tr(),
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.amber))
              : filteredUsers.isEmpty
                  ? Center(
                      child: Text(
                        "no_users_found".tr(),
                        style: const TextStyle(color: Colors.white54),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final userMap = filteredUsers[index];
                        final name = userMap['displayName'] ?? userMap['displayname'] ?? "Anonymous Learner";
                        final score = userMap['highestScore'] ?? 0;
                        final rank = allUsers.indexOf(filteredUsers[index]) + 1;

                        Color rankColor = const Color(0xFF94A3B8);
                        if (rank == 1) rankColor = Colors.amber;
                        if (rank == 2) rankColor = const Color(0xFFC0C0C0);
                        if (rank == 3) rankColor = const Color(0xFFCD7F32);

                        return Card(
                          color: const Color(0xFF1A1632),
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: rankColor.withValues(alpha: 0.2),
                              child: Text("#$rank", style: TextStyle(color: rankColor, fontWeight: FontWeight.bold)),
                            ),
                            title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              userMap['learningGoal'] ?? "SAT Prep",
                              style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A0813),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "$score ${'pts'.tr()}",
                                style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}