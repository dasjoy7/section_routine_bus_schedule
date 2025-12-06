import 'package:flutter/material.dart';

class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  late PageController _pageController;

  Map<String, List<Map<String, String>>> routine = {
    'Mon': [
      {
        'course': 'Microprocessors and Assembly Language Sessional',
        'code': 'CSE-3202',
        'time': '10:00-11:10',
        'room': 'ACL-1',
        'icon': 'cpu',
        'color': '0xFF42A5F5',
      },
      {
        'course': 'Computer Networks',
        'code': 'CSE-3231',
        'time': '12:40-13:50',
        'room': 'RKB-407',
        'icon': 'wifi',
        'color': '0xFF66BB6A',
      },
      {
        'course': 'Microprocessors and Assembly Language',
        'code': 'CSE-3201',
        'time': '15:00-16:10',
        'room': 'RAB-304',
        'icon': 'cpu',
        'color': '0xFF42A5F5',
      },
    ],
    'Tue': [
      {
        'course': 'Management Studies',
        'code': 'GED-1116',
        'time': '10:00-11:10',
        'room': 'RKB-404',
        'icon': 'work',
        'color': '0xFFFFCA28',
      },
      {
        'course': 'Computer Networks Sessional',
        'code': 'CSE-3232',
        'time': '11:10-12:20',
        'room': 'ACL-3',
        'icon': 'wifi',
        'color': '0xFF66BB6A',
      },
    ],
    'Wed': [
      {
        'course': 'Computer Networks Sessional',
        'code': 'CSE-3232',
        'time': '08:50-10:00',
        'room': 'ACL-2',
        'icon': 'wifi',
        'color': '0xFF66BB6A',
      },
      {
        'course': 'Computer Networks',
        'code': 'CSE-3231',
        'time': '10:00-11:10',
        'room': 'RKB-402',
        'icon': 'wifi',
        'color': '0xFF66BB6A',
      },
      {
        'course': 'Microprocessors and Assembly Language',
        'code': 'CSE-3201',
        'time': '11:10-12:20',
        'room': 'RKB-404',
        'icon': 'cpu',
        'color': '0xFF42A5F5',
      },
      {
        'course': 'Microprocessors and Assembly Language Sessional',
        'code': 'CSE-3202',
        'time': '12:40-01:50',
        'room': 'ACL-1',
        'icon': 'cpu',
        'color': '0xFF42A5F5',
      },
      {
        'course': 'Management Studies',
        'code': 'GED-1116',
        'time': '01:50-03:00',
        'room': 'RAB-111',
        'icon': 'work',
        'color': '0xFFFFCA28',
      },
    ],
    'Thu': [],
    'Fri': [],
    'Sat': [],
    'Sun': [],
  };

  late String selectedDay;

  Icon _getIcon(String? iconName, Color color) {
    switch (iconName) {
      case 'cpu':
        return Icon(Icons.memory, color: color, size: 28);
      case 'wifi':
        return Icon(Icons.wifi, color: color, size: 28);
      case 'work':
        return Icon(Icons.work, color: color, size: 28);
      default:
        return Icon(Icons.book, color: color, size: 28);
    }
  }

  @override
  void initState() {
    super.initState();

    // Map weekday number to string
    List<String> days = routine.keys.toList();
    int weekdayNumber = DateTime.now().weekday; // 1 = Mon, 7 = Sun
    selectedDay = days[weekdayNumber - 1]; // select today

    _pageController = PageController(initialPage: days.indexOf(selectedDay));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> days = routine.keys.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Semester - Fall 25",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: days.map((day) {
                bool isSelected = day == selectedDay;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day;
                      _pageController.jumpToPage(days.indexOf(day));
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
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
          SizedBox(height: 20),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: days.length,
              onPageChanged: (index) {
                setState(() {
                  selectedDay = days[index];
                });
              },
              itemBuilder: (context, index) {
                final dayClasses = routine[days[index]] ?? [];

                if (dayClasses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_satisfied, size: 60, color: Colors.grey[400]),
                        SizedBox(height: 20),
                        Text(
                          "No classes today!\nEnjoy your day off! 😎",
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: dayClasses.length,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemBuilder: (context, clsIndex) {
                    final cls = dayClasses[clsIndex];
                    Color iconColor = Color(int.parse(cls['color'] ?? '0xFF42A5F5'));

                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _getIcon(cls['icon'], iconColor),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cls['course'] ?? '',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        cls['code'] ?? '',
                                        style: TextStyle(color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Divider(color: Colors.grey[300], thickness: 1),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 22, color: Colors.grey[700]),
                                SizedBox(width: 5),
                                Text(cls['time'] ?? ''),
                                SizedBox(width: 30),
                                Icon(Icons.meeting_room, size: 22, color: Colors.grey[700]),
                                SizedBox(width: 5),
                                Text(cls['room'] ?? ''),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
