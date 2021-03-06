import 'dart:async';

import 'package:courses_in_english/model/department/department.dart';

/// Provider for departments.
abstract class CacheDepartmentProvider {
  /// Get all departments.
  Future<Iterable<Department>> getDepartments();

  /// Get a department by its number.
  Future<Department> getDepartmentByNumber(int departmentNumber);

  Future<int> putDepartments(List<Department> departments);
}
