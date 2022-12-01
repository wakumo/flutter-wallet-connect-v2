# wallet_connect_v2

WalletConnect V2 for Flutter

This lib came from the demand of our project [Avacus](https://avacus.cc)

We used to try to make in pure Dart but it cost much time to build and test so we decide to make an wrapper to consume SDKs from WalletConnect team!

## Getting Started

We make very detail in example so you can follow it.

Import and create instance
```dart
import 'package:wallet_connect_v2/wallet_connect_v2.dart';

final _client = WalletConnectV2();
```

Initiate WalletConnect SDK
```dart
_client.init(projectId: projectId, appMetadata: walletMetadata);
```

Listen needed events from our export
```dart
typedef OnConnectionStatus = Function(bool isConnected);
typedef OnSessionProposal = Function(SessionProposal proposal);
typedef OnSessionSettle = Function(Session session);
typedef OnSessionUpdate = Function(String topic);
typedef OnSessionDelete = Function(String topic);
typedef OnSessionRequest = Function(SessionRequest request);
typedef OnEventError = Function(String code, String message);

// example of listen to session proposal
_client.onSessionProposal = (proposal) {
  // do approve and reject session here
}
```

Connect to listen event
```dart
_client.connect();
```

Disconnect
```dart
_client.disconnect();
```

Pair with DApps
```dart
_client.pair(uri: uri);
```

Approve session
```dart
_client.approveSession(approval: approval);
```

Reject session
```dart
_client.rejectSession(proposalId: proposal.id);
```

Disconnect session
```dart
_client.disconnectSession(topic: topic);
```

Update session
```dart
_client.updateSession(approval: updateApproval);
```

Approve request
```dart
_client.approveRequest(topic: topic, requestId: requestId, result: result);
```

Reject request
```dart
_client.rejectRequest(topic: topic, requestId: requestId);
```