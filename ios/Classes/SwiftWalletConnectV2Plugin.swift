import Flutter
import WalletConnectSwiftV2
import UIKit
import Starscream
import Combine

public class SwiftWalletConnectV2Plugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var publishers = [AnyCancellable]()
    
    private var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "wallet_connect_v2", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(
              name: "wallet_connect_v2/event",
              binaryMessenger: registrar.messenger())
        let instance = SwiftWalletConnectV2Plugin()
        eventChannel.setStreamHandler(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init": do {
                let arguments = call.arguments as! [String: Any]
                let projectId = arguments["projectId"] as! String
                var appMetadata = arguments["appMetadata"] as! [String: Any]
                if (appMetadata["redirect"] != nil) {
                    appMetadata["redirect"] = [
                        "native": (appMetadata["redirect"] as! String).starts(with: "http") ? nil : (appMetadata["redirect"] as? String),
                        "universal": (appMetadata["redirect"] as! String).starts(with: "http") ? (appMetadata["redirect"] as? String) : nil,
                    ];
                }
                let metadata: AppMetadata = try! JSONDecoder().decode(AppMetadata.self, from: JSONSerialization.data(withJSONObject: appMetadata))
                
                Networking.configure(projectId: projectId, socketFactory: SocketFactory(), socketConnectionType: .manual)
            
                Pair.configure(metadata: metadata)
                
                Sign.instance.socketConnectionStatusPublisher
                            .receive(on: DispatchQueue.main)
                            .sink { [weak self] status in
                                self?.onEvent(name: "connection_status", data: [
                                    "isConnected": status == .connected
                                ])
                            }.store(in: &publishers)
                
                Sign.instance.sessionProposalPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] sessionProposal in
                        self?.onEvent(name: "proposal", data: [
                            "id": sessionProposal.proposal.id,
                            "proposer": sessionProposal.proposal.proposer.toFlutterValue(),
                            "namespaces": sessionProposal.proposal.requiredNamespaces.mapValues { value in value.toFlutterValue()
                            },
                            "optionalNamespaces": sessionProposal.proposal.optionalNamespaces?.mapValues { value in value.toFlutterValue()
                            } as Any
                        ])
                    }.store(in: &publishers)
                
                Sign.instance.sessionSettlePublisher
                            .receive(on: DispatchQueue.main)
                            .sink { [weak self] session in
                                self?.onEvent(name: "session_settle", data: [
                                    "topic": session.topic,
                                    "peer": session.peer.toFlutterValue(),
                                    "expiration": session.expiryDate.toUtcIsoDateString(),
                                    "namespaces": session.namespaces.mapValues { value in value.toFlutterValue()
                                    }
                                ])
                            }.store(in: &publishers)
            
                Sign.instance.sessionDeletePublisher
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] session in
                            self?.onEvent(name: "session_delete", data: [
                                "topic": session.0
                            ])
                        }.store(in: &publishers)
            
                Sign.instance.sessionUpdatePublisher
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] session in
                        self?.onEvent(name: "session_update", data: [
                            "topic": session.0
                        ])
                    }.store(in: &publishers)
            
                Sign.instance.sessionRequestPublisher
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] request in
                            self?.onEvent(name: "session_request", data: request.request.toFlutterValue())
                        }.store(in: &publishers)
            
                Sign.instance.sessionResponsePublisher
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] response in
                            self?.onEvent(name: "session_response", data: response.toFlutterValue())
                        }.store(in: &publishers)
            
                Sign.instance.sessionRejectionPublisher
                        .receive(on: DispatchQueue.main)
                        .sink { [weak self] rejection in
                            self?.onEvent(name: "session_rejection", data: toRejectionValue(rejection: rejection))
                        }.store(in: &publishers)

            result(nil)
        }
        case "connect": do {
            do {
                try Networking.instance.connect()
            } catch let error {
                onError(code: "connect_error", errorMessage: error.localizedDescription)
            }
            result(nil)
        }
        case "disconnect": do {
            do {
                try Networking.instance.disconnect(closeCode: URLSessionWebSocketTask.CloseCode(rawValue: 1000)!)
            } catch let error {
                onError(code: "disconnect_error", errorMessage: error.localizedDescription)
            }
            result(nil)
        }
        case "pair": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: Any]
                    let wcUri = WalletConnectURI(string: arguments["uri"] as! String)
                    if (wcUri == nil) {
                        result(nil)
                        onError(code: "pair_error", errorMessage: "Pairing with DApp not success due to wrong URI")
                        return
                    }
                    try await Pair.instance.pair(uri: wcUri!)
                } catch let error {
                    onError(code: "pair_error", errorMessage: error.localizedDescription)
                }
                result(nil)
            }
        }
        case "approve": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: Any]
                    let rawNamespaces = arguments["namespaces"] as! [String: [String: Any]]
                    let namespaces = rawNamespaces.mapValues {
                        SessionNamespace(accounts: Set(($0["accounts"] as! [String]).map{ account in
                            Account(account)!
                        }), methods: Set($0["methods"] as! [String]), events: Set($0["events"] as! [String]))
                    }
                    try await Sign.instance.approve(proposalId: arguments["id"] as! String, namespaces: namespaces)
                } catch let error {
                    onError(code: "approve_error", errorMessage: error.localizedDescription)
                }
                result(nil)
            }
        }
        case "reject": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: Any]
                    try await Sign.instance.reject(proposalId: arguments["id"] as! String, reason: .userRejected)
                } catch let error {
                    onError(code: "reject_error", errorMessage: error.localizedDescription)
                }
                result(nil)
            }
        }
        case "getActivatedSessions": do {
            let sessions = Sign.instance.getSessions()
            result(sessions.map { value in [
                "topic": value.topic,
                "peer": value.peer.toFlutterValue(),
                "expiration": value.expiryDate.toUtcIsoDateString(),
                "namespaces": value.namespaces.mapValues { value in value.toFlutterValue()
                },
            ] })
        }
        case "disconnectSession": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: Any]
                    try await Sign.instance.disconnect(topic: arguments["topic"] as! String)
                } catch let error {
                    onError(code: "disconnect_session_error", errorMessage: error.localizedDescription)
                }
                result(nil)
            }
        }
        case "updateSession": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: Any]
                    let rawNamespaces = arguments["namespaces"] as! [String: [String: Any]]
                    let namespaces = rawNamespaces.mapValues {
                        SessionNamespace(accounts: Set(($0["accounts"] as! [String]).map{ account in
                            Account(account)!
                        }), methods: Set($0["methods"] as! [String]), events: Set($0["events"] as! [String]))
                    }
                    try await Sign.instance.update(topic: arguments["id"] as! String, namespaces: namespaces)
                } catch let error {
                    onError(code: "update_session_error", errorMessage: error.localizedDescription)
                }
                result(nil)
            }
        }
        case "approveRequest": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: Any]
                    let requestId = RPCID(Int64(arguments["requestId"] as! String)!)
                    try await Sign.instance.respond(topic: arguments["topic"] as! String, requestId: requestId, response: .response(RPCResponse(id: requestId, result: arguments["result"] as! String).result!))
                } catch let error {
                    onError(code: "approve_request_error", errorMessage: error.localizedDescription)
                }
                result(nil)
            }
        }
        case "rejectRequest": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: Any]
                    let requestId = RPCID(Int64(arguments["requestId"] as! String)!)
                    try await Sign.instance.respond(topic: arguments["topic"] as! String, requestId: requestId, response: .error(JSONRPCError(code: 4001, message: "User rejected the request")))
                } catch let error {
                    onError(code: "reject_request_error", errorMessage: error.localizedDescription)
                }
                result(nil)
            }
        }
        case "createPair": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: [String: Any]]
                    let namespaces = arguments.mapValues { value in
                        let chains = (value["chains"] as! Array).map { chain in
                            Blockchain(chain)!
                        }
                        let methods = Set(value["methods"] as! [String])
                        let events = Set(value["events"] as! [String])
                        return ProposalNamespace(chains: Set(chains), methods: methods, events: events)
                    }
                    let uri = try await Pair.instance.create()
                    try await Sign.instance.connect(requiredNamespaces: namespaces, topic: uri.topic)
                    result(uri.absoluteString)
                } catch let error {
                    onError(code: "create_pair_error", errorMessage: error.localizedDescription)
                    result(nil)
                }
            }
        }
        case "sendRequest": do {
            Task {
                do {
                    let arguments = call.arguments as! [String: Any]
                    let topic = arguments["topic"] as! String
                    let method = arguments["method"] as! String
                    let chainId = Blockchain(arguments["chainId"] as! String)!
                    let requestParams: AnyCodable = try! JSONDecoder().decode(AnyCodable.self, from: JSONSerialization.data(withJSONObject: arguments["params"]!))
                    let request = Request(topic: topic, method: method, params: requestParams, chainId: chainId)
                    try await Sign.instance.request(params: request)
                } catch let error {
                    onError(code: "send_request_error", errorMessage: error.localizedDescription)
                }
                result(nil)
            }
        }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
    
    private func onEvent(name: String, data: NSDictionary) {
        DispatchQueue.main.async {
          self.eventSink?([
            "name": name,
            "data": data
          ])
        }
      }
    
    private func onError(code: String, errorMessage: String = "") {
        DispatchQueue.main.async {
            self.eventSink?(self.toFlutterError(code: code, errorMessage: errorMessage))
        }
      }
    
    private func toFlutterError(code: String, errorMessage: String = "") -> FlutterError {
        return FlutterError(code: code,
                            message: errorMessage,
                            details: nil);
    }
}

