# wallet_connect_v2

WalletConnect V2 for Flutter, available for both Wallet and DApp!

Fully support at [Avacus](https://avacus.cc), you can experience both Mainnet and Testnet as it supports network customization.

Feel free to use and don't hesitate to raise issue if there are.

## Getting Started

We make very detail in example so you can follow it for both Wallet and Dapp.

The connection is kept stable follow app lifecycle.

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
// Wallet & DApp, listen to socket connection change
_client.onConnectionStatus = (isConnected) {
  // do something, for e.g update UI
}

// Wallet only, listen to session proposal from DApp
_client.onSessionProposal = (proposal) {
  // proposal request, handle to approve or reject
}

// Wallet & DApp, listen to new session which has been established
_client.onSessionSettle = (session) {
  // we have detail information of session
}

// Wallet & DApp
_client.onSessionUpdate = (topic) {
  // the session of topic has been updated
}

// Wallet & DApp
_client.onSessionDelete = (topic) {
  // the session of topic has been deleted
}

// Wallet & DApp
_client.onSessionRequest = (request) {
  // session request, handle to approve or reject
}

// DApp only, when Wallet reject the proposal
_client.onSessionRejection = (topic) {
  // handle rejection here, for e.g hide the uri popup
}

// DApp only, when Wallet approve and reject session request
_client.onSessionResponse = (topic) {
  // handle response here, for e.g update UI
}
```

Connect to listen event, for Wallet & DApp to connect to Relay service
```dart
_client.connect();
```

Disconnect, for Wallet & DApp to disconnect with Relay service
```dart
_client.disconnect();
```

Pair with DApps for Wallet only
```dart
_client.pair(uri: uri);
```

Approve session for Wallet only
```dart
_client.approveSession(approval: approval);
```

Reject session for Wallet only
```dart
_client.rejectSession(proposalId: proposal.id);
```

Disconnect session for Wallet & DApp
```dart
_client.disconnectSession(topic: topic);
```

Update session for Wallet & DApp
```dart
_client.updateSession(approval: updateApproval);
```

Approve request for Wallet only
```dart
_client.approveRequest(topic: topic, requestId: requestId, result: result);
```

Reject request for Wallet only
```dart
_client.rejectRequest(topic: topic, requestId: requestId);
```

Create pair for DApp only
```dart
_client.createPair(namespaces: namespaces);
```

Send request for DApp only
```dart
_client.sendRequest(request: request);
```