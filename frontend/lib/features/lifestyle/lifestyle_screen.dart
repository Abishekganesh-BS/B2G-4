import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../widgets/common/nurture_card.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NurtureColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: NurtureColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Lifestyle & Nutrition',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: NurtureColors.textPrimary,
              ),
            ),
          ),

          /// Nutrition Section
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: _SectionBadge(
                label: "Today's Nutrition",
                emoji: '🥗',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: _nutritionPlans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _PlanCard(plan: _nutritionPlans[i]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          /// Activity Section
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: _SectionBadge(
                label: 'Activity Plan',
                emoji: '🧘',
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList.separated(
              itemCount: _activityPlans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _PlanCard(plan: _activityPlans[i]),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

/// ── Data Model ─────────────────────────────────────────────

class _Plan {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final List<Color> gradient;
  final Color iconColor;

  const _Plan({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.gradient,
    required this.iconColor,
  });
}

/// ── Static Data ────────────────────────────────────────────

const _nutritionPlans = [
  _Plan(
    title: 'Breakfast',
    subtitle: 'Oatmeal with Blueberries & Walnuts',
    time: '8:00 AM',
    icon: Icons.breakfast_dining_rounded,
    gradient: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
    iconColor: Color(0xFFFB8C00),
  ),
  _Plan(
    title: 'Lunch',
    subtitle: 'Grilled Chicken Salad with Quinoa',
    time: '12:30 PM',
    icon: Icons.lunch_dining_rounded,
    gradient: [Color(0xFFE8F5E9), NurtureColors.successGreen],
    iconColor: NurtureColors.greenAccent,
  ),
  _Plan(
    title: 'Dinner',
    subtitle: 'Salmon with Steamed Vegetables',
    time: '7:00 PM',
    icon: Icons.dinner_dining_rounded,
    gradient: [Color(0xFFE8EAF6), Color(0xFFC5CAE9)],
    iconColor: Color(0xFF3949AB),
  ),
];

const _activityPlans = [
  _Plan(
    title: 'Prenatal Yoga',
    subtitle: '30 min · Gentle Flow',
    time: '5:00 PM',
    icon: Icons.self_improvement_rounded,
    gradient: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
    iconColor: Color(0xFF8E24AA),
  ),
  _Plan(
    title: 'Evening Walk',
    subtitle: '20 min · Light pace',
    time: '6:30 PM',
    icon: Icons.directions_walk_rounded,
    gradient: [Color(0xFFE1F5FE), NurtureColors.secondaryBlue],
    iconColor: NurtureColors.blueAccent,
  ),
];

/// ── Components ─────────────────────────────────────────────

class _SectionBadge extends StatelessWidget {
  final String label;
  final String emoji;

  const _SectionBadge({
    required this.label,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: NurtureColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final _Plan plan;

  const _PlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    return NurtureCard(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: plan.gradient,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(plan.icon, color: plan.iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: NurtureColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    plan.subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: NurtureColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                plan.time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: NurtureColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
