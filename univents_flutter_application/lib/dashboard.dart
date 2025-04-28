import 'package:flutter/material.dart';
import 'package:univents_flutter_application/Web/Login.dart';
import 'package:univents_flutter_application/eventdetails.dart';

class Dashboard extends StatefulWidget {
  final String name;
  final String email;

  const Dashboard({super.key, required this.name, required this.email});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, String>> events = [];
  List<Map<String, String>> recommendedEvents = [];

  @override
  void initState() {
    super.initState();
    _loadDummyEvents();
  }

  void _loadDummyEvents() {
    events = [
      {
        'title': 'Music Fest 2025',
        'location': 'Ateneo Open Grounds',
        'image_url': 'https://bokvzsmpjkdvcxndjfop.supabase.co/storage/v1/object/public/event-banner//Career%20and%20Skills%20Forum.jpg',
      },
      {
        'title': 'Tech Expo',
        'location': 'Finster Auditorium',
        'image_url': 'https://bokvzsmpjkdvcxndjfop.supabase.co/storage/v1/object/public/event-banner//Heritage.jpg',
      },
      {
        'title': 'Art Exhibit',
        'location': 'Community Center',
        'image_url': 'https://bokvzsmpjkdvcxndjfop.supabase.co/storage/v1/object/public/event-banner//IT%20WEEK%202025.jpg',
      },
      {
        'title': 'Career Fair',
        'location': 'Martin Hall',
        'image_url': 'https://bokvzsmpjkdvcxndjfop.supabase.co/storage/v1/object/public/event-banner//SEA%20Fair%202025.jpg',
      },
      {
        'title': 'Startup Pitch',
        'location': 'Foyer Area',
        'image_url': 'https://bokvzsmpjkdvcxndjfop.supabase.co/storage/v1/object/public/event-banner//UPSCALE.jpg',
      },
    ];
    setState(() {
      recommendedEvents = events.take(4).toList(); // Take first 4
    });
  }

  Widget _nearbyCard({
    required String title,
    required String dateTime,
    required String location,
    required String details,
    required Color color,
  }) {
    final bool isDark = color == const Color(0xFF2D3192);
    final textColor = isDark ? Colors.white : const Color(0xFF2D3192);
return Container(
  margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    children: [
      Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://bokvzsmpjkdvcxndjfop.supabase.co/storage/v1/object/public/event-banner//code-in-the-dark.png',
              height: 90,
              width: 90,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            title,
            style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dateTime,
            style: TextStyle(color: textColor, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            location,
            style: TextStyle(color: textColor, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            details,
            style: TextStyle(color: textColor, fontSize: 12),
          ),
          ],
        ),
        ),
      ],
      ),
      const SizedBox(height: 12),
      Container(
      height: 1,
      width: double.infinity,
      color: Colors.grey, // Changed to Colors.grey
      ),
      const SizedBox(height: 12),
    ],
  ),
);

  }

  void _signOut(BuildContext context) async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  Widget _drawerItem(IconData icon, String title, {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing != null
          ? CircleAvatar(
              backgroundColor: Colors.red,
              radius: 10,
              child: Text(
                trailing,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : null,
      onTap: onTap ?? () {},
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.name.toUpperCase(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            _drawerItem(Icons.person, 'My Profile'),
            _drawerItem(Icons.message, 'Message', trailing: '3'),
            _drawerItem(Icons.calendar_today, 'Calendar'),
            _drawerItem(Icons.bookmark, 'Bookmark'),
            _drawerItem(Icons.contact_mail, 'Contact Us'),
            _drawerItem(Icons.settings, 'Settings'),
            _drawerItem(Icons.help_outline, 'Helps & FAQs'),
            _drawerItem(Icons.logout, 'Sign Out', onTap: () => _signOut(context)),
          ],
        ),
      ),
    ),
    body: SingleChildScrollView( // Added SingleChildScrollView
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/bg.jpeg'),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    Column(
                      children: const [
                        Text(
                          'Current Status',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          'Student',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 90),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.2),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(color: Colors.white70),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.filter_list, color: Color(0xFF2D3192)),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Events',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
          ),
SizedBox(
  height: 249,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: recommendedEvents.length,
    padding: const EdgeInsets.only(left: 30),
    itemBuilder: (context, index) {
      final event = recommendedEvents[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventDetails(
                title: event['title'] ?? '',
                location: event['location'] ?? '',
                imageUrl: event['image_url'] ?? '',
              ),
            ),
          );
        },
        child: Container(
          width: 230,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: event['image_url'] != null
                        ? Image.network(
                            event['image_url']!,
                            height: 140,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 140,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 40, color: Colors.grey),
                          ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: const [
                          Text(
                            '10',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'JUNE',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title'] ?? 'No Title',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/women/1.jpg'),
                        ),
                        const CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/men/2.jpg'),
                        ),
                        const CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/women/3.jpg'),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+20 Going',
                          style: TextStyle(
                          color: const Color.fromARGB(255, 34, 11, 140),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                          event['location'] ?? '',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nearby You',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
          ),
          Column(
            children: [
              _nearbyCard(
                title: "POSTER MAKING",
                dateTime: "May 5, 2:00 PM",
                location: "Room 301, Arts Building",
                details: "Bring your own art materials.",
                color: const Color(0xFF2D3192),
              ),
              _nearbyCard(
                title: "CODE IN THE DARK",
                dateTime: "May 6, 6:00 PM",
                location: "Computer Lab 2",
                details: "No preview allowed. Show your raw HTML/CSS skills!",
                color: Colors.white,
              ),
              _nearbyCard(
                title: "CODE IN THE DARK",
                dateTime: "May 7, 7:00 PM",
                location: "Tech Hub",
                details: "Advanced round with audience voting.",
                color: const Color(0xFF2D3192),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
}