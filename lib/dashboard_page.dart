import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bus_page.dart';
import 'event_model.dart'; // Import your Hive model

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Map<String, List<Map<String, String>>> weeklyClasses = {
    "Monday": [
      {"course": "Microprocessors Sessional", "time": "08:00 AM - 09:00 AM", "room": "Lab 101"},
      {"course": "Computer Networks", "time": "09:15 AM - 10:15 AM", "room": "Room 202"},
      {"course": "Management", "time": "10:30 AM - 11:30 AM", "room": "Room 305"},
      {"course": "Computer Networks Sessional", "time": "11:45 AM - 12:45 PM", "room": "Lab 102"},
    ],
    "Tuesday": [
      {"course": "Database Systems", "time": "08:00 AM - 09:00 AM", "room": "Room 201"},
      {"course": "Operating Systems", "time": "09:15 AM - 10:15 AM", "room": "Room 202"},
      {"course": "Software Engineering", "time": "10:30 AM - 11:30 AM", "room": "Room 303"},
    ],
    "Wednesday": [],
    "Thursday": [],
    "Friday": [],
    "Saturday": [],
    "Sunday": [],
  };

  final Map<String, Map<String, String>> startingBusSchedule = {
    "Monday": {"time": "08:00 AM"},
    "Tuesday": {"time": "08:15 AM"},
  };

  final Map<String, Map<String, String>> returningBusSchedule = {
    "Monday": {"time": "04:00 PM"},
    "Tuesday": {"time": "04:20 PM"},
  };

  Color categoryColor(String cat) {
    switch (cat) {
      case "Tutorial":
        return Colors.orange;
      case "Presentation":
        return Colors.purple;
      case "Assignment":
        return Colors.blue;
      case "Lab Test":
        return Colors.red;
      case "Lab Final":
        return Colors.deepPurple;
      case "Viva":
        return Colors.green;
      case "Mid Term":
        return Colors.teal;
      case "Final":
        return Colors.black;
      case "Project Submission":
        return Colors.brown;
      case "Meeting":
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  String getNextBusInfo(String today) {
    final now = TimeOfDay.now();
    final startingBus = startingBusSchedule[today]?["time"];
    final returningBus = returningBusSchedule[today]?["time"];

    if ((now.hour < 11 || (now.hour == 11 && now.minute <= 15)) && startingBus != null) {
      return "Next Starting Bus: $startingBus";
    } else if ((now.hour < 16 || (now.hour == 16 && now.minute <= 20)) && returningBus != null) {
      return "Next Returning Bus: $returningBus";
    } else {
      return "No Bus Available";
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE').format(DateTime.now());
    final dayDate = DateFormat('MMM d, yyyy').format(DateTime.now());
    final classesToday = weeklyClasses[today] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day & Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.blueGrey),
                SizedBox(width: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(today,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text(dayDate, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Classes Today
            Text("All Classes Today",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: classesToday.isNotEmpty
                    ? Column(
                        children: classesToday.map((cls) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cls["course"]!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16)),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(cls["time"]!,
                                        style: TextStyle(color: Colors.grey[700])),
                                    SizedBox(width: 16),
                                    Icon(Icons.location_on, size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text(cls["room"]!,
                                        style: TextStyle(color: Colors.grey[700])),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text("No classes today",
                              style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                        ),
                      ),
              ),
            ),
            SizedBox(height: 20),

            // Next Bus
            Text("Next Bus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getNextBusInfo(today),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.green)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => BusPage()));
                      },
                      child: Text("Full Schedule",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Latest Important Event
            Text("Latest Important Event",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: Hive.box<Event>('eventsBox').listenable(),
              builder: (context, Box<Event> box, _) {
                if (box.isEmpty) {
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No events today",
                          style: TextStyle(color: Colors.grey[700])),
                    ),
                  );
                }

                // Sort events by dateTime and get the next upcoming event
                final now = DateTime.now();
                final upcomingEvents = box.values
                    .where((e) => e.dateTime.isAfter(now))
                    .toList()
                      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

                if (upcomingEvents.isEmpty) {
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("No upcoming events",
                          style: TextStyle(color: Colors.grey[700])),
                    ),
                  );
                }

                final latestEvent = upcomingEvents.first;

                return Card(
                  color: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(latestEvent.course,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: categoryColor(latestEvent.category),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(latestEvent.category,
                                  style: TextStyle(color: Colors.white, fontSize: 12)),
                            )
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          "${DateFormat('dd/MM/yyyy').format(latestEvent.dateTime)} • ${DateFormat('hh:mm a').format(latestEvent.dateTime)}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        SizedBox(height: 6),
                        Text(latestEvent.description),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
