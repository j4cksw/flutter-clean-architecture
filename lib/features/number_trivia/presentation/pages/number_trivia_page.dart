import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleaner/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:cleaner/features/number_trivia/presentation/widgets/loading_display.dart';
import 'package:cleaner/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:cleaner/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:cleaner/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number trivia'),
      ),
      body: _buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: _buildMessageDisplay,
            ),
            const SizedBox(
              height: 20,
            ),
            const TriviaControls()
          ],
        ),
      ),
    );
  }

  Widget _buildMessageDisplay(_, NumberTriviaState state) {
    if (state is Empty) {
      return const MessageDisplay(message: 'Start searching!');
    }
    if (state is Loading) {
      return const LoadingWidget();
    }
    if (state is Loaded) {
      return TriviaDisplay(trivia: state.numberTrivia);
    }
    if (state is Error) {
      return MessageDisplay(message: state.message);
    }
    return const TriviaDisplay(trivia: NumberTrivia(number: 999, text: '''
      Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

      The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.
      '''));
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController(); 
  String inputStr = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) => inputStr = value,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () => BlocProvider.of<NumberTriviaBloc>(context)
                        .add(GetConcreteNumberTriviaEvent(inputStr)),
                    child: const Text('Search'))),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
                    onPressed: () => BlocProvider.of<NumberTriviaBloc>(context)
                        .add(GetRandomNumberTriviaEvent()),
                    child: const Text('Random'))),
          ],
        )
      ],
    );
  }
}
