
import 'package:dartz/dartz.dart';
import 'package:virtual_furnish_app/core/errors/failure.dart';

typedef ResultFuture<T> = Future<Either<Failure,T>>; 
typedef ResultVoid = Future<Either<Failure,void>>;