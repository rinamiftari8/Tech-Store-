import 'package:flutter/foundation.dart';

import '../models/booking.dart';

class BookingViewModel extends ChangeNotifier {
  final List<Booking> _bookings = [
    Booking(
      id: 'BK-1001',
      service: 'Laptop diagnostics',
      customerNote: 'Battery drains quickly.',
      date: DateTime.now().add(const Duration(days: 1)),
      status: 'Scheduled',
    ),
  ];

  List<Booking> get bookings => List.unmodifiable(_bookings);

  void createBooking({
    required String service,
    required String note,
    required DateTime date,
  }) {
    _bookings.insert(
      0,
      Booking(
        id: 'BK-${DateTime.now().millisecondsSinceEpoch}',
        service: service,
        customerNote: note,
        date: date,
        status: 'Scheduled',
      ),
    );
    notifyListeners();
  }
}
