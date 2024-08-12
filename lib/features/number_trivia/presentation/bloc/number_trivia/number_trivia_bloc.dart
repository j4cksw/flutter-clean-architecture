import 'package:bloc/bloc.dart';
import 'package:cleaner/core/error/failures.dart';
import 'package:cleaner/core/usecases/usecase.dart';
import 'package:cleaner/core/util/input_converter.dart';
import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const INVALID_INPUT_MESSAGE = 'Invalid input';
const SERVER_ERROR = 'Error from the server';
const CACHE_ERROR = 'Error from the local cache';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcrete;
  final GetRandomNumberTrivia getRandom;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcrete,
    required this.getRandom,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetConcreteNumberTriviaEvent>((event, emit) async {
      await inputConverter.stringToUnsignedInt(event.numberString).fold((failure) {
        emit(const Error(message: INVALID_INPUT_MESSAGE));
      }, (parsedNumber) async {
        emit(Loading());
        final result = await getConcrete(Params(number: parsedNumber));
        result.fold(
            (failure) => emit(Error(message: _mapErrorToMessage(failure))),
            (data) => emit(Loaded(numberTrivia: data)));
      });
    });

    on<GetRandomNumberTriviaEvent>((_, emit) async {
      emit(Loading());
      final result = await getRandom(NoParams());
      result.fold(
          (failure) => emit(Error(message: _mapErrorToMessage(failure))),
          (data) => emit(Loaded(numberTrivia: data)));
    });
  }

  String _mapErrorToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_ERROR;
      case CacheFailure:
        return CACHE_ERROR;
      default:
        return 'Unexpected error';
    }
  }
}
