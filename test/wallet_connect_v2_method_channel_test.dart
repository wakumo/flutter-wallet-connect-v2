// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:wallet_connect_v2/wallet_connect_v2_method_channel.dart';
//
// void main() {
//   MethodChannelWalletConnectV2 platform = MethodChannelWalletConnectV2();
//   const MethodChannel channel = MethodChannel('wallet_connect_v2');
//
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });
//
//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });
//
//   test('getPlatformVersion', () async {
//     expect(await platform.getPlatformVersion(), '42');
//   });
// }
