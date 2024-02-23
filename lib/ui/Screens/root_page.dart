import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/data/source/view_items_source.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    ViewItemsSource().getRawItems();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Root Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/ikon_icon.jpeg', width: 200, height: 200, fit: BoxFit.cover,),
            Text('Try enter qui est esse to search this data from the list in next page'),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Title',
              ),
            ),
        ElevatedButton(
                child: const Text('Go to Home Page'),
                onPressed: () {
                  Navigator.pushNamed(context, '/home', arguments: {'title':_controller.text});
                },
              ),
             ElevatedButton(
                child: const Text('Go to Login Page'),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
               ElevatedButton(
                child: const Text('Go to Register Page'),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
          ],
        ),

      ),
    );
  }
}