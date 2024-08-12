import 'package:cleaner/injection.dart';
import 'package:flutter/material.dart';

import 'features/number_trivia/presentation/pages/number_trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number trivia',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.green.shade800),
        primaryColor: Colors.green.shade800,
      ),
      home: const NumberTriviaPage(),
    );
  }
}
