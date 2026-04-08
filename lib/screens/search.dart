//make a basic search page with a search bar and a list of results
import 'package:flutter/material.dart';
import '../widget/bottom.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
      ),
      // bottom navigation bar
      bottomNavigationBar: const SharedBottomNavigationBar(currentIndex: 1),
    );
  }
}
