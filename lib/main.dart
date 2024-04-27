

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:virtual_furnish_app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import '.env';
import 'package:flutter_dotenv/flutter_dotenv.dart';

late Size mq;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  await dotenv.load(fileName: "assets/.env");
  await Stripe.instance.applySettings();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const App());
}