extension WebSocket: WebSocketConnecting { }

struct SocketFactory: WebSocketFactory {
    func create(with url: URL) -> WebSocketConnecting {
        return WebSocket(url: url)
    }
}

extension AppMetadata {
    func toFlutterValue() -> NSDictionary {
        return [
            "name": self.name,
            "description": self.description,
            "url": self.url,
            "icons": self.icons,
            "redirect": self.redirect?.universal != nil ? self.redirect?.universal as Any : self.redirect?.native as Any
        ];
    }
}

extension ProposalNamespace {
    func toFlutterValue() -> NSDictionary {
        return [
            "chains": self.chains?.map( { String($0) }) as Any,
            "methods": Array(self.methods),
            "events": Array(self.events)
        ];
    }
}

extension SessionNamespace {
    func toFlutterValue() -> NSDictionary {
        return [
            "accounts": Array(self.accounts).map( { String($0) }),
            "methods": Array(self.methods),
            "events": Array(self.events),
            "chains": self.chains?.map( { String($0) }) as Any,
        ];
    }
}

extension Request {
    func toFlutterValue() -> NSDictionary {
        return [
            "id": try! self.id.json(),
            "topic": self.topic,
            "chainId": String(self.chainId),
            "method": self.method,
            "params": try! self.params.json()
        ];
    }
}

extension Response {
    func toFlutterValue() -> NSDictionary {
        return [
            "id": try! self.id.json(),
            "topic": self.topic,
            "results": try! self.result.json()
        ];
    }
}

extension Date {
    func toUtcIsoDateString() -> String {
        let utcISODateFormatter = ISO8601DateFormatter()
        return utcISODateFormatter.string(from: self);
    }
}

func toRejectionValue(rejection: (Session.Proposal, Reason)) -> NSDictionary {
    return [
        "topic": rejection.0.pairingTopic
    ];
}
