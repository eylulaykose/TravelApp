import 'package:flutter/material.dart';

class VisitedNotifier extends ValueNotifier<int> {
  VisitedNotifier(int value) : super(value);
}

final visitedNotifier = VisitedNotifier(0); 