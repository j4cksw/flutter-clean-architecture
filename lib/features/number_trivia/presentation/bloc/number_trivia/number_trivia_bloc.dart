import 'package:bloc/bloc.dart';
import 'package:cleaner/core/util/input_converter.dart';
import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const INVALID_INPUT_MESSAGE = 'Invalid input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia concrete;
  final GetRandomNumberTrivia random;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.concrete,
    required this.random,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetConcreteNumberTriviaEvent>((event, emit) {
      inputConverter.stringToUnsignedInt(event.numberString).fold((failure) {
        emit(const Error(message: INVALID_INPUT_MESSAGE));
      }, (_) {});
    });
  }
}
