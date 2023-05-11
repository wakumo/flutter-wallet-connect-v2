package com.avacus.wallet_connect_v2

import android.app.Activity
import android.app.Application
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.walletconnect.android.Core
import com.walletconnect.android.CoreClient
import com.walletconnect.android.relay.ConnectionType
import com.walletconnect.sign.client.Sign
import com.walletconnect.sign.client.SignClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*

/** WalletConnectV2Plugin */
class WalletConnectV2Plugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    EventChannel.StreamHandler {
    private lateinit var context: Application
    private var activity: Activity? = null

    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext as Application
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wallet_connect_v2")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "wallet_connect_v2/event")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> {
                val arguments = call.arguments<Map<String, Any>>()
                val projectId = arguments?.get("projectId")
                val serverUrl = "wss://relay.walletconnect.com?projectId=$projectId"
                val connectionType = ConnectionType.MANUAL

                val gson = Gson()
                val appMetaData = gson.fromJson(
                    gson.toJson(arguments?.get("appMetadata")), Core.Model.AppMetaData::class.java
                )

                CoreClient.initialize(
                    relayServerUrl = serverUrl,
                    connectionType = connectionType,
                    application = context,
                    metaData = appMetaData
                ) {
                    onError(
                        "init_core_error", errorMessage = it.throwable.message ?: ""
                    )
                }

                val init = Sign.Params.Init(core = CoreClient)

                SignClient.initialize(init) {
                    onError("init_sign_error", errorMessage = it.throwable.message ?: "")
                }

                val walletDelegate = object : SignClient.WalletDelegate {
                    override fun onSessionProposal(sessionProposal: Sign.Model.SessionProposal) {
                        onEvent(
                            name = "proposal", data = sessionProposal.toFlutterValue()
                        )
                    }

                    override fun onSessionRequest(sessionRequest: Sign.Model.SessionRequest) {
                        onEvent(
                            name = "session_request", data = sessionRequest.toFlutterValue()
                        )
                    }

                    override fun onSessionDelete(deletedSession: Sign.Model.DeletedSession) {
                        if (deletedSession is Sign.Model.DeletedSession.Success) {
                            onEvent(
                                name = "session_delete", data = mapOf(
                                    "topic" to deletedSession.topic
                                )
                            )
                        }
                    }

                    override fun onSessionSettleResponse(settleSessionResponse: Sign.Model.SettledSessionResponse) {
                        if (settleSessionResponse is Sign.Model.SettledSessionResponse.Result) {
                            val session = settleSessionResponse.session
                            onEvent(
                                name = "session_settle", data = session.toFlutterValue()
                            )
                        }
                    }

                    override fun onSessionUpdateResponse(sessionUpdateResponse: Sign.Model.SessionUpdateResponse) {
                        if (sessionUpdateResponse is Sign.Model.SessionUpdateResponse.Result) {
                            onEvent(
                                name = "session_update", data = mapOf(
                                    "topic" to sessionUpdateResponse.topic
                                )
                            )
                        }
                    }

                    override fun onConnectionStateChange(state: Sign.Model.ConnectionState) {
                        onEvent(
                            name = "connection_status", data = mapOf(
                                "isConnected" to state.isAvailable
                            )
                        )
                    }

                    override fun onError(error: Sign.Model.Error) {
                        onError(
                            "delegate_error",
                            errorMessage = error.throwable.message ?: ""
                        )
                    }
                }
                SignClient.setWalletDelegate(walletDelegate)

                val dappDelegate = object : SignClient.DappDelegate {
                    override fun onSessionApproved(approvedSession: Sign.Model.ApprovedSession) {
                        val session = SignClient.getActiveSessionByTopic(approvedSession.topic)
                        if (session != null) {
                            onEvent(
                                name = "session_settle", data = session.toFlutterValue()
                            )
                        }
                    }

                    override fun onSessionRejected(rejectedSession: Sign.Model.RejectedSession) {
                        onEvent(
                            name = "session_rejection", data = rejectedSession.toFlutterValue()
                        )
                    }

                    override fun onSessionUpdate(updatedSession: Sign.Model.UpdatedSession) {
                        // Unused
                    }

                    override fun onSessionExtend(session: Sign.Model.Session) {
                        // Unused
                    }

                    override fun onSessionEvent(sessionEvent: Sign.Model.SessionEvent) {
                        // Unused
                    }

                    override fun onSessionDelete(deletedSession: Sign.Model.DeletedSession) {
                        // Handled by Wallet Delegate
                    }

                    override fun onSessionRequestResponse(response: Sign.Model.SessionRequestResponse) {
                        onEvent(
                            name = "session_response", data = response.toFlutterValue()
                        )
                    }

                    override fun onConnectionStateChange(state: Sign.Model.ConnectionState) {
                        // Handled by Wallet Delegate
                    }

                    override fun onError(error: Sign.Model.Error) {
                        onError(
                            "delegate_error",
                            errorMessage = error.throwable.message ?: ""
                        )
                    }
                }

