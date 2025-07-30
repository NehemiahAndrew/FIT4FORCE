import 'dart:io';
import 'package:logger/logger.dart';

void main() async {
  final logger = Logger();

  logger.i('Running comprehensive Flutter fixes...');

  // Fix checkout_widget.dart
  final checkoutWidgetPath =
      'lib\\src\\widgets\\checkout\\checkout_widget.dart';
  final checkoutWidgetFile = File(checkoutWidgetPath);

  if (checkoutWidgetFile.existsSync()) {
    logger.i('Found checkout_widget.dart at $checkoutWidgetPath');

    // Create backup
    final backupPath = '$checkoutWidgetPath.bak3';
    checkoutWidgetFile.copySync(backupPath);
    logger.i('Created backup at $backupPath');

    // Read file content
    var content = checkoutWidgetFile.readAsStringSync();

    // Fix TabController
    content = content.replaceAll(
      '_tabController = new TabController(',
      '_tabController = new TabController(vsync: this,',
    );

    // Fix AnimationController
    content = content.replaceAll(
      '_animationController = new AnimationController(',
      '_animationController = new AnimationController(vsync: this,',
    );

    // Fix bodyText1
    content = content.replaceAll('bodyText1', 'bodyLarge');

    // Fix accentColor properly
    content = content.replaceAll(
      'final accentColor = Theme.of(context).accentColor;',
      'final accentColor = Theme.of(context).colorScheme.secondary;',
    );

    // Fix colorScheme.secondary variable declaration
    content = content.replaceAll(
      'final colorScheme.secondary = Theme.of(context).colorScheme.secondary;',
      'final accentColor = Theme.of(context).colorScheme.secondary;',
    );

    // Fix buildCheckoutMethods
    content = content.replaceAll(
      'Widget buildCheckoutMethods(Color colorScheme.secondary) {',
      'Widget buildCheckoutMethods(Color accentColor) {',
    );

    // Fix colorScheme.secondary usage
    content = content.replaceAll('colorScheme.secondary', 'accentColor');

    // Write fixed content
    checkoutWidgetFile.writeAsStringSync(content);
    logger.i('Fixed checkout_widget.dart');
  } else {
    logger.w('File not found: $checkoutWidgetPath');
  }

  // Fix error_widget.dart
  final errorWidgetPath = 'lib\\src\\widgets\\error_widget.dart';
  final errorWidgetFile = File(errorWidgetPath);

  if (errorWidgetFile.existsSync()) {
    logger.i('Found error_widget.dart at $errorWidgetPath');

    // Create backup
    final backupPath = '$errorWidgetPath.bak3';
    errorWidgetFile.copySync(backupPath);
    logger.i('Created backup at $backupPath');

    // Read file content
    var content = errorWidgetFile.readAsStringSync();

    // Fix constructor
    content = content.replaceAll(
      'ErrorWidget({required this.vSync,',
      'ErrorWidget({required this.vSync,',
    );

    // Remove duplicate vSync parameter
    content = content.replaceAll('required this.vSync,', '');

    // Write fixed content
    errorWidgetFile.writeAsStringSync(content);
    logger.i('Fixed error_widget.dart');
  } else {
    logger.w('File not found: $errorWidgetPath');
  }

  // Fix successful_widget.dart
  final successfulWidgetPath =
      'lib\\src\\widgets\\sucessful_widget.dart';
  final successfulWidgetFile = File(successfulWidgetPath);

  if (successfulWidgetFile.existsSync()) {
    logger.i('Found sucessful_widget.dart at $successfulWidgetPath');

    // Create backup
    final backupPath = '$successfulWidgetPath.bak3';
    successfulWidgetFile.copySync(backupPath);
    logger.i('Created backup at $backupPath');

    // Read file content
    var content = successfulWidgetFile.readAsStringSync();

    // Fix AnimationController
    content = content.replaceAll(
      '_mainController = new AnimationController(',
      '_mainController = new AnimationController(vsync: this,',
    );

    content = content.replaceAll(
      '_countdownController = new AnimationController(',
      '_countdownController = new AnimationController(vsync: this,',
    );

    content = content.replaceAll(
      '_opacityController = new AnimationController(',
      '_opacityController = new AnimationController(vsync: this,',
    );

    // Fix colorScheme.secondary variable declaration
    content = content.replaceAll(
      'final colorScheme.secondary = Theme.of(context).colorScheme.secondary;',
      'final accentColor = Theme.of(context).colorScheme.secondary;',
    );

    // Fix colorScheme.secondary usage
    content = content.replaceAll('colorScheme.secondary', 'accentColor');

    // Write fixed content
    successfulWidgetFile.writeAsStringSync(content);
    logger.i('Fixed sucessful_widget.dart');
  } else {
    logger.w('File not found: $successfulWidgetPath');
  }

  // Fix bank_checkout.dart
  final bankCheckoutPath =
      'lib\\src\\widgets\\checkout\\bank_checkout.dart';
  final bankCheckoutFile = File(bankCheckoutPath);

  if (bankCheckoutFile.existsSync()) {
    logger.i('Found bank_checkout.dart at $bankCheckoutPath');

    // Create backup
    final backupPath = '$bankCheckoutPath.bak3';
    bankCheckoutFile.copySync(backupPath);
    logger.i('Created backup at $backupPath');

    // Read file content
    var content = bankCheckoutFile.readAsStringSync();

    // Fix AnimationController
    content = content.replaceAll(
      '_controller = new AnimationController(',
      '_controller = new AnimationController(vsync: this,',
    );

    // Fix accentColor properly
    content = content.replaceAll(
      'color: Theme.of(context).accentColor,',
      'color: Theme.of(context).colorScheme.secondary,',
    );

    // Write fixed content
    bankCheckoutFile.writeAsStringSync(content);
    logger.i('Fixed bank_checkout.dart');
  } else {
    logger.w('File not found: $bankCheckoutPath');
  }

  // Fix buttons.dart
  final buttonsPath = 'lib\\src\\widgets\\buttons.dart';
  final buttonsFile = File(buttonsPath);

  if (buttonsFile.existsSync()) {
    logger.i('Found buttons.dart at $buttonsPath');

    // Create backup
    final backupPath = '$buttonsPath.bak3';
    buttonsFile.copySync(backupPath);
    logger.i('Created backup at $backupPath');

    // Read file content
    var content = buttonsFile.readAsStringSync();

    // Fix accentColor properly
    content = content.replaceAll(
      'color: Theme.of(context).accentColor,',
      'color: Theme.of(context).colorScheme.secondary,',
    );

    // Fix copyWith
    content = content.replaceAll(
      '.copyWith(accentColor: Colors.white)',
      '.copyWith(colorScheme: ColorScheme.dark(secondary: Colors.white))',
    );

    // Write fixed content
    buttonsFile.writeAsStringSync(content);
    logger.i('Fixed buttons.dart');
  } else {
    logger.w('File not found: $buttonsPath');
  }

  logger.i('All fixes applied successfully!');
  logger.i('Run "flutter pub get" to update the package.');
}
