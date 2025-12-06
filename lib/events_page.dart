import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'event_model.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final List<String> courseList = [
    "Micro Sessional",
    "Micro",
    "C.Networks",
    "C.Networks Sessional",
    "Management",
    "Project I",
  ];

  final List<String> categories = [
    "Tutorial",
    "Presentation",
    "Assignment",
    "Lab Test",
    "Lab Final",
    "Viva",
    "Mid Term",
    "Final",
    "Project Submission",
    "Meeting"
  ];

  String? selectedCourse;
  String? selectedCategory;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? description;

  late Box<Event> eventBox;

  @override
  void initState() {
    super.initState();
    eventBox = Hive.box<Event>('eventsBox');
  }

  void openAddEventPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStatePopup) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  top: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Text("Add New Event",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 25),

                    // Course Dropdown
                    Text("Course"),
                    SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey)),
                      child: DropdownButton<String>(
                        value: selectedCourse,
                        hint: Text("Select Course"),
                        isExpanded: true,
                        underline: SizedBox(),
                        items: courseList
                            .map((course) =>
                                DropdownMenuItem(value: course, child: Text(course)))
                            .toList(),
                        onChanged: (value) {
                          setStatePopup(() {
                            selectedCourse = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 15),

                    // Date + Time pickers
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date"),
                              SizedBox(height: 6),
                              InkWell(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    setStatePopup(() {
                                      selectedDate = pickedDate;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12)),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    selectedDate != null
                                        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                                        : "Select Date",
                                    style: TextStyle(
                                        color: selectedDate == null
                                            ? Colors.grey[600]
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Time"),
                              SizedBox(height: 6),
                              InkWell(
                                onTap: () async {
                                  TimeOfDay? pickedTime =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (pickedTime != null) {
                                    setStatePopup(() {
                                      selectedTime = pickedTime;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12)),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    selectedTime != null
                                        ? selectedTime!.format(context)
                                        : "Select Time",
                                    style: TextStyle(
                                        color: selectedTime == null
                                            ? Colors.grey[600]
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Description
                    Text("Description"),
                    SizedBox(height: 6),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (v) => description = v,
                    ),
                    SizedBox(height: 15),

                    // Category chips
                    Text("Category"),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: categories.map((cat) {
                        bool selected = selectedCategory == cat;
                        return ChoiceChip(
                          label: Text(cat),
                          selected: selected,
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[200],
                          labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black),
                          onSelected: (_) {
                            setStatePopup(() => selectedCategory = cat);
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedCourse == null ||
                              selectedCategory == null ||
                              selectedDate == null ||
                              selectedTime == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Please fill all required fields")),
                            );
                            return;
                          }

                          final dt = DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                              selectedTime!.hour,
                              selectedTime!.minute);

                          final newEvent = Event(
                            course: selectedCourse!,
                            category: selectedCategory!,
                            dateTime: dt,
                            description: description ?? "",
                          );
                          eventBox.add(newEvent);

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Save",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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

  void deleteEvent(int index, Event e) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Event"),
        content: Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              e.delete();
              Navigator.pop(ctx);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openAddEventPopup,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        shape: CircleBorder(),
      ),
      appBar: AppBar(
        title: Text("Important Dates"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ValueListenableBuilder<Box<Event>>(
        valueListenable: eventBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) return Center(child: Text("No Events Added Yet"));

          final events = box.values.toList()
            ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final e = events[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                margin: EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.course,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: categoryColor(e.category),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  e.category,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                              SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => deleteEvent(index, e),
                                child: Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                          "${DateFormat('dd/MM/yyyy').format(e.dateTime)} • ${DateFormat('hh:mm a').format(e.dateTime)}",
                          style: TextStyle(color: Colors.grey[700])),
                      SizedBox(height: 10),
                      Text(e.description),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
