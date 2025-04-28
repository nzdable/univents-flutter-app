import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_flutter_application/Web/Login.dart';
class Dashboard extends StatefulWidget {
  final String name;
  final String email;

  const Dashboard({super.key, required this.name, required this.email});

  @override
  State<Dashboard> createState() => _DashboardState();
}
Widget _buildDashboardCard(IconData icon, String title) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () {}, // you can add navigation or functionality here
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.indigo),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ),
  );
}

class _DashboardState extends State<Dashboard> {
  void _signOut(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Login()),
      );
    }
  }

  Widget _drawerItem(IconData icon, String title, {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing != null
          ? CircleAvatar(
              backgroundColor: Colors.red,
              radius: 10,
              child: Text(trailing, style: const TextStyle(color: Colors.white, fontSize: 12)),
            )
          : null,
      onTap: onTap ?? () {}, // Default to no-op if onTap is not provided
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
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(widget.name.toUpperCase(),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
    appBar: AppBar(
      title: const Text('Dashboard'),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${widget.name}!',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Email: ${widget.email}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardCard(Icons.event, 'Events'),
                _buildDashboardCard(Icons.calendar_month, 'Calendar'),
                _buildDashboardCard(Icons.message, 'Messages'),
                _buildDashboardCard(Icons.bookmark, 'Bookmarks'),
                _buildDashboardCard(Icons.people, 'Organizations'),
                _buildDashboardCard(Icons.settings, 'Settings'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
