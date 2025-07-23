import 'package:flutter/widgets.dart';

enum PageName { HOME, SETTINGS }

ValueNotifier<PageName> pagePositionNotifier = ValueNotifier<PageName>(
  PageName.HOME,
);
