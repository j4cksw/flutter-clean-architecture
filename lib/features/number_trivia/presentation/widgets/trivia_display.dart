import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/widgets.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;

  const TriviaDisplay({super.key, required this.trivia});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            trivia.number.toString(),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                  child: Text(
                trivia.text,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              )),
            ),
          ),
        ],
      ),
    );
  }
}