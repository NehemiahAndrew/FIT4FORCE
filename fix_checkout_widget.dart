import 'dart:io';
import 'package:logger/logger.dart';

void main() {
  final logger = Logger();

  final checkoutWidgetPath =
      'C:\\Users\\NEHEMIAH\\AppData\\Local\\Pub\\Cache\\git\\flutter_paystack-a4a33c3dd0a12f46d655a2e63d11e9f20ba82d01\\lib\\src\\widgets\\checkout\\checkout_widget.dart';
  final buttonsPath =
      'C:\\Users\\NEHEMIAH\\AppData\\Local\\Pub\\Cache\\git\\flutter_paystack-a4a33c3dd0a12f46d655a2e63d11e9f20ba82d01\\lib\\src\\widgets\\buttons.dart';

  // Fix checkout_widget.dart
  try {
    logger.i('Fixing checkout_widget.dart...');
    final checkoutWidgetFile = File(checkoutWidgetPath);
    if (checkoutWidgetFile.existsSync()) {
      // Create backup
      final backupPath = '$checkoutWidgetPath.bak';
      checkoutWidgetFile.copySync(backupPath);
      logger.i('Created backup at $backupPath');

      // Read file content
      var content = checkoutWidgetFile.readAsStringSync();

      // Apply fixes
      content = content.replaceAll('bodyText1', 'bodyLarge');
      content = content.replaceAll('vsync: this,', '');

      // Write fixed content
      checkoutWidgetFile.writeAsStringSync(content);
      logger.i('Fixed checkout_widget.dart');
    } else {
      logger.w('File not found: $checkoutWidgetPath');
    }
  } catch (e) {
    logger.e('Error fixing checkout_widget.dart: $e');
  }

  // Fix buttons.dart
  try {
    logger.i('Fixing buttons.dart...');
    final buttonsFile = File(buttonsPath);
    if (buttonsFile.existsSync()) {
      // Create backup
      final backupPath = '$buttonsPath.bak';
      buttonsFile.copySync(backupPath);
      logger.i('Created backup at $backupPath');

      // Read file content
      var content = buttonsFile.readAsStringSync();

      // Apply fixes
      content = content.replaceAll('accentColor', 'colorScheme.secondary');

      // Write fixed content
      buttonsFile.writeAsStringSync(content);
      logger.i('Fixed buttons.dart');
    } else {
      logger.w('File not found: $buttonsPath');
    }
  } catch (e) {
    logger.e('Error fixing buttons.dart: $e');
  }

  logger.i('Done.');
}
