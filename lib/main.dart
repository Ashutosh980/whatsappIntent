import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

void main() {
  runApp(WhatsAppSchedulerApp());
}

class WhatsAppSchedulerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SchedulerHomePage(),
    );
  }
}

class SchedulerHomePage extends StatefulWidget {
  @override
  _SchedulerHomePageState createState() => _SchedulerHomePageState();
}

class _SchedulerHomePageState extends State<SchedulerHomePage> {
  final _phoneNumberController = TextEditingController();
  final _message1Controller = TextEditingController();
  final _message2Controller = TextEditingController();
  DateTime? _selectedDateTime;

  void _scheduleMessages() {
    if (_selectedDateTime == null) return;

    Timer(
      _selectedDateTime!.difference(DateTime.now()),
      () {
        _sendMessage(_phoneNumberController.text, _message1Controller.text);
        _sendMessage(_phoneNumberController.text, _message2Controller.text);
      },
    );
  }

  void _sendMessage(String phoneNumber, String message) async {
    String whatsappUrl = "https://api.whatsapp.com/send?phone=+91$phoneNumber&text=${Uri.encodeComponent(message)}";
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      print("Could not launch WhatsApp");
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp Scheduler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _message1Controller,
              decoration: InputDecoration(labelText: 'Message 1'),
            ),
            TextField(
              controller: _message2Controller,
              decoration: InputDecoration(labelText: 'Message 2'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text(
                _selectedDateTime == null
                    ? 'Select Date & Time'
                    : 'Scheduled for: ${_selectedDateTime.toString()}',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scheduleMessages,
              child: Text('Schedule Messages'),
            ),
          ],
        ),
      ),
    );
  }
}