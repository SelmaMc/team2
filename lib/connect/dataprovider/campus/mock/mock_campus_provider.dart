import 'dart:async';

import 'package:courses_in_english/connect/dataprovider/campus/campus_provider.dart';
import 'package:courses_in_english/connect/dataprovider/mock_data.dart';
import 'package:courses_in_english/model/campus/campus.dart';

/// Provider for campuses providing mock data.
class MockCampusProvider implements CampusProvider {
  static const List<Campus> CAMPUSES = const <Campus>[
    campus01,
    campus02,
    campus03
  ];

  @override
  Future<List<Campus>> getCampuses() async =>
      new Future.delayed(const Duration(seconds: 2), () => CAMPUSES);
}