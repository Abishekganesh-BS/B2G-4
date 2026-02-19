import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../widgets/common/nurture_card.dart';
import '../../widgets/common/nurture_button.dart';

class PediatricScreen extends StatelessWidget {
  const PediatricScreen({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NurtureColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ────────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: NurtureColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Pediatric Care',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: NurtureColors.textPrimary,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: NurtureButton(
                  label: 'Log Vitals',
                  icon: Icons.add_rounded,
                  onPressed: () {},
                  width: 120,
                  height: 40,
                ),
              ),
            ],
          ),

          // ── Baby Growth Card ───────────────────────────────────────────────
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(child: _BabyGrowthCard()),
          ),

          // ── Stats Row ─────────────────────────────────────────────────────
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(child: _GrowthStatsRow()),
          ),

          // ── Vaccination Section ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'Vaccination Schedule',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: NurtureColors.textPrimary,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverList.separated(
              itemCount: _vaccinations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _VaccinationCard(data: _vaccinations[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Static data ───────────────────────────────────────────────────────────────

class _VaxData {
  final String name;
  final String dueDate;
  final String status; // 'done' | 'upcoming' | 'overdue'
  final String dose;

  const _VaxData({
    required this.name,
    required this.dueDate,
    required this.status,
    required this.dose,
  });
}

const _vaccinations = [
  _VaxData(
    name: 'Hepatitis B',
    dueDate: 'Completed Jan 10, 2026',
    status: 'done',
    dose: '1st Dose',
  ),
  _VaxData(
    name: 'DTaP',
    dueDate: 'Due Mar 15, 2026',
    status: 'upcoming',
    dose: '2nd Dose',
  ),
  _VaxData(
    name: 'Rotavirus',
    dueDate: 'Due Mar 15, 2026',
    status: 'upcoming',
    dose: '2nd Dose',
  ),
  _VaxData(
    name: 'PCV13',
    dueDate: 'Overdue since Feb 1, 2026',
    status: 'overdue',
    dose: '2nd Dose',
  ),
];

// ── Components ────────────────────────────────────────────────────────────────

class _BabyGrowthCard extends StatelessWidget {
  const _BabyGrowthCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC), Color(0xFFE8F5E9)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1229B6F6),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -16,
            top: -16,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '👶 Baby Growth',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: NurtureColors.blueAccent,
                    ),
                  ),
                ),
                // Growth curve visualization
                CustomPaint(
                  size: const Size(double.infinity, 60),
                  painter: _GrowthCurvePainter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthStatsRow extends StatelessWidget {
  const _GrowthStatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
            child: _StatPill(label: 'Weight', value: '7.2 kg', emoji: '⚖️')),
        SizedBox(width: 10),
        Expanded(
            child: _StatPill(label: 'Height', value: '65 cm', emoji: '📏')),
        SizedBox(width: 10),
        Expanded(
            child: _StatPill(
                label: 'Head Circ.', value: '42 cm', emoji: '🔵')),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StatPill(
      {required this.label, required this.value, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return NurtureCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: NurtureColors.blueAccent,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: NurtureColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccinationCard extends StatelessWidget {
  final _VaxData data;

  const _VaccinationCard({required this.data});

  Color get _statusColor {
    switch (data.status) {
      case 'done':
        return NurtureColors.statusGreen;
      case 'upcoming':
        return NurtureColors.statusYellow;
      default:
        return NurtureColors.statusRed;
    }
  }

  Color get _bgColor {
    switch (data.status) {
      case 'done':
        return const Color(0xFFE8F5E9);
      case 'upcoming':
        return const Color(0xFFFFF8E1);
      default:
        return const Color(0xFFFFEBEE);
    }
  }

  IconData get _statusIcon {
    switch (data.status) {
      case 'done':
        return Icons.check_circle_rounded;
      case 'upcoming':
        return Icons.access_time_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  String get _statusLabel {
    switch (data.status) {
      case 'done':
        return 'Completed';
      case 'upcoming':
        return 'Upcoming';
      default:
        return 'Overdue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: _statusColor.withOpacity(0.3), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.vaccines_rounded, color: _statusColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: NurtureColors.textPrimary,
                  ),
                ),
                Text(
                  data.dueDate,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: NurtureColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_statusIcon, color: _statusColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      _statusLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.dose,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: NurtureColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Growth curve custom painter ───────────────────────────────────────────────

class _GrowthCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Gradient paint for the curve
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [NurtureColors.blueAccent, NurtureColors.greenAccent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.85);
    path.cubicTo(
      size.width * 0.25, size.height * 0.7,
      size.width * 0.5, size.height * 0.45,
      size.width, size.height * 0.15,
    );

    canvas.drawPath(path, paint);

    // Endpoint dot
    final dotPaint = Paint()
      ..color = NurtureColors.blueAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width, size.height * 0.15), 5, dotPaint);

    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
        Offset(size.width, size.height * 0.15), 8, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pediatric Management')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('Log Vitals'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _InfoCard(
              title: "Baby's Growth",
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomPaint(
                      painter: _GrowthChartPainter(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(label: 'Weight', value: '7.2 kg'),
                      _StatItem(label: 'Height', value: '65 cm'),
                      _StatItem(label: 'Head Circ.', value: '42 cm'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              title: "Upcoming Vaccinations",
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ListTile(
                    leading: Icon(Icons.vaccines, color: Colors.teal),
                    title: Text('DTaP (2nd Dose)'),
                    subtitle: Text('Due: March 15, 2026'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.vaccines, color: Colors.teal),
                    title: Text('Rotavirus'),
                    subtitle: Text('Due: March 15, 2026'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            child,
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _GrowthChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.6, size.width, size.height * 0.2);

    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = Colors.blue;
    canvas.drawCircle(Offset(size.width, size.height * 0.2), 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
