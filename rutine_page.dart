import 'package:flutter/material.dart';

class RoutinePage extends StatefulWidget {
  const RoutinePage({super.key});

  @override
  State<RoutinePage> createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  // বর্তমান কোন দিন সিলেক্ট করা আছে
  String selectedDay = "Sun";

  // দিনগুলোর লিস্ট
  final List<String> days = ["Sun", "Mon", "Tue", "Wed", "Thu"];

  // রুটিন ডেটা (তোমার স্ক্রিনশট অনুযায়ী)
  final Map<String, List<Map<String, String>>> weeklyRoutine = {
    "Sun": [
      {"subject": "Chemistry", "room": "Room 420 • MS", "time": "1:15-2:00"},
      {"subject": "English-2", "room": "Room USB 420 • GMZH", "time": "2:00-2:45"},
      {"subject": "Computer Graphics Design-1", "room": "Room FT 203 • FT", "time": "2:45-4:15"},
      {"subject": "Computer Graphics Design-1 (CI&HoD)", "room": "Room AS 206 • AS", "time": "4:15-5:45"},
    ],
    "Mon": [
      {"subject": "Chemistry", "room": "Room ABH WS/A • MS", "time": "2:00-2:45"},
      {"subject": "Mathematics-2", "room": "Room MS 407 • MI", "time": "2:45-4:15"},
      {"subject": "Bangla-2", "room": "Room SAB 108 • USB", "time": "4:15-5:00"},
    ],
    "Tue": [
      {"subject": "Bangla-2", "room": "Room SAB WS/B • USB", "time": "1:15-2:00"},
      {"subject": "Mathematics-2", "room": "Room MS 417 • MI", "time": "2:00-2:45"},
      {"subject": "Chemistry", "room": "Room ABH Chem Lab • MS", "time": "2:45-4:15"},
      {"subject": "English-2", "room": "Room USB 415/B • GMZH", "time": "4:15-5:00"},
      {"subject": "Basic Electronics", "room": "Room MRM 415/B • MRM", "time": "5:00-5:45"},
    ],
    "Wed": [
      {"subject": "Computer Graphics Design-1 (CI&HoD)", "room": "Room AS 206 • AS", "time": "1:15-2:45"},
      {"subject": "Python Programing", "room": "Room FT 405 • FT", "time": "2:45-4:15"},
      {"subject": "Basic Electronics", "room": "Room MRM 219 • MRM", "time": "5:00-6:30"},
    ],
    "Thu": [
      {"subject": "Python Programming", "room": "Room FT 407 • FT", "time": "2:00-2:45"},
      {"subject": "Mathematics-2", "room": "Room MS 407 • MI", "time": "2:45-3:30"},
      {"subject": "Basic Electronics", "room": "Room MRM 407 • MRM", "time": "3:30-4:15"},
      {"subject": "Chemistry", "room": "Room ABH 407 • MS", "time": "4:15-5:00"},
      {"subject": "Physical Education", "room": "Room GMZH Field-03 • ABH", "time": "5:00-6:30"},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Class Routine — 2nd Semester, Group A", style: TextStyle(color: Colors.white, fontSize: 14)),
            Text("Dhaka Polytechnic Institute • CST Dept • Shift: 2nd", style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
      body: Column(
        children: [
          // দিন পরিবর্তনের ট্যাব বাটন
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: days.map((day) {
                bool isSelected = selectedDay == day;
                return GestureDetector(
                  onTap: () => setState(() => selectedDay = day),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.deepPurple : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? Colors.deepPurple : Colors.black12),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // রুটিন লিস্ট
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: weeklyRoutine[selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                var item = weeklyRoutine[selectedDay]![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F4), // হালকা ক্রিম কালার
                    borderRadius: BorderRadius.circular(15),
                    border: const Border(
                      left: BorderSide(color: Colors.deepPurple, width: 4),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['subject']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 5),
                            Text(item['room']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          item['time']!,
                          style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
