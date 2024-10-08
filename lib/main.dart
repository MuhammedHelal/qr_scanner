import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:qr_reader/core/services/locator.dart';
import 'package:qr_reader/core/utils/strings.dart';
import 'package:qr_reader/features/history/domain/history_item_entity.dart';
import 'package:qr_reader/qr_scanner.dart';

import 'core/utils/bloc_observer.dart';

// v2.1.3-alpha.1
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  setupServiceLocator();

  await Hive.initFlutter();
  Hive.registerAdapter<HistoryItemEntity>(HistoryItemEntityAdapter());
  await Future.wait([
    Hive.openBox<HistoryItemEntity>(AppStrings.scannedHistoryBoxName),
    Hive.openBox<HistoryItemEntity>(AppStrings.generatedHistoryBoxName),
    Hive.openBox(AppStrings.settingsBoxName),
  ]);

  runApp(const QrScanner());
}
