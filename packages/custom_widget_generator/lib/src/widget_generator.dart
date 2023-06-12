import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';
import 'package:custom_widget_annotation/custom_widget_annotation.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';

import 'element_kind.dart';
import 'knob_provider.dart';

final _dartfmt = DartFormatter();
const _kOverrideDecorator = CodeExpression(Code('override'));
const _kRoutePageDecorator = CodeExpression(Code('RoutePage()'));

class CustomWidgetGenerator extends GeneratorForAnnotation<CustomWidget> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return _generateWidgetSource(element);
  }

  FutureOr<String> _generateWidgetSource(Element element) {
    var visitor = ModelVisitor();
    element.visitChildren(visitor);
    return storybookClassBuilder(visitor);
  }

  String addKnobsToStory(ModelVisitor visitor) {
    var knobProvider = const KnobProvider();
    StringBuffer knob = StringBuffer();

    for (var paramName in visitor.fields.keys) {
      var type = visitor.fields[paramName]!;

      if (paramName.startsWith('_')) {
        continue;
      }
      if (type.element?.displayName == MyElementKind.INT ||
          type.element?.displayName == MyElementKind.INT_NULLABLE) {
        knob.write(
            '$paramName: ${knobProvider.buildKnob(MyElementKind.INT, label: paramName)}');
      } else if (type.element?.displayName == MyElementKind.STRING ||
          type.element?.displayName == MyElementKind.STRING_NULLABLE) {
        knob.write(
            '$paramName: ${knobProvider.buildKnob(MyElementKind.STRING, label: paramName)}');
      } else if (type.element?.displayName == MyElementKind.BOOLEAN ||
          type.element?.displayName == MyElementKind.BOOLEAN_NULLABLE) {
        knob.write(
            '$paramName: ${knobProvider.buildKnob(MyElementKind.BOOLEAN, label: paramName)}');
      } else if (type.element?.displayName == MyElementKind.DOUBLE ||
          type.element?.displayName == MyElementKind.DOUBLE_NULLABLE) {
        knob.write(
            '$paramName: ${knobProvider.buildKnob(MyElementKind.DOUBLE, label: paramName)}');
      } else if (type.isDartCoreEnum) {
        var enumValues = (type.element as EnumElement).fields;
        knob.write(
            '$paramName: ${knobProvider.buildKnob(MyElementKind.ENUM, label: paramName, child: enumValues)}');
      } else if (type.element?.displayName == MyElementKind.DATE_TIME ||
          type.element?.displayName == MyElementKind.DATE_TIME_NULLABLE) {
        knob.write(
            '$paramName: ${knobProvider.buildKnob(MyElementKind.DATE_TIME, label: paramName)}');
      } else {}
    }
    return knob.toString();
  }

  String storybookClassBuilder(ModelVisitor visitor) {
    var className = "${visitor.classname}";
    List<Field> fields = [];

    var annotationListBuilder = ListBuilder<Expression>();
    Expression override = _kOverrideDecorator;
    annotationListBuilder.add(override);

    var classAnnotationListBuilder = ListBuilder<Expression>();
    Expression routePage = _kRoutePageDecorator;
    classAnnotationListBuilder.add(routePage);

    var methodParamsListBuilder = ListBuilder<Parameter>();
    var paramBuilder = ParameterBuilder();
    paramBuilder.name = 'context';
    paramBuilder.type = const Reference("BuildContext");
    methodParamsListBuilder.add(paramBuilder.build());

    for (var paramName in visitor.fields.keys) {
      var fb = FieldBuilder();
      fb.name = paramName;
      fb.type = Reference(visitor.fields[paramName].toString());
      fields.add(fb.build());
    }

    var cb = ConstructorBuilder();
    cb.constant = true;

    var mb = MethodBuilder();
    mb.annotations = annotationListBuilder;
    mb.name = "build";
    mb.returns = Reference('Widget');
    mb.body = Block.of(
      [
        Code(
            "return Scaffold(body: Column(children: [${addKnobsToStory(visitor)}],),);")
      ],
    );
    mb.requiredParameters = methodParamsListBuilder;

    var db = ListBuilder<String>();
    db.add("import 'package:tab_gsd/common_imports.dart';\n");

    final myClass = Class((b) => b
      ..annotations = classAnnotationListBuilder
      ..name = "${className}Widget"
      ..docs = db
      ..extend = refer('StatelessWidget')
      ..methods.add(mb.build())
      ..constructors.add(cb.build()));

    return _dartfmt.format(
        '${myClass.accept(DartEmitter(useNullSafetySyntax: true, allocator: Allocator.simplePrefixing(), orderDirectives: true))}');
  }
}

class ModelVisitor extends SimpleElementVisitor {
  late DartType classname;
  Map<String, DartType> fields = {};

  @override
  visitConstructorElement(ConstructorElement element) {
    classname = element.type.returnType;
  }

  @override
  visitFieldElement(FieldElement element) {
    fields[element.name] = element.type;
  }
}
