import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/api_service.dart';

class CalendarSection extends StatefulWidget {
  final List<TeleSessionData> sessions;

  const CalendarSection({super.key, required this.sessions});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<TeleSessionData> _getEventsForDay(DateTime day) {
    return widget.sessions.where((s) {
      return s.scheduledAt.year == day.year &&
          s.scheduledAt.month == day.month &&
          s.scheduledAt.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedEvents = _selectedDay != null
        ? _getEventsForDay(_selectedDay!)
        : <TeleSessionData>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Appointments',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar<TeleSessionData>(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: theme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                  markerSize: 6,
                  markersMaxCount: 3,
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() => _calendarFormat = format);
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ),
        ),
        // Show selected day's sessions
        if (selectedEvents.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...selectedEvents.map((session) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Card(
                  color: theme.colorScheme.secondaryContainer,
                  child: ListTile(
                    leading: Icon(Icons.videocam,
                        color: theme.colorScheme.secondary),
                    title: Text(session.title,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${session.scheduledAt.hour.toString().padLeft(2, '0')}:${session.scheduledAt.minute.toString().padLeft(2, '0')}',
                    ),
                    trailing: session.notes != null
                        ? Tooltip(
                            message: session.notes!,
                            child: const Icon(Icons.info_outline))
                        : null,
                  ),
                ),
              )),
        ] else if (_selectedDay != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text('No appointments on this day',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.grey)),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
