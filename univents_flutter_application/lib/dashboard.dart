import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:univents_flutter_application/event_list_screen.dart';
import 'package:univents_flutter_application/lib/mobile/models/event_model.dart';
import 'package:univents_flutter_application/lib/mobile/controllers/event_controller.dart';
import 'package:univents_flutter_application/Web/Login.dart';
import 'package:univents_flutter_application/eventdetails.dart';

class Dashboard extends StatelessWidget {
  final String name;
  final String email;

  const Dashboard({super.key, required this.name, required this.email});

  void _signOut(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  Widget _drawerItem(IconData icon, String title,
      {String? trailing, VoidCallback? onTap}) {
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
    return ChangeNotifierProvider(
      create: (_) => DataProvider()..fetchEvents(),
      child: Scaffold(
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircleAvatar(radius: 40),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
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
                _drawerItem(Icons.logout, 'Sign Out',
                    onTap: () => _signOut(context)),
              ],
            ),
          ),
        ),
        body: Consumer<DataProvider>(
          builder: (context, provider, child) {
            if (provider.events == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.events!.isEmpty) {
              return const Center(child: Text('No Events Found.'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Upcoming Events',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventListScreen(events: provider.events!),
      ),
    );
  },
  child: const Text('See All'),
),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.events!.length,
                      padding: const EdgeInsets.only(left: 30),
                      itemBuilder: (context, index) {
                        final event = provider.events![index];
                        return _buildEventCard(context, event);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
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
                  Text('Current Status',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  Text('Student',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
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
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetails(
              title: event.title,
              location: event.location,
              imageUrl: event.eventbanner,
              dateTimeStart: event.datetimestart,
              dateTimeEnd: event.datetimeend,
              description: event.description,
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: event.eventbanner.isNotEmpty
                      ? Image.network(
                          event.eventbanner,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 140,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image,
                              size: 40, color: Colors.grey),
                        ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${event.datetimestart.day}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _monthString(event.datetimestart.month),
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
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
        event.title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 8),
      Row(
  children: [
    SizedBox(
      width: 50,
      height: 20,
      child: Stack(
        children: const [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/1.jpg',
              ),
            ),
          ),
          Positioned(
            left: 15,
            child: CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/2.jpg',
              ),
            ),
          ),
          Positioned(
            left: 30,
            child: CircleAvatar(
              radius: 10,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/men/3.jpg',
              ),
            ),
          ),
        ],
      ),
    ),
    const SizedBox(width: 8),
    const Text(
      '+20 Going',
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w500,
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
              event.location,
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
  }

  String _monthString(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }
}
