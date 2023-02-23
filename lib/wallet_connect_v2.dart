import 'dart:async';

import 'package:flutter/services.dart';

import 'src/model/app_metadata.dart';
import 'src/model/connection_status.dart';
import 'src/model/proposal_namespace.dart';
import 'src/model/request.dart';
import 'src/model/session.dart';
import 'src/model/session_approval.dart';
import 'src/model/session_delete.dart';
import 'src/model/session_proposal.dart';
import 'src/model/session_rejection.dart';
import 'src/model/session_request.dart';
import 'src/model/session_response.dart';
import 'src/model/session_update.dart';
import 'wallet_connect_v2_platform_interface.dart';

export 'src/model/app_metadata.dart';
export 'src/model/proposal_namespace.dart';
export 'src/model/request.dart';
export 'src/model/session.dart';
export 'src/model/session_approval.dart';
export 'src/model/session_namespace.dart';
export 'src/model/session_proposal.dart';
export 'src/model/session_request.dart';
export 'src/model/session_response.dart';

class WalletConnectV2 {
  StreamSubscription? _eventSubscription;

  OnConnectionStatus? onConnectionStatus;
  OnSessionProposal? onSessionProposal;
  OnSessionSettle? onSessionSettle;
  OnSessionUpdate? onSessionUpdate;
  OnSessionDelete? onSessionDelete;
  OnSessionRequest? onSessionRequest;
  OnEventError? onEventError;

  /// DAPP only, listen to action of reject proposal from wallet
  OnSessionRejection? onSessionRejection;

  /// DAPP only, listen to action of approve/reject request from wallet
  OnSessionResponse? onSessionResponse;

  Future<void> init(
      {required String projectId, required AppMetadata appMetadata}) {
    _eventSubscription =
        WalletConnectV2Platform.instance.onEvent.listen((event) {
      if (event is ConnectionStatus) {
        onConnectionStatus?.call(event.isConnected);
      } else if (event is SessionProposal) {
        onSessionProposal?.call(event);
      } else if (event is Session) {
        onSessionSettle?.call(event);
      } else if (event is SessionRequest) {
        onSessionRequest?.call(event);
      } else if (event is SessionUpdate) {
        onSessionUpdate?.call(event.topic);
      } else if (event is SessionDelete) {
        onSessionDelete?.call(event.topic);
      } else if (event is SessionRejection) {
        onSessionRejection?.call(event.topic);
      } else if (event is SessionResponse) {
        onSessionResponse?.call(event);
      }
    }, onError: (error) {
      if (error is PlatformException) {
        onEventError?.call(error.code, error.message ?? "Internal error");
      } else {
        onEventError?.call('general_error', "Internal error");
      }
    });
    return WalletConnectV2Platform.instance
        .init(projectId: projectId, appMetadata: appMetadata);
  }

  Future<void> connect() {
    return WalletConnectV2Platform.instance.connect();
  }

  Future<void> disconnect() {
    return WalletConnectV2Platform.instance.disconnect();
  }

  Future<void> pair({required String uri}) {
    return WalletConnectV2Platform.instance.pair(uri: uri);
  }

  Future<void> approveSession({required SessionApproval approval}) {
    return WalletConnectV2Platform.instance.approve(approval: approval);
  }

  Future<void> rejectSession({required String proposalId}) {
    return WalletConnectV2Platform.instance.reject(proposalId: proposalId);
  }

  Future<List<Session>> getActivatedSessions() {
    return WalletConnectV2Platform.instance.getActivatedSessions();
  }

  Future<void> disconnectSession({required String topic}) {
    return WalletConnectV2Platform.instance.disconnectSession(topic: topic);
  }

  Future<void> updateSession({required SessionApproval updateApproval}) {
    return WalletConnectV2Platform.instance
        .updateSession(updateApproval: updateApproval);
  }

  Future<void> approveRequest(
      {required String topic,
      required String requestId,
      required String result}) {
    return WalletConnectV2Platform.instance
        .approveRequest(topic: topic, requestId: requestId, result: result);
  }

  Future<void> rejectRequest(
      {required String topic, required String requestId}) {
    return WalletConnectV2Platform.instance
        .rejectRequest(topic: topic, requestId: requestId);
  }

  /// DAPP only, to create PAIR URI to pair with wallet
  Future<String?> createPair(
      {required Map<String, ProposalNamespace> namespaces}) {
    return WalletConnectV2Platform.instance.createPair(namespaces: namespaces);
  }

  /// DAPP only, to send request to wallet
  Future<void> sendRequest({required Request request}) {
    return WalletConnectV2Platform.instance.sendRequest(request: request);
  }

  Future dispose() async {
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }
}

typedef OnConnectionStatus = Function(bool isConnected);
typedef OnSessionProposal = Function(SessionProposal proposal);
typedef OnSessionSettle = Function(Session session);
typedef OnSessionUpdate = Function(String topic);
typedef OnSessionDelete = Function(String topic);
typedef OnSessionRejection = Function(String topic);
typedef OnSessionResponse = Function(SessionResponse response);
typedef OnSessionRequest = Function(SessionRequest request);
typedef OnEventError = Function(String code, String message);
