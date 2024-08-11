part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetConcreteNumberTriviaEvent implements NumberTriviaEvent {
  final String numberString;

  GetConcreteNumberTriviaEvent(this.numberString);

  @override
  List<Object> get props => [numberString];

  @override
  bool? get stringify => true;

}

class GetRandomNumberTriviaEvent implements NumberTriviaEvent {
  @override
  List<Object> get props => [];

  @override
  bool? get stringify => false;

}