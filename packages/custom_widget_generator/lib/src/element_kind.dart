import 'package:analyzer/dart/element/element.dart';

class MyElementKind implements Comparable<ElementKind> {
  /// The name of this element kind.
  final String name;

  /// The ordinal value of the element kind.
  final int ordinal;

  /// The name displayed in the UI for this kind of element.
  final String displayName;

  /// Initialize a newly created element kind to have the given [displayName].
  const MyElementKind(this.displayName, this.ordinal, this.name);

  static const MyElementKind INT = MyElementKind('int', 101, "INT");
  static const MyElementKind INT_NULLABLE = MyElementKind('int?', 102, "INT");
  static const MyElementKind DOUBLE = MyElementKind('double', 103, "WIDGET");
  static const MyElementKind DOUBLE_NULLABLE =
      MyElementKind('double?', 104, "WIDGET");
  static const MyElementKind BOOLEAN = MyElementKind('bool', 105, "BOOL");
  static const MyElementKind BOOLEAN_NULLABLE =
      MyElementKind('bool?', 106, "BOOL");
  static const MyElementKind STRING = MyElementKind('String', 107, "STRING");
  static const MyElementKind STRING_NULLABLE =
      MyElementKind('String?', 108, "STRING");
  static const MyElementKind ENUM = MyElementKind('enum', 109, "ENUM");
  static const MyElementKind DATE_TIME =
      MyElementKind('DateTime', 110, "DATE_TIME");
  static const MyElementKind DATE_TIME_NULLABLE =
      MyElementKind('DateTime?', 111, "DATE_TIME");

  @override
  int compareTo(ElementKind other) => displayName.compareTo(other.displayName);
}
