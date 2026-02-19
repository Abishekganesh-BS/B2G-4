import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/api_service.dart';

// Dashboard data holder
class DashboardData {
  final List<MetricData> glucoseHistory;
  final List<MetricData> weightHistory;
  final List<TeleSessionData> upcomingSessions;

  const DashboardData({
    this.glucoseHistory = const [],
    this.weightHistory = const [],
    this.upcomingSessions = const [],
  });
}

// Fetch all dashboard data in one provider
final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final api = ref.read(apiServiceProvider);
  try {
    final results = await Future.wait([
      api.getMetricHistory('glucose', days: 30),
      api.getMetricHistory('weight', days: 30),
      api.getUpcomingSessions(),
    ]);
    return DashboardData(
      glucoseHistory: results[0] as List<MetricData>,
      weightHistory: results[1] as List<MetricData>,
      upcomingSessions: results[2] as List<TeleSessionData>,
    );
  } catch (_) {
    // Return empty data if API calls fail (e.g., first-time user)
    return const DashboardData();
  }
});
