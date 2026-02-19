import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../../widgets/common/nurture_card.dart';
import '../../widgets/common/nurture_button.dart';

class MetabolicScreen extends ConsumerWidget {
  const MetabolicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              'Metabolic Health',
              style: GoogleFonts.nunito(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: NurtureColors.textPrimary,
              ),
            ),
          ),

          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            sliver: SliverToBoxAdapter(child: _MetricInputCard()),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'Current Status',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: NurtureColors.textPrimary,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.separated(
              itemCount: _statusCards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) =>
                  _TrafficLightCard(data: _statusCards[i]),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'Glucose Trends',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: NurtureColors.textPrimary,
                ),
              ),
            ),
          ),

          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 40),
            sliver: SliverToBoxAdapter(child: _TrendChartPlaceholder()),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _StatusData {
  final String label;
  final String value;
  final String range;
  final String status;
  final IconData icon;

  const _StatusData({
    required this.label,
    required this.value,
    required this.range,
    required this.status,
    required this.icon,
  });
}

const _statusCards = [
  _StatusData(
    label: 'Fasting Glucose',
    value: '95 mg/dL',
    range: 'Normal: 70–99 mg/dL',
    status: 'green',
    icon: Icons.water_drop_outlined,
  ),
  _StatusData(
    label: 'Post-meal Glucose',
    value: '148 mg/dL',
    range: 'Target: <140 mg/dL',
    status: 'yellow',
    icon: Icons.restaurant_outlined,
  ),
  _StatusData(
    label: 'HbA1c',
    value: '6.8%',
    range: 'Target: <6.5%',
    status: 'red',
    icon: Icons.biotech_outlined,
  ),
];

// ─────────────────────────────────────────────────────────────

class _MetricInputCard extends StatefulWidget {
  const _MetricInputCard();

  @override
  State<_MetricInputCard> createState() => _MetricInputCardState();
}

class _MetricInputCardState extends State<_MetricInputCard> {
  final _glucoseCtrl = TextEditingController();

  @override
  void dispose() {
    _glucoseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NurtureCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Log New Reading',
            style: GoogleFonts.nunito(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: NurtureColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _glucoseCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Glucose Level',
              suffixText: 'mg/dL',
              prefixIcon: Icon(Icons.water_drop_outlined),
            ),
          ),
          const SizedBox(height: 16),
          NurtureButton(
            label: 'Save Reading',
            icon: Icons.check_rounded,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _TrafficLightCard extends StatelessWidget {
  final _StatusData data;

  const _TrafficLightCard({required this.data});

  Color get _statusColor {
    switch (data.status) {
      case 'green':
        return NurtureColors.statusGreen;
      case 'yellow':
        return NurtureColors.statusYellow;
      default:
        return NurtureColors.statusRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _statusColor.withOpacity(0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Icon(data.icon, color: _statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${data.label}\n${data.range}',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: NurtureColors.textPrimary,
              ),
            ),
          ),
          Text(
            data.value,
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _statusColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _TrendChartPlaceholder extends StatelessWidget {
  const _TrendChartPlaceholder();

  @override
  Widget build(BuildContext context) {
    return NurtureCard(
      padding: const EdgeInsets.all(20),
      child: Container(
        height: 160,
        alignment: Alignment.center,
        child: Text(
          'Log readings to see your trend',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: NurtureColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
