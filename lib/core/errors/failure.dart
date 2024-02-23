// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class Failure extends Equatable {
  final String message;
  final int statusCode;
  const Failure({
    required this.message,
    required this.statusCode,
  });

  //here if message and status code of the failure is the same, then the failure is the same
  @override
  List<Object> get props => [message,statusCode];
}

class APIFailure extends Failure {
  const APIFailure({
    required super.message,
    required super.statusCode,
  });
}