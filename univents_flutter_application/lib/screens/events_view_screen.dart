import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:univents_flutter_application/models/event_model.dart';


class ViewEvents extends StatefulWidget {
  const ViewEvents({super.key});


  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchAll();
  }

 Future<void> fetchAll() async {
    await fetchEvents();
  }

    Future<void> fetchEvents() async {
    final res = await Supabase.instance.client.from('events').select();
    if (mounted) {
      setState(() {
        events = (res as List).map((m) => Event.fromMap(m)).toList();
      });
    }
  }
 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Text("Hello"),
              Container(color: Colors.blue,)
            ],
          ),
        ),
      ),
    );
  }
}