import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../app/theme.dart';
import '../../notifications/viewmodels/notification_view_model.dart';
import '../viewmodels/booking_view_model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _noteController = TextEditingController();
  String _service = 'Laptop repair';
  DateTime _date = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = context.watch<BookingViewModel>().bookings;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 820;
        final form = _BookingForm(
          service: _service,
          date: _date,
          noteController: _noteController,
          onServiceChanged: (value) => setState(() => _service = value),
          onPickDate: _pickDate,
          onSubmit: _submit,
        );
        final list = _BookingList(bookings: bookings);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: form),
                    const SizedBox(width: 16),
                    Expanded(child: list),
                  ],
                )
              : Column(children: [form, const SizedBox(height: 16), list]),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _submit() {
    context.read<BookingViewModel>().createBooking(
          service: _service,
          note: _noteController.text.trim().isEmpty ? 'No note' : _noteController.text.trim(),
          date: _date,
        );
    context.read<NotificationViewModel>().push(
          title: 'Service booking created',
          message: 'Your $_service appointment is scheduled.',
          type: 'Booking',
        );
    _noteController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Booking created successfully.')),
    );
  }
}

class _BookingForm extends StatelessWidget {
  const _BookingForm({
    required this.service,
    required this.date,
    required this.noteController,
    required this.onServiceChanged,
    required this.onPickDate,
    required this.onSubmit,
  });

  final String service;
  final DateTime date;
  final TextEditingController noteController;
  final ValueChanged<String> onServiceChanged;
  final VoidCallback onPickDate;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Book a tech service', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: service,
              decoration: const InputDecoration(labelText: 'Service type'),
              items: const [
                DropdownMenuItem(value: 'Laptop repair', child: Text('Laptop repair')),
                DropdownMenuItem(value: 'Phone screen replacement', child: Text('Phone screen replacement')),
                DropdownMenuItem(value: 'Device diagnostics', child: Text('Device diagnostics')),
                DropdownMenuItem(value: 'Software installation', child: Text('Software installation')),
              ],
              onChanged: (value) {
                if (value != null) onServiceChanged(value);
              },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Customer note',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            const SizedBox(height: 14),
            ListTile(
              tileColor: AppColors.lightGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              leading: const Icon(Icons.event_rounded, color: AppColors.primary),
              title: Text(DateFormat('EEEE, dd MMM yyyy').format(date)),
              trailing: TextButton(onPressed: onPickDate, child: const Text('Change')),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSubmit,
                icon: const Icon(Icons.add_circle_rounded),
                label: const Text('Create booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  const _BookingList({required this.bookings});

  final List<dynamic> bookings;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Scheduled bookings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 14),
            ...bookings.map(
              (booking) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  tileColor: AppColors.background,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.lightGreen,
                    child: Icon(Icons.build_rounded, color: AppColors.primary),
                  ),
                  title: Text(booking.service as String),
                  subtitle: Text('${DateFormat('dd MMM yyyy').format(booking.date as DateTime)} • ${booking.customerNote}'),
                  trailing: Chip(label: Text(booking.status as String)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
