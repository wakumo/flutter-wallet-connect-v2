// import 'package:flutter_test/flutter_test.dart';
// import 'package:wallet_connect_v2/wallet_connect_v2.dart';
// import 'package:wallet_connect_v2/wallet_connect_v2_platform_interface.dart';
// import 'package:wallet_connect_v2/wallet_connect_v2_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockWalletConnectV2Platform
//     with MockPlatformInterfaceMixin
//     implements WalletConnectV2Platform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final WalletConnectV2Platform initialPlatform = WalletConnectV2Platform.instance;
//
//   test('$MethodChannelWalletConnectV2 is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelWalletConnectV2>());
//   });
//
//   test('getPlatformVersion', () async {
//     WalletConnectV2 walletConnectV2Plugin = WalletConnectV2();
//     MockWalletConnectV2Platform fakePlatform = MockWalletConnectV2Platform();
//     WalletConnectV2Platform.instance = fakePlatform;
//
//     expect(await walletConnectV2Plugin.getPlatformVersion(), '42');
//   });
// }
