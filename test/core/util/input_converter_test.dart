import 'package:cleaner/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter? inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedIn', () {
    test('should retrun an integer when given string represented unsigned int',
        () {
      expect(inputConverter!.stringToUnsignedInt('123'), const Right(123));
    });

    test(
        'should retrun InvalidInputFailure when given string not represented unsigned int',
        () {
      expect(inputConverter!.stringToUnsignedInt('abc'),
          Left(InvalidInputFailure()));
    });

    test(
        'should retrun InvalidInputFailure when given string not represented unsigned int',
        () {
      expect(inputConverter!.stringToUnsignedInt('-123'),
          Left(InvalidInputFailure()));
    });
  });
}