                SignClient.setDappDelegate(dappDelegate)

                result.success(null)
            }
            "connect" -> {
                val handleError: (Core.Model.Error) -> Unit = {
                    onError("connect_error", errorMessage = it.throwable.message ?: "")
                }
                CoreClient.Relay.connect(onError = handleError)
                result.success(null)
            }
            "disconnect" -> {
                val handleError: (Core.Model.Error) -> Unit = {
                    onError("disconnect_error", errorMessage = it.throwable.message ?: "")
                }
                CoreClient.Relay.disconnect(onError = handleError)
                result.success(null)
            }
            "pair" -> {
                val uri = call.argument<String>("uri")!!
                CoreClient.Pairing.pair(pair = Core.Params.Pair(uri = uri), onError = {
                    onError(
                        "pair_error",
                        errorMessage = it.throwable.message ?: ""
                    )
                })
                result.success(null)
            }
            "approve" -> {
                val arguments = call.arguments<Map<String, Any>>()!!
                val gson = Gson()
                val rawNamespaces = arguments["namespaces"] as Map<*, *>
                val namespaces = rawNamespaces.mapValues {
                    gson.fromJson(
                        gson.toJson(it.value), Sign.Model.Namespace.Session::class.java
                    )
                }
                @Suppress("UNCHECKED_CAST") val approve = Sign.Params.Approve(
                    proposerPublicKey = arguments["id"] as String,
                    namespaces = namespaces as Map<String, Sign.Model.Namespace.Session>
                )
                SignClient.approveSession(approve = approve) {
                    onError(
                        "approve_error",
                        errorMessage = it.throwable.message ?: ""
                    )
                }
                result.success(null)
            }
            "reject" -> {
                val arguments = call.arguments<Map<String, Any>>()!!
                val reject = Sign.Params.Reject(
                    proposerPublicKey = arguments["id"] as String, reason = "user_rejected"
                )
                SignClient.rejectSession(reject = reject) {
                    onError(
                        "reject_error",
                        errorMessage = it.throwable.message ?: ""
                    )
                }
                result.success(null)
            }
            "getActivatedSessions" -> {
                val sessions = SignClient.getListOfActiveSessions()
                result.success(sessions.map { it.toFlutterValue() })
            }
            "disconnectSession" -> {
                val arguments = call.arguments<Map<String, Any>>()!!
                SignClient.disconnect(disconnect = Sign.Params.Disconnect(sessionTopic = arguments["topic"] as String)) {
                    onError(
                        "disconnect_session_error", errorMessage = it.throwable.message ?: ""
                    )
                }
                result.success(null)
            }
            "updateSession" -> {
                val arguments = call.arguments<Map<String, Any>>()!!
                val gson = Gson()
                val rawNamespaces = arguments["namespaces"] as Map<*, *>
                val namespaces = rawNamespaces.mapValues {
                    gson.fromJson(
                        gson.toJson(it.value), Sign.Model.Namespace.Session::class.java
                    )
                }
                @Suppress("UNCHECKED_CAST") val update = Sign.Params.Update(
                    sessionTopic = arguments["id"] as String,
                    namespaces = namespaces as Map<String, Sign.Model.Namespace.Session>
                )
                SignClient.update(update = update) {
                    onError(
                        "update_session_error", errorMessage = it.throwable.message ?: ""
                    )
                }
                result.success(null)
            }
            "approveRequest" -> {
                val arguments = call.arguments<Map<String, Any>>()!!
                SignClient.respond(response = Sign.Params.Response(
                    sessionTopic = arguments["topic"] as String,
                    Sign.Model.JsonRpcResponse.JsonRpcResult(
                        id = (arguments["requestId"] as String).toLong(),
                        result = arguments["result"] as String
                    )
                ), onError = {
                    onError(
                        "approve_request_error",
                        errorMessage = it.throwable.message ?: ""
                    )
                })
                result.success(null)
            }
            "rejectRequest" -> {
                val arguments = call.arguments<Map<String, Any>>()!!
                SignClient.respond(response = Sign.Params.Response(
                    sessionTopic = arguments["topic"] as String,
                    Sign.Model.JsonRpcResponse.JsonRpcError(
                        id = (arguments["requestId"] as String).toLong(),
                        code = 4001,
                        message = "User rejected the request"
                    )
                ), onError = {
                    onError("reject_request_error", errorMessage = it.throwable.message ?: "")
                })
                result.success(null)
            }
            "createPair" -> {
                val arguments = call.arguments<Map<String, Any>>()!!
                val gson = Gson()
                val namespaces = arguments.mapValues {
                    gson.fromJson(
                        gson.toJson(it.value), Sign.Model.Namespace.Proposal::class.java
                    )
                }
                val pairing: Core.Model.Pairing? = CoreClient.Pairing.create {
                    onError("create_pair_error", errorMessage = it.throwable.message ?: "")
                }
                if (pairing == null) {
                    result.success(null)
                    return
                }
                val connectParams = Sign.Params.Connect(namespaces = namespaces, pairing = pairing)
                SignClient.connect(connectParams, {
                    result.success(pairing.uri)
                }, {
                    result.success(null)
                    onError("create_pair_error", errorMessage = it.throwable.message ?: "")
                })
            }
            "sendRequest" -> {
                val arguments = call.arguments<Map<String, Any>>()!!
                val gson = Gson()
                val requestParams = Sign.Params.Request(
                    sessionTopic = arguments["topic"] as String,
                    method = arguments["method"] as String,
                    chainId = arguments["chainId"] as String,
                    params = gson.toJson(arguments["params"])
                )
                val handleSuccess: (Sign.Model.SentRequest) -> Unit = {
                    result.success(null)
                }
                val handleError: (Sign.Model.Error) -> Unit = {
                    result.success(null)
                    onError("send_request_error", errorMessage = it.throwable.message ?: "")
                }
                SignClient.request(requestParams, onError = handleError, onSuccess = handleSuccess)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun onEvent(name: String, data: Any) {
        activity?.runOnUiThread {
            eventSink?.success(
                mapOf(
                    "name" to name, "data" to data
                )
            )
        }
    }

    private fun onError(code: String, errorMessage: String = "") {
        activity?.runOnUiThread {
            eventSink?.error(code, errorMessage, null)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}

fun Sign.Model.SessionProposal.toFlutterValue(): Map<String, Any> {
    return mapOf(
        "id" to this.proposerPublicKey,
        "proposer" to mapOf(
            "name" to this.name,
            "description" to this.description,
            "url" to this.url,
            "icons" to this.icons.map { it.toString() },
            "redirect" to this.redirect.ifBlank { null }
        ),
        "namespaces" to this.requiredNamespaces.map { (key, value) ->
            key to mapOf(
                "chains" to value.chains,
                "methods" to value.methods,
                "events" to value.events
            )
        }.toMap()
    )
}

fun Sign.Model.Session.toFlutterValue(): Map<String, Any> {
    return mapOf(
        "topic" to this.topic,
        "peer" to mapOf(
            "name" to this.metaData?.name,
            "description" to this.metaData?.description,
            "url" to this.metaData?.url,
            "icons" to this.metaData?.icons,
            "redirect" to this.metaData?.redirect
        ),
        "expiration" to Date(this.expiry).toUtcIsoDateString(),
        "namespaces" to this.namespaces.map { (key, value) ->
            key to mapOf(
                "accounts" to value.accounts,
                "methods" to value.methods,
                "events" to value.events
            )
        }.toMap()
    )
}

fun Sign.Model.SessionRequest.toFlutterValue(): Map<String, String?> {
    return mapOf(
        "id" to this.request.id.toString(),
        "topic" to this.topic,
        "chainId" to this.chainId,
        "method" to this.request.method,
        "params" to this.request.params
    )
}

fun Date.toUtcIsoDateString(): String {
    val dateFormat: DateFormat = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    return dateFormat.format(this)
}

fun Sign.Model.RejectedSession.toFlutterValue(): Map<String, String> {
    return mapOf(
        "topic" to this.topic
    )
}

fun Sign.Model.SessionRequestResponse.toFlutterValue(): Map<String, Any> {
    val results: Any = if (this.result is Sign.Model.JsonRpcResponse.JsonRpcResult) {
        Gson().toJson((this.result as Sign.Model.JsonRpcResponse.JsonRpcResult).result)
    } else {
        Gson().toJson(
            mapOf(
                "code" to (this.result as Sign.Model.JsonRpcResponse.JsonRpcError).code,
                "message" to (this.result as Sign.Model.JsonRpcResponse.JsonRpcError).message
            )
        )
    }
    return mapOf(
        "id" to this.result.id.toString(),
        "topic" to this.topic,
        "results" to results
    )
}
