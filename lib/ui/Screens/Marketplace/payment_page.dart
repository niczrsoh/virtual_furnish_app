import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/bloc/Marketplace/payment_bloc.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.paymentBloc});
  final PaymentBloc paymentBloc;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Center(
        child: Text('Payment Page'),
      ),
    );
  }
}