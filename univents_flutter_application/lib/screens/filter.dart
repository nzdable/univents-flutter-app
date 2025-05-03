import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory = 'All'; // Default category

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final searchQuery = _searchController.text;
    final selectedCategory = _selectedCategory;

    // Add your filter logic here
    print('Search Query: $searchQuery');
    print('Selected Category: $selectedCategory');

    // Close the filter screen and pass the filter data back
    Navigator.pop(context, {
      'searchQuery': searchQuery,
      'selectedCategory': selectedCategory,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown for Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: ['All', 'Option 1', 'Option 2']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Apply Button
            ElevatedButton(
              onPressed: _applyFilter,
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}