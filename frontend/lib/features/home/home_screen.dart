import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../providers.dart';
import '../../theme.dart';
import '../../widgets/common/loading_shimmer.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/common/nurture_card.dart';
import 'analytics_section.dart';
import 'calendar_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authServiceProvider);
    final dashboardAsync = ref.watch(dashboardProvider);
    final greeting = _getGreeting();
    final userName = authState.fullName ?? 'there';

    return Scaffold(
      backgroundColor: NurtureColors.background,
      body: dashboardAsync.when(
        loading: () => const SafeArea(child: ShimmerDashboard()),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(dashboardProvider),
        ),
        data: (dashboard) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: NurtureColors.background,
              elevation: 0,
              titleSpacing: 24,
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: NurtureColors.textSecondary,
                          ),
                        ),
                        Text(
                          userName,
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: NurtureColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined),
                  ),
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => _ProfileSheet(
                        name: userName,
                        onLogout: () {
                          ref.read(authServiceProvider.notifier).logout();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            NurtureColors.primaryPink,
                            NurtureColors.secondaryBlue,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          userName.isNotEmpty
                              ? userName[0].toUpperCase()
                              : 'N',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Care Modules Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text(
                  'Care Modules',
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: NurtureColors.textPrimary,
                  ),
                ),
              ),
            ),

            /// Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.15,
                children: [
                  _FeatureCard(
                    title: 'Metabolic',
                    subtitle: dashboard.glucoseHistory.isNotEmpty
                        ? '${dashboard.glucoseHistory.last.value.toStringAsFixed(0)} mg/dL'
                        : 'Log your first reading',
                    icon: Icons.monitor_heart_rounded,
                    gradientColors: const [
                      Color(0xFFFCE4EC),
                      Color(0xFFF8BBD0)
                    ],
                    iconColor: NurtureColors.pinkAccent,
                    onTap: () => context.go('/metabolic'),
                  ),
                  _FeatureCard(
                    title: 'Lifestyle',
                    subtitle: 'Your plan is ready',
                    icon: Icons.spa_rounded,
                    gradientColors: const [
                      Color(0xFFE8F5E9),
                      NurtureColors.successGreen
                    ],
                    iconColor: NurtureColors.greenAccent,
                    onTap: () => context.go('/lifestyle'),
                  ),
                  _FeatureCard(
                    title: 'Mental',
                    subtitle: 'How are you feeling?',
                    icon: Icons.psychology_rounded,
                    gradientColors: const [
                      Color(0xFFE1F5FE),
                      NurtureColors.secondaryBlue
                    ],
                    iconColor: NurtureColors.blueAccent,
                    onTap: () => context.go('/mental'),
                  ),
                  _FeatureCard(
                    title: 'Pediatric',
                    subtitle: dashboard.upcomingSessions.isNotEmpty
                        ? '${dashboard.upcomingSessions.length} upcoming'
                        : 'Track baby growth',
                    icon: Icons.child_care_rounded,
                    gradientColors: const [
                      Color(0xFFFFF8E1),
                      Color(0xFFFFECB3)
                    ],
                    iconColor: const Color(0xFFFFA726),
                    onTap: () => context.go('/pediatric'),
                  ),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverToBoxAdapter(
              child: AnalyticsSection(
                glucoseData: dashboard.glucoseHistory,
                weightData: dashboard.weightHistory,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            SliverToBoxAdapter(
              child: CalendarSection(
                sessions: dashboard.upcomingSessions,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradientColors;
  final Color iconColor;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradientColors,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.75),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w700,
                    color: NurtureColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: NurtureColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSheet extends StatelessWidget {
  final String name;
  final VoidCallback onLogout;

  const _ProfileSheet({
    required this.name,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : 'N',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}
