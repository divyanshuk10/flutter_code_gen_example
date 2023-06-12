import 'package:analyzer/dart/element/element.dart';

import 'element_kind.dart';

class KnobProvider {
  /// Initialize a newly created element kind to have the given [displayName].
  const KnobProvider();

  String buildKnob(
    MyElementKind kind, {
    String label = "label",
    int intVal = 0,
    double doubleVal = 0.0,
    bool boolVal = false,
    String stringVal = "",
    List<FieldElement>? child = null,
  }) {
    String knob = "";
    switch (kind) {
      case MyElementKind.INT:
        knob = _buildForInt(label, intVal);
        break;
      case MyElementKind.DOUBLE:
        knob = _buildForDouble(label, doubleVal);
        break;
      case MyElementKind.STRING:
        knob = _buildForString(label, stringVal);
        break;
      case MyElementKind.BOOLEAN:
        knob = _buildForBoolean(label, boolVal);
        break;
      case MyElementKind.ENUM:
        knob = _buildForEnum(label, child);
        break;
      case MyElementKind.DATE_TIME:
        knob = _buildForDateAndTime();
        break;
    }
    return knob;
  }

  String _buildForEnum(String label, List<FieldElement>? child) {
    if (child == null || child.isEmpty) return "";

    var items = "[";

    for (FieldElement enumField in child) {
      var enumState = enumField.declaration.name.replaceAll(' ', '.');
      if (enumField.type.element?.kind == ElementKind.CLASS) {
        continue;
      } else {
        items += "'${enumState.toString()}',";
      }
    }
    items += "]";

    var enumResult =
        "DropdownButton<String>(value: defaultValue,hint: const Text('Select an option'),items: $items.map((String value) {return DropdownMenuItem<String>(value: value,child: Text(value),);}).toList(),onChanged: (vv) {setState(() {defaultValue = vv!;});},)";

    return enumResult;
  }

  String _buildForBoolean(String label, bool boolVal) =>
      "Text('$label $boolVal'),\n";

  String _buildForString(String label, String stringVal) =>
      "Text('$label $stringVal'),\n";

  String _buildForDouble(String label, double doubleVal) =>
      "Text('$label $doubleVal'),\n";

  String _buildForInt(String label, int intVal) => "Text('$label $intVal'),\n";

  String _buildForDateAndTime() =>
      "DatePickerDialog(initialDate: DateTime.now(),firstDate: DateTime.now().subtract(const Duration(days: 10)),lastDate: DateTime.now().add(const Duration(days: 10)))";
}
