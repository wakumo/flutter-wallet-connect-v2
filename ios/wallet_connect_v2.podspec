#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint wallet_connect_v2.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wallet_connect_v2'
  s.version          = '0.0.1'
  s.summary          = 'Wallet Connect V2 for Flutter'
  s.description      = <<-DESC
Wallet Connect V2 for Flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'WalletConnectSwiftV2', '1.6.12'
  s.dependency 'Starscream', '3.1.1'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
