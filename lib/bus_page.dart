import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BusPage extends StatefulWidget {
  @override
  _BusPageState createState() => _BusPageState();
}

class _BusPageState extends State<BusPage> {
  String selectedDay = _getTodayDay();

  // Bus schedules
  final Map<String, List<String>> startingBuses = {
    'Sun': ['08:00', '09:00', '10:00', '11:15'],
    'Mon': ['08:00', '09:00', '10:00', '11:15'],
    'Tue': ['08:00', '09:00', '10:00', '11:15'],
    'Wed': ['08:00', '09:00', '10:00', '11:15'],
    'Thu': ['08:00', '09:00', '10:00', '11:15'],
    'Fri': ['08:00', '09:00', '10:00'],
    'Sat': ['08:00', '09:00', '10:00', '11:15'],
  };

  final Map<String, List<String>> returningBuses = {
    'Sun': ['11:20', '12:30', '14:00', '15:10', '16:20'],
    'Mon': ['11:20', '12:30', '14:00', '15:10', '16:20'],
    'Tue': ['11:20', '12:30', '14:00', '15:10', '16:20'],
    'Wed': ['11:20', '12:30', '14:00', '15:10', '16:20'],
    'Thu': ['11:20', '12:30', '14:00', '15:10', '16:20'],
    'Fri': ['11:15', '15:10', '16:20'],
    'Sat': ['12:30', '15:10', '16:20'],
  };

  // Convert string "HH:mm" to DateTime today
  DateTime _parseBusTime(String timeStr) {
    final now = DateTime.now();
    final parts = timeStr.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  // Find next bus time
  String? _nextBus(List<String> times) {
    final now = DateTime.now();
    for (var t in times) {
      final busTime = _parseBusTime(t);
      if (busTime.isAfter(now)) return t;
    }
    return null;
  }

  // Countdown in minutes
  String _countdown(String timeStr) {
    final now = DateTime.now();
    final busTime = _parseBusTime(timeStr);
    final diff = busTime.difference(now);
    if (diff.isNegative) return '';
    return '${diff.inMinutes} min';
  }

  @override
  Widget build(BuildContext context) {
    final startingList = startingBuses[selectedDay]!;
    final returningList = returningBuses[selectedDay]!;

    final nextStart = _nextBus(startingList);
    final nextReturn = _nextBus(returningList);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Bus Schedule',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.grey[100], // Keep light gray background
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black, // Text and icons black
        automaticallyImplyLeading: false, // remove back button if any
        shadowColor: Colors.transparent, // remove any default shadow
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Horizontal day bar
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((
                day,
              ) {
                bool isSelected = day == selectedDay;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? Colors.black26 : Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 10),
          // Next bus cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.green[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(
                            Icons.directions_bus,
                            size: 30,
                            color: Colors.green,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Next Starting Bus',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            nextStart ?? 'No Bus',
                            style: TextStyle(fontSize: 16),
                          ),
                          if (nextStart != null)
                            Text(
                              _countdown(nextStart),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Card(
                    color: Colors.orange[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(
                            Icons.directions_bus,
                            size: 30,
                            color: Colors.orange,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Next Returning Bus',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            nextReturn ?? 'No Bus',
                            style: TextStyle(fontSize: 16),
                          ),
                          if (nextReturn != null)
                            Text(
                              _countdown(nextReturn),
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Bus schedule list
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                for (var t in startingList) _buildBusCard('Starting Bus', t),
                for (var t in returningList) _buildBusCard('Returning Bus', t),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusCard(String type, String time) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.directions_bus,
              size: 30,
              color: type.contains('Starting') ? Colors.green : Colors.orange,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                '$type: $time',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Get today’s day as Sun, Mon...
  static String _getTodayDay() {
    final now = DateTime.now();
    switch (now.weekday) {
      case DateTime.sunday:
        return 'Sun';
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      default:
        return 'Mon';
    }
  }
}
