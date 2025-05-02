import 'package:flutter/material.dart';
import 'package:univents_flutter_application/models/organization_model.dart';

class EventDetails extends StatefulWidget {
  final String title;
  final String location;
  final String imageUrl;
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;
  final String description;
  final String orguid; // Reference to the organization

  const EventDetails({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.dateTimeStart,
    required this.dateTimeEnd,
    required this.description,
    required this.orguid,
  });

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String? _organizationName; // To store the fetched organization name
  bool _isLoading = true; // To show a loading indicator while fetching data

  @override
  void initState() {
    super.initState();
    _fetchOrganizationName();
  }

  Future<void> _fetchOrganizationName() async {
    // Simulate fetching organization details from the database
    final organizations = [
      Organization(
        uid: 'org1',
        banner: 'banner1.jpg',
        logo: 'logo1.jpg',
        acronym: 'ORG1',
        name: 'Organization One',
        category: 'Education',
        email: 'org1@example.com',
        mobile: '1234567890',
        facebook: 'facebook.com/org1',
        status: true,
      ),
      Organization(
        uid: 'org2',
        banner: 'banner2.jpg',
        logo: 'logo2.jpg',
        acronym: 'ORG2',
        name: 'Organization Two',
        category: 'Health',
        email: 'org2@example.com',
        mobile: '0987654321',
        facebook: 'facebook.com/org2',
        status: true,
      ),
    ];

    // Find the organization by orguid
    final organization = organizations.firstWhere(
      (org) => org.uid == widget.orguid,
      orElse: () => Organization(
        uid: '',
        banner: '',
        logo: '',
        acronym: '',
        name: '',
        category: '',
        email: '',
        mobile: '',
        facebook: '',
        status: false,
      ),
    );

    setState(() {
      _organizationName = organization.name;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Image.network(
                widget.imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                right: 16,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Invite',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.dateTimeStart.toLocal().toString().substring(0, 10)} | '
                      '${widget.dateTimeStart.toLocal().toString().substring(11, 16)} - '
                      '${widget.dateTimeEnd.toLocal().toString().substring(11, 16)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.location,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/32.jpg',
                      ),
                    ),
                    const SizedBox(width: 10),
                    _isLoading
                        ? const CircularProgressIndicator() // Show loading indicator
                        : Text(
                            _organizationName ?? 'Unknown Organization',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                        foregroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      child: const Text('Follow'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "About Event",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.description,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D3192),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text(
                  "JOIN EVENT",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}