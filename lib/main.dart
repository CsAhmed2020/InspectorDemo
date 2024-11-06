import 'package:flutter/material.dart';
import 'package:inspector_flutter_demo/post.dart';
import 'package:requests_inspector/requests_inspector.dart';

import 'ApiService.dart';

void main() {
  runApp(
       RequestsInspector(
        enabled: true,
        showInspectorOn: ShowInspectorOn.Both,
        navigatorKey: null,
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();

   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Network Inspector Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Network Inspector Demo')),
        body: HomeScreen(apiService: apiService),
      ),
    );
  }
}

//ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  final ApiService apiService;

  const HomeScreen({super.key, required this.apiService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Post? post;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          post == null ? const Center(child: Text('Try Fetch')) :
          Column(
            children: [
              Text('ID:${post?.id}'),
              const SizedBox(height: 16,),
              Text('Title:${post?.body}'),
              const SizedBox(height: 16,),
              Text('Body:${post?.body}'),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              // Make a network request and log it
               final res = await widget.apiService.getSampleData();
               setState(() {
                 post = res;
               });
            },
            child: const Text('Make Network Request'),
          ),
        ],
      ),
    );
  }
}
