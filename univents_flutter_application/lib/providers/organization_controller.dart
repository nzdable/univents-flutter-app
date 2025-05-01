import 'package:univents_flutter_application/models/organization_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DataProvider extends ChangeNotifier {
  List<Organization>? organizations;


  Future<void> fetchOrganizations() async {
    final res = await Supabase.instance.client.from('organizations').select();
    organizations = (res as List).map((m) => Organization.fromMap(m)).toList();
    notifyListeners();
  }
}