# 📚 CSE61C Routine App  
A Flutter application designed for university students to view **class routines**, **bus schedules**, and **upcoming events** — all stored **locally using Hive**, so the app works completely **offline**.

---

## 🚀 Features

### 🗓 Class Routine (Auto by Day)
- Shows **today’s routine automatically**
- Displays courses, times, and teachers
- Fully offline — no internet required

### 🚌 Bus Schedule (Auto by Day)
- Day-wise bus timing system
- Automatically shows **today’s bus schedule**

### 🎉 Events (Hive Local Storage)
- Add and store events locally
- Each event includes:
  - Course
  - Category
  - Time (stored in DateTime)
  - Description
- Uses Hive database for fast offline storage
- Events are listed on the **Events Page**

### 🏠 Dashboard
- Shows the **next upcoming event**
- Event automatically disappears after the event time passes

### 📦 Offline Support
This app works **100% offline**  
All data is saved in the device using Hive.
