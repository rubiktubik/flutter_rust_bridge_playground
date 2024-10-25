import 'package:flutter/material.dart';
import 'package:rust_bridge_playground/dashboard.dart';
import 'package:rust_bridge_playground/src/rust/api/simple.dart';
import 'package:rust_bridge_playground/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String name = '-';
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 1), value: 0)
      ..addListener(
        () {
          setState(() {});
        },
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Column(
          children: [
            ElevatedButton(
              child: const Text('Start'),
              onPressed: () async {
                await for (var event in wordsOncecell()) {
                  setState(() {
                    name = event.word;
                    final step = event.current / event.max;
                    _controller.animateTo(
                      step,
                    );
                  });
                }
              },
            ),
            ElevatedButton(
              child: const Text('Reset'),
              onPressed: () async {
                setState(() {
                  name = '';
                  _controller.reset();
                });
              },
            ),
            ElevatedButton(
              child: const Text('Next Page'),
              onPressed: () async {
                final nav = Navigator.of(context);
                await nav.push(
                  MaterialPageRoute(
                      builder: (context) => const DashboardPage()),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(name),
            LinearProgressIndicator(
              value: _controller.value,
            )
          ],
        ),
      ),
    );
  }
}
