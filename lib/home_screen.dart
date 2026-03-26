import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 24, 41),
      body: SafeArea(
        top: false,
        child: Column(
        children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 41, 57),
                border: Border(bottom: BorderSide(
                  color: Colors.blueGrey,
                  width: 0.5
                ))
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 12),
                child: Container(
                  margin: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 55, 73, 87),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      hintText: "Search Posts",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
            // search bar goes here
            // category pills go here
            // post list goes here
          ],
      ))
    );
  }

}