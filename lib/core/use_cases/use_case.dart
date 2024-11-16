import 'package:dartz/dartz.dart';
import 'package:note/core/error/failures.dart';

abstract class UseCase<Type, Parameter> {
  Future<Either<Failure, Type>> call([Parameter parm]);
}

class NoParameter {}

// notes :
// 1- [] means optinal in method header;
// Generic : <Type, Parameter>
