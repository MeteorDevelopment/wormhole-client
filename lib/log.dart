import 'package:loggy/loggy.dart';

final log = Loggy("Wormhole");

class MyLoggyPrinter extends LoggyPrinter {
  static final _levelColors = {
    LogLevel.debug: AnsiColor(foregroundColor: AnsiColor.grey(0.5), italic: true),
    LogLevel.info: AnsiColor(foregroundColor: 35),
    LogLevel.warning: AnsiColor(foregroundColor: 214),
    LogLevel.error: AnsiColor(foregroundColor: 196),
  };
  
  @override
  void onLog(LogRecord record) {
    final color = _levelColors[record.level] ?? AnsiColor();

    final logLevel = record.level
        .toString()
        .replaceAll('Level.', '')
        .toUpperCase()
        .padRight(8);
    
    final time = "${record.time.hour.toString().padLeft(2, '0')}:${record.time.minute.toString().padLeft(2, '0')}:${record.time.second.toString().padLeft(2, '0')}";

    // ignore: avoid_print
    print(color("$time $logLevel - ${record.message}"));
  }
}

void initLog() {
  Loggy.initLoggy(logPrinter: MyLoggyPrinter());

  log.info("Initializing");
}