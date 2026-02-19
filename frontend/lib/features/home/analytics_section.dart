import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AnalyticsSection extends StatelessWidget {
  final List<MetricData> glucoseData;
  final List<MetricData> weightData;

  const AnalyticsSection({
    super.key,
    required this.glucoseData,
    required this.weightData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Health Analytics',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        if (glucoseData.isEmpty && weightData.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.show_chart,
                          size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'No data yet',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your health trends will appear here once you start logging metrics.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        else ...[
          if (glucoseData.isNotEmpty)
            _buildChartCard(
              context,
              title: 'Glucose (mg/dL)',
              data: glucoseData,
              color: Colors.pink.shade400,
              gradientColor: Colors.pink.shade100,
            ),
          if (weightData.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildChartCard(
              context,
              title: 'Weight (kg)',
              data: weightData,
              color: Colors.teal.shade400,
              gradientColor: Colors.teal.shade100,
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildChartCard(
    BuildContext context, {
    required String title,
    required List<MetricData> data,
    required Color color,
    required Color gradientColor,
  }) {
    final spots = data.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.value);
    }).toList();

    final minY = data.map((e) => e.value).reduce((a, b) => a < b ? a : b) * 0.9;
    final maxY = data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration:
                        BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(title,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text('${data.length} readings',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: (maxY - minY) / 4,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 42,
                          getTitlesWidget: (value, meta) => Text(
                            value.toStringAsFixed(0),
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                      bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: color,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: data.length <= 15,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 3,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: color,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          color: gradientColor.withOpacity(0.3),
                        ),
                      ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (spots) => spots
                            .map((s) => LineTooltipItem(
                                  s.y.toStringAsFixed(1),
                                  TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
