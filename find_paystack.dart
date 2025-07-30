import 'dart:io';
import 'package:logger/logger.dart';

void main() {
  final logger = Logger();

  final pubCachePath =
      Platform.isWindows
          ? '${Platform.environment['LOCALAPPDATA']}\\Pub\\Cache'
          : '${Platform.environment['HOME']}/.pub-cache';

  logger.i('Pub cache path: $pubCachePath');

  // Check if the directory exists
  final pubCacheDir = Directory(pubCachePath);
  if (!pubCacheDir.existsSync()) {
    logger.w('Pub cache directory not found at $pubCachePath');
    return;
  }

  // Look for the Flutter package
  final gitDir = Directory('$pubCachePath\\git');
  if (!gitDir.existsSync()) {
    logger.w('Git directory not found at ${gitDir.path}');
    return;
  }

  // List all directories in the git directory
  final gitDirs = gitDir.listSync();
  for (final dir in gitDirs) {
    if (dir is Directory) {
      logger.i('Found Flutter package at ${dir.path}');

      // Check if the problematic files exist
      final checkoutWidgetPath =
          '${dir.path}\\lib\\src\\widgets\\checkout\\checkout_widget.dart';
      final checkoutWidgetFile = File(checkoutWidgetPath);
      if (checkoutWidgetFile.existsSync()) {
        logger.i('Found checkout_widget.dart at $checkoutWidgetPath');

        // Read the file content
        final content = checkoutWidgetFile.readAsStringSync();

        // Check if the file contains the problematic code
        if (content.contains('bodyText1')) {
          logger.w('File contains bodyText1, needs to be fixed');
        }

        if (content.contains('vsync: this')) {
          logger.w('File contains vsync: this, needs to be fixed');
        }
      }

      final buttonsPath = '${dir.path}\\lib\\src\\widgets\\buttons.dart';
      final buttonsFile = File(buttonsPath);
      if (buttonsFile.existsSync()) {
        logger.i('Found buttons.dart at $buttonsPath');

        // Read the file content
        final content = buttonsFile.readAsStringSync();

        // Check if the file contains the problematic code
        if (content.contains('accentColor')) {
          logger.w('File contains accentColor, needs to be fixed');
        }
      }
    }
  }
}
