import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Birth Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _todayDateController;
  late TextEditingController _selectedDateController;
  Map<String, int>? age;

  @override
  void initState() {
    super.initState();
    _todayDateController =
        TextEditingController(text: _getFormattedDate(DateTime.now()));
    _selectedDateController = TextEditingController();
  }

  String _getFormattedDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _selectedDateController.text = _getFormattedDate(picked);
        calculateAge(picked);
      });
    }
  }

  void calculateAge(DateTime selectedDate) {
    final today = DateTime.now();
    final difference = today.difference(selectedDate);
    final ageInDays = difference.inDays;

    final years = ageInDays ~/ 365;
    final remainingDays = ageInDays % 365;
    final months = remainingDays ~/ 30;
    final days = remainingDays % 30;

    setState(() {
      age = {
        'years': years,
        'months': months,
        'days': days,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todayDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Today\'s Date',
                labelStyle: TextStyle(color: Colors.green),
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _selectedDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Selected Date',
                labelStyle: TextStyle(color: Colors.blue),
              ),
            ),
            if (age != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Age: ${age!['years']} years, ${age!['months']} months, ${age!['days']} days',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
          ],
        ),
      ),
    );
  }
}
