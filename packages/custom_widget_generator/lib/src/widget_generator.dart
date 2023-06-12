import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:custom_widget_annotation/custom_widget_annotation.dart';
import 'package:source_gen/source_gen.dart';

class CustomWidgetGenerator extends GeneratorForAnnotation<CustomWidget> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return _generateWidgetSource(element);
  }

  String _generateWidgetSource(Element element) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
    final sourceBuilder = StringBuffer();
    // Class name
    sourceBuilder
        .writeln("class ${visitor.className}Widget extends StatelessWidget{");

    // Constructor
    sourceBuilder.write("${visitor.className}Widget (");

    final parametersBuilder = StringBuffer();
    for (String parameterName in visitor.fields.keys) {
      parametersBuilder.write("this.$parameterName,");
    }
    sourceBuilder.write(parametersBuilder);
    sourceBuilder.writeln(");");
    for (String propertyName in visitor.fields.keys) {
      sourceBuilder
          .writeln("final ${visitor.fields[propertyName]} $propertyName;");
    }

    sourceBuilder.writeln("@override");
    sourceBuilder.writeln(
        "Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(12),child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,mainAxisSize: MainAxisSize.max,");
    sourceBuilder.writeln("children:<Widget>[");
    final textWidgets = StringBuffer();
    for (String paramName in visitor.fields.keys) {
      textWidgets.writeln("Text(\"$paramName = \$$paramName\"),");
    }
    sourceBuilder.writeln(textWidgets);
    sourceBuilder.writeln("],");
    sourceBuilder.writeln("),),);");
    sourceBuilder.writeln("}");

    return sourceBuilder.toString();
  }
}

class ModelVisitor extends SimpleElementVisitor {
  late DartType className;
  Map<String, DartType> fields = Map();

  @override
  visitConstructorElement(ConstructorElement element) {
    className = element.type.returnType;
    return super.visitConstructorElement(element);
  }

  @override
  visitFieldElement(FieldElement element) {
    fields[element.name] = element.type;

    return super.visitFieldElement(element);
  }
}
