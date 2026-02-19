import 'package:flutter/material.dart';

class LifestyleScreen extends StatelessWidget {
  const LifestyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lifestyle & Nutrition')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader(title: 'Today\'s Nutrition'),
          const SizedBox(height: 12),
          _PlanCard(
            title: 'Breakfast',
            subtitle: 'Oatmeal with Blueberries & Walnuts',
            icon: Icons.breakfast_dining,
            color: Colors.orange.shade50,
            time: '8:00 AM',
          ),
          const SizedBox(height: 12),
          _PlanCard(
            title: 'Lunch',
            subtitle: 'Grilled Chicken Salad with Quinoa',
            icon: Icons.lunch_dining,
            color: Colors.green.shade50,
            time: '12:30 PM',
          ),
          const SizedBox(height: 24),
          const _SectionHeader(title: 'Activity Plan'),
          const SizedBox(height: 12),
          _PlanCard(
            title: 'Prenatal Yoga',
            subtitle: '30 min • Gentle Flow',
            icon: Icons.self_improvement,
            color: Colors.purple.shade50,
            time: '5:00 PM',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.headlineSmall);
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String time;

  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      borderOnForeground: false,
      elevation: 0,
      child: ListTile(
        leading: Icon(icon, color: Colors.black87),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(time, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
