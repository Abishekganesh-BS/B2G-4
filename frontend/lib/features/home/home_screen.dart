import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../providers.dart';
import 'analytics_section.dart';
import 'calendar_section.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authServiceProvider);
    final dashboardAsync = ref.watch(dashboardProvider);
    final greeting = _getGreeting();
    final userName = authState.fullName ?? 'there';

    return Scaffold(
      body: dashboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (dashboard) => CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: Text('$greeting, $userName'),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to profile / settings
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => _ProfileSheet(
                        name: userName,
                        onLogout: () {
                          ref.read(authServiceProvider.notifier).logout();
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(Icons.person,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            // Dashboard grid
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _DashboardCard(
                    title: 'Metabolic',
                    subtitle: dashboard.glucoseHistory.isNotEmpty
                        ? '${dashboard.glucoseHistory.last.value.toStringAsFixed(0)} mg/dL'
                        : 'No data',
                    icon: Icons.monitor_heart_outlined,
                    color: Colors.pink.shade100,
                    onTap: () => context.go('/metabolic'),
                  ),
                  _DashboardCard(
                    title: 'Lifestyle',
                    subtitle: 'Plan Ready',
                    icon: Icons.spa_outlined,
                    color: Colors.green.shade100,
                    onTap: () => context.go('/lifestyle'),
                  ),
                  _DashboardCard(
                    title: 'Mental',
                    subtitle: 'Check-in',
                    icon: Icons.psychology_outlined,
                    color: Colors.blue.shade100,
                    onTap: () => context.go('/mental'),
                  ),
                  _DashboardCard(
                    title: 'Pediatric',
                    subtitle: dashboard.upcomingSessions.isNotEmpty
                        ? '${dashboard.upcomingSessions.length} upcoming'
                        : 'No sessions',
                    icon: Icons.child_care_outlined,
                    color: Colors.orange.shade100,
                    onTap: () => context.go('/pediatric'),
                  ),
                ],
              ),
            ),
            // AI Insight card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Text('AI Insight',
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dashboard.glucoseHistory.isNotEmpty
                              ? 'Your glucose trends are looking stable. Keep up the good work with your diet and exercise!'
                              : 'Start tracking your glucose and weight to get personalized AI insights here.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            // Analytics section
            SliverToBoxAdapter(
              child: AnalyticsSection(
                glucoseData: dashboard.glucoseHistory,
                weightData: dashboard.weightHistory,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            // Calendar section
            SliverToBoxAdapter(
              child: CalendarSection(sessions: dashboard.upcomingSessions),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _ProfileSheet extends StatelessWidget {
  final String name;
  final VoidCallback onLogout;

  const _ProfileSheet({required this.name, required this.onLogout});

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
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.person,
                  size: 40, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: onLogout,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, color: Colors.black87),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
