import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtual_furnish_app/core/errors/failure.dart';
import 'package:virtual_furnish_app/core/helpers/typedef.dart';
import 'package:virtual_furnish_app/data/source/constant_db.dart';
import 'package:http/http.dart' as http;

class ViewItemsSource{
  ResultFuture<String> getRawItems() async {
  try {
    // Fetch items from the server
    final response = await http.get(Uri.parse(rawItemsURL));
    
    // Check if the request was successful
    if (response.statusCode == 200) {
      // Return the raw data as a String
      return Right(response.body.toString());
    } else {
      // Return an exception if the request was not successful
      Failure failure = APIFailure(message: 'Failed to fetch items: ${response.statusCode}', statusCode: response.statusCode);
      return Left(failure);
    }
  } catch (e) {
    // Return an exception if an error occurred during the request
    Failure failure = APIFailure(message: e.toString(), statusCode: e.hashCode);
      return Left(failure);
  }
  }
} 