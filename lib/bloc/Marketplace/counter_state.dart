// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

//blueprint for all the possible states that our counter can be in
class CounterState {
  final int counterValue;
  final bool? wasIncremented;
  const CounterState({required this.counterValue, this.wasIncremented});
  
  // TODO: implement props
  //to list out all the properties that we want to compare
  //this is used to compare two objects of the same type
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'counterValue': counterValue,
      'wasIncremented': wasIncremented,
    };
  }

  factory CounterState.fromMap(Map<String, dynamic> map) {
    return CounterState(
      counterValue: map['counterValue'] as int,
      wasIncremented: map['wasIncremented'] != null ? map['wasIncremented'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CounterState.fromJson(String source) => CounterState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CounterState(counterValue: $counterValue, wasIncremented: $wasIncremented)';
}


