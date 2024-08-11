import 'package:cleaner/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInt(String str) {
    try {
      final parse = int.parse(str);
      if(parse < 0) throw const FormatException();
      return Right(parse);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
