import 'package:learn_dart_basic_ports_example/learn_dart_basic_ports_example.dart';

void main() async {
  final worker = Worker();
  await worker.spawn();
  await worker.parseJson('{"key":"value"}');
}
