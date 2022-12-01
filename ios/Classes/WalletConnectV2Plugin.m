#import "WalletConnectV2Plugin.h"
#if __has_include(<wallet_connect_v2/wallet_connect_v2-Swift.h>)
#import <wallet_connect_v2/wallet_connect_v2-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "wallet_connect_v2-Swift.h"
#endif

@implementation WalletConnectV2Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWalletConnectV2Plugin registerWithRegistrar:registrar];
}
@end
