import 'package:build/build.dart';
import 'package:custom_widget_generator/src/widget_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder tabWidgetBuilder(BuilderOptions options) =>
    SharedPartBuilder([CustomWidgetGenerator()], 'custom_widget');
