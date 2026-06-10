class Booking {
  const Booking({
    required this.id,
    required this.service,
    required this.customerNote,
    required this.date,
    required this.status,
  });

  final String id;
  final String service;
  final String customerNote;
  final DateTime date;
  final String status;
}
