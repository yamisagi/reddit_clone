import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailTextEditingProvider = ChangeNotifierProvider<TextEditingController>(
  (ref) => TextEditingController(),
);

final passwordTextEditingProvider =
    ChangeNotifierProvider<TextEditingController>(
  (ref) => TextEditingController(),
);

