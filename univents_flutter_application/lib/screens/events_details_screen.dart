import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventDetails extends StatefulWidget {
  final String title;
  final String location;
  final String imageUrl;
  final DateTime dateTimeStart;
  final DateTime dateTimeEnd;
  final String description;
  final String orguid; // Organization ID

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
  EventDetailsState createState() => EventDetailsState();
}

class EventDetailsState extends State<EventDetails> {
  String? _organizationName;
  String? _organizationBanner;
  bool _isLoading = true;
  bool _hasJoined = false;
  String? _eventId;

  @override
  void initState() {
    super.initState();
    _fetchOrganizationName();
    _fetchEventId();
  }

  // Fetch the organization's name and banner
  Future<void> _fetchOrganizationName() async {
    try {
      final organization = await Supabase.instance.client
          .from('organizations')
          .select('name, banner')
          .eq('uid', widget.orguid)
          .single();

      if (mounted) {
        setState(() {
          _organizationName = organization['name'];
          _organizationBanner = organization['banner'];
          _isLoading = false;
        });
      }
    } catch (error) {
      debugPrint("Error fetching organization: $error");
      if (mounted) {
        setState(() {
          _organizationName = 'Unknown Organization';
          _isLoading = false;
        });
      }
    }
  }

  // Fetch the event ID based on organization ID
  Future<void> _fetchEventId() async {
    try {
      final response = await Supabase.instance.client
          .from('events')
          .select('uid')
          .eq('orguid', widget.orguid)
          .eq('title', widget.title)
          .maybeSingle();

      if (response != null && mounted) {
        setState(() {
          _eventId = response['uid'];
        });
      } else {
        debugPrint("No event found or multiple events matched.");
      }
    } catch (error) {
      debugPrint("Error fetching event ID: $error");
    }
  }

  // Join the event
  Future<void> _joinEvent() async {
    try {
      debugPrint("Attempting to join event: ${widget.title}");
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        debugPrint("User is not logged in.");
        Fluttertoast.showToast(msg: "You must be logged in to join an event.");
        return;
      }

      debugPrint("User ID: $userId");

      // Query to check if the user exists in the 'accounts' table
      final userResponse = await Supabase.instance.client
          .from('accounts')
          .select('uid')
          .eq('uid', userId)
          .maybeSingle();

      if (userResponse == null) {
        debugPrint("User not found in accounts table.");
        Fluttertoast.showToast(msg: "User not found in accounts table.");
        return;
      }

      debugPrint("User exists in accounts table.");

      // Ensure the eventId is available
      if (_eventId == null) {
        Fluttertoast.showToast(msg: "Event ID is missing.");
        return;
      }

      final timestamp = DateTime.now().toIso8601String();

      // Insert the user joining the event into 'attendees' table
      final insertResponse =
          await Supabase.instance.client.from('attendees').insert({
        'accountid': userId, // Foreign key referencing accounts.uid
        'eventid': _eventId, // Foreign key referencing events.uid
        'datetimestamp': timestamp,
      }).select();

      if (insertResponse.error != null) {
        debugPrint(
            "Error inserting attendee: ${insertResponse.error!.message}");
        Fluttertoast.showToast(
            msg: "Failed to join the event. Please try again.");
        return;
      }

      debugPrint("Event joined successfully!");

      setState(() {
        _hasJoined = true;
      });
      Fluttertoast.showToast(msg: "You have successfully joined the event!");
    } catch (error) {
      debugPrint("Exception while joining event: $error");
      Fluttertoast.showToast(msg: "An error occurred. Please try again.");
    }
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
                  onPressed: () => Navigator.pop(context),
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
                Text(widget.title,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),
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
                      backgroundImage: _organizationBanner != null
                          ? NetworkImage(_organizationBanner!)
                          : null,
                    ),
                    const SizedBox(width: 5),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Flexible(
                            child: Text(
                              _organizationName ?? 'Unknown Organization',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text("About Event",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(widget.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
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
                  backgroundColor:
                      _hasJoined ? Colors.grey : const Color(0xFF2D3192),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _hasJoined ? null : _joinEvent,
                icon: const Icon(Icons.check, color: Colors.white),
                label: Text(
                  _hasJoined ? "Joined" : "Join Event",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on PostgrestList {
  get error => null;
}
