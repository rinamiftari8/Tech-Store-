import 'package:tech_store/modules/calendar/models/calendar_event.dart';

class CalendarViewModel {
  final List<CalendarEvent> events = <CalendarEvent>[
    const CalendarEvent(
      id: 1,
      title: 'Product delivery',
      date: '2026-06-05',
      time: '10:00',
      description: 'Scheduled delivery for customer tech products.',
    ),
    const CalendarEvent(
      id: 2,
      title: 'Laptop repair booking',
      date: '2026-06-06',
      time: '13:30',
      description: 'Service appointment for laptop repair.',
    ),
    const CalendarEvent(
      id: 3,
      title: 'Inventory review',
      date: '2026-06-07',
      time: '16:00',
      description: 'Review stock for phones, drones, laptops and accessories.',
    ),
  ];

  List<CalendarEvent> get allEvents {
    return events;
  }

  int get totalEvents {
    return events.length;
  }

  void addEvent({
    required String title,
    required String date,
    required String time,
    required String description,
  }) {
    events.insert(
      0,
      CalendarEvent(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        date: date,
        time: time,
        description: description,
      ),
    );
  }
}

