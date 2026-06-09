class BookingViewModel {
  final List<String> serviceBookings = <String>[];

  final List<String> availableServices = <String>[
    'Laptop Repair',
    'Phone Repair',
    'Software Installation',
    'Data Recovery',
    'Device Cleaning',
    'Smart Watch Setup',
    'Gaming PC Setup',
  ];

  bool validateBooking({
    required String fullName,
    required String phone,
    required String date,
  }) {
    return fullName.trim().isNotEmpty &&
        phone.trim().isNotEmpty &&
        date.trim().isNotEmpty;
  }

  String createBookingText({
    required String selectedService,
    required String fullName,
    required String date,
  }) {
    return '$selectedService for ${fullName.trim()} - ${date.trim()}';
  }

  void addBooking(String booking) {
    serviceBookings.insert(0, booking);
  }
}

