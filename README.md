# Univents Flutter App

The **Univents Flutter App** is an all-in-one event finder system for **Ateneo de Davao University (AdDU)**.  
It allows students to easily discover, track, and participate in university events, providing a centralized platform for campus engagement.  

This project was developed as part of the **CS Elective: Multiplatform Development with Flutter**.

---

## Features

- 📅 Browse upcoming and past university events  
- 🔔 Receive event notifications and reminders  
- 🎓 Participate and register for events directly through the app  
- 🔍 Search and filter events by category or date  
- ❤️ Save and bookmark favorite events  
- 🌐 Cross-platform (Android & iOS) support  

---

## Tech Stack

- [Flutter](https://flutter.dev/) — Cross-platform UI toolkit  
- [Dart](https://dart.dev/) — Programming language for Flutter  
- [Supabase](https://supabase.com/) — Backend-as-a-Service (authentication, database, storage, APIs)  

---

## Setup Instructions

1. **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/univents-flutter-app.git
    cd univents-flutter-app
    ```

2. **Install dependencies:**
    ```bash
    flutter pub get
    ```

3. **Set up Supabase:**
   - Create a project at [Supabase](https://supabase.com/).  
   - Copy your project **API URL** and **anon/public API key**.  
   - Create a `.env` or config file in your Flutter project and add:  
     ```env
     SUPABASE_URL=your-supabase-url
     SUPABASE_ANON_KEY=your-anon-key
     ```

4. **Run the app:**
    ```bash
    flutter run
    ```

---

## Project Structure

- `lib/` — Main Dart code (UI, logic, and state management)  
- `assets/` — Images, icons, and other static resources  
- `pubspec.yaml` — Dependencies and configuration  

---

## Contributing

This project was created for academic purposes, but improvements are welcome!  
If you’d like to contribute or extend the app, feel free to fork the repo and submit a pull request.  

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
