import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

class Worker {
  final Completer _isolateReady = Completer.sync();
  late final SendPort _sendPort;

  Future<void> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponsesFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
      return;
    }
    if (message is Map<String, dynamic>) {
      print(message);
    }
  }

  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);

    receivePort.listen((message) async {
      if (message is String) {
        final transformed = jsonDecode(message);
        port.send(transformed);
      }
    });
  }

  Future<void> parseJson(String message) async {
    await _isolateReady.future;
    _sendPort.send(message);
  }
}
