import 'package:flutter_dotenv/flutter_dotenv.dart';

String get licenseKey => dotenv.env['LICENSE_KEY'] ?? '';
