import 'package:univents_flutter_application/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataProvider extends ChangeNotifier {
  List<EventsModel>? events;


  Future<void> fetchEvents() async {
    final res = await Supabase.instance.client.from('events').select();
    events = (res as List).map((m) => EventsModel.fromMap(m)).toList();
    notifyListeners();
  }
}