//
//  Originator.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.

import Foundation
import SwiftWebSocket

// Enums
public enum Direction {
    case inbound
    case outbound
}

/// Live Web Socket Client
public class LiveClient {
    
    // MARK: - Properties
    
    /// Connection is open
    public var isConnected:Bool  {
        get {
            if let socket = self.socket {
                return (socket.readyState == WebSocketReadyState.open)
            }
            
            return false
        }
    }
    
    /// Delegate that handles events
    public var delegate:LiveClientDelegate?
    
    // MARK: - Private
    private var rest:Rest
    private var socket:WebSocket?
    private var clientId:String
    private var endpoint:String = "https://api.flow.ai/channels/webclient/api"
    private var sessionId:String
    private var threadId:String
    private let keepAliveInterval:Int = 20 // seconds
    private var keepAliveTimer:Timer? = nil
    private var reconnectInterval:Int = 1 // seconds
    private var reconnectTimer:Timer? = nil
    
    /**
     Initializes a new LiveClient.
     
     - Parameter clientId: Get your clientId from the dashboard
     - Parameter threadId: Optional threadId. If not specified we will generate and store one for this specific app
     - Parameter sessionId: Optional sessionId
     - Parameter eindpoint: Optional endpoint
     - Returns: LiveClient instance
     */
    public init(clientId:String, threadId:String? = nil, sessionId:String? = nil, endpoint:String? = nil) {
        self.clientId = clientId
        
        if let threadId = threadId {
            self.threadId = threadId
        }
        else if let threadId = UserDefaults.standard.value(forKey: "threadId") as? String {
            self.threadId = threadId
        } else {
            self.threadId = UUID().uuidString
        }
        
        UserDefaults.standard.setValue(self.threadId, forKey: "threadId")
        
        if let sessionId = sessionId {
            self.sessionId = sessionId
        }
        else if let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String {
            self.sessionId = sessionId
        } else {
            self.sessionId = UUID().uuidString
        }
        
        UserDefaults.standard.setValue(self.sessionId, forKey: "sessionId")
        
        if let endpoint = endpoint {
            self.endpoint = endpoint
        }
        
        self.rest = Rest(self.endpoint)
    }
    
    // MARK: - Public methods
    
    /**
     Open the connection. The LiveClient will auto reconnect when the connection is interrupted.
     **/
    public func start() {
        self.requestEndpoint()
    }
    
    /**
     Close the connection
     **/
    public func stop() {
        self.closeConnection()
    }
    
    /**
     Load previous send and received activities. The LiveCLient must be connected.
     
     - Parameter threadId: Optional threadId. By default the threadId is used when creating the LiveClient
     **/
    public func loadHistory(_ threadId:String? = nil) {
        self.requestHistory(threadId)
    }
    
    public func noticed() {
        
    }
    
    public func checkUnnoticed() {
        
    }
    
    
    /**
     Send a new Message. When a Message is send it will call the `didSendMessage` on the delegate. The LiveCLient must be connected.
     
     - Parameter message: This should be either an instance of a Message, Ping or Notice
     **/
    public func send(_ message:Any) {
        if(!self.isConnected){
            return self.handleError(Exception.NoConnection())
        }
        
        var enveloppe:Enveloppe?
        
        if message is Ping {
            enveloppe = Enveloppe(withType: "ping")
        }
        
        if let message = message as? Message {
            if message.threadId == nil {
                message.threadId = self.threadId
            }
            
            message.originator.deviceId = UIDevice.current.identifierForVendor?.uuidString
            
            if message.metadata.language == nil {
                message.metadata.language = Locale.current.languageCode
            }
            
            if message.metadata.timezone == nil {
                message.metadata.timezone = Locale.current.calendar.timeZone.secondsFromGMT() / 60 / 60
            }

            
            enveloppe = Enveloppe(withType: "message.send", payload: message)
        }
        
        if let notice = message as? Notice {
            enveloppe = Enveloppe(withType: "thread.noticed", payload: notice)
        }
        
        if let enveloppe = enveloppe,
           let json = enveloppe.toJSONString() {
            socket?.send(string: json)
        }
        
        if let message = message as? Message {
            self.delegate?.client(self, didSendMessage: message)
        }
    }
    
    /**
     Call to inidicate the user has *noticed* all activities. The LiveCLient must be connected.
     
     - Parameter threadId: The thread that is noticed
     **/
    public func notice(_ threadId:String) {
        self.send(Notice(threadId))
    }
    
    // MARK: - Private methods
    
    @objc private func ping() {
        self.send(Ping())
    }

    private func reconnect() {
        self.reconnectTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(self.reconnectInterval),
            target: self,
            selector: #selector(handleReconnect),
            userInfo: nil,
            repeats: false
        )
    }
    
    private func cancelReconnect() {
        self.reconnectTimer?.invalidate()
        self.reconnectTimer = nil
        self.reconnectInterval = 1
    }
    
    private func requestEndpoint() {
        
        let queryParams = [
            "sessionId": self.sessionId,
            "clientId": self.clientId
        ]
        
        // Load a WSS URL
        self.rest.get(path: "socket.info", token: self.clientId, queryParams: queryParams) { err, json in
            
            if err != nil {
                
                // HTTP error
                self.reconnect()
                
                return self.handleError(Exception.Rest(err!.localizedDescription))
            }
            
            guard let status = json?["status"] as? String,
                let payload = json?["payload"] as? [String: Any] else {
                    return self.handleError(Exception.DataFormat("Expected status and payload."))
            }
            
            if status != "ok" {
                guard let message = payload["message"] as? String, message != "" else {
                    return self.handleError(Exception.DataFormat("Received status is not OK, but no error message inside response"))
                }
                
                return self.handleError(Exception.Rest(message))
            }
            
            guard let endpoint = payload["endpoint"] as? String else {
                return self.handleError(Exception.DataFormat("Expected endpoint."))
            }
            
            self.connectWithEndpoint("\(endpoint)")
        }
    }
    
    private func requestHistory(_ threadId:String?) {
        let queryParams = [
            "clientId": self.clientId,
            "threadId": threadId ?? self.threadId
        ]
        
        // Load a WSS URL
        self.rest.get(path: "thread.history", token: self.clientId, queryParams: queryParams) { err, json in
            
            if err != nil {
                
                // HTTP error
                self.reconnect()
                
                return self.handleError(Exception.Rest(err!.localizedDescription))
            }
            
            guard let status = json?["status"] as? String else {
                return self.handleError(Exception.DataFormat("Expected `status` in result"))
            }
            
            if status != "ok" {
                guard let payload = json?["payload"] as? [String: Any],
                    let message = payload["message"] as? String, message != "" else {
                        return self.handleError(Exception.DataFormat("Received status is not OK, but no error message inside response"))
                }
                
                return self.handleError(Exception.Rest(message))
            }
            
            guard let payload = json?["payload"] as? [Any] else {
                return self.handleError(Exception.DataFormat("Expected payload to be an array of messages"))
            }
            
            self.handleHistory(payload)
        }
    }
    
    private func closeConnection() {
        socket?.close()
        self.cancelReconnect()
    }
    
    private func connectWithEndpoint(_ endpoint:String) {
        var request = URLRequest(url: URL(string: endpoint)!)
        request.setValue("FlowCore-iOS", forHTTPHeaderField: "User-Agent")
        
        socket = WebSocket(request: request)
        socket!.event.open = self.handleOpen
        socket!.event.close = self.handleClosed
        socket!.event.error = self.handleError
        socket!.event.message = self.handleMessage
    }
    
    @objc private func handleReconnect() {
        self.requestEndpoint()
        self.reconnectInterval = self.reconnectInterval + fibs(self.reconnectInterval)
        self.delegate?.clientWillReconnect(self)
    }
    
    private func handleMessage(_ message:Any?) {
        
        if let message = message as? String,
           let data = message.data(using: String.Encoding.utf8, allowLossyConversion: false),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let type = json?["type"] as? String {
          
            switch type {
            case "pong":
                // do nothing
                break
                
            case "message.delivered":
                if let payload = json?["payload"] as? [String: Any] {
                    self.handleDelivered(payload)
                }
                break
            
            case "activities.delivered":
                if let payload = json?["payload"] as? [String: Any] {
                    self.handleDelivered(payload)
                }
                break

            case "message.received":
                if let payload = json?["payload"] as? [String: Any] {
                    self.handleReceived(payload)
                }
                break
                
            case "activities.created":
                if let payload = json?["payload"] as? [String: Any] {
                    self.handleReceived(payload)
                }
                break

            case "error":
                if let message = json?["message"] as? String {
                    self.handleError(Exception.Socket(message))
                } else {
                    self.handleError(Exception.Socket("Received error without any message"))
                }
                break

            case "message.delivered":
                break
            
            default:
                break
            }
        }
    }
    
    private func handleOpen() {
        self.delegate?.clientDidConnect(self)
        self.startKeepAlive()
    }
    
    private func handleClosed(code:Int, reason:String, clean:Bool) {
        self.stopKeepAlive()
        self.delegate?.clientDidDisconnect(self)
        
        if clean {
            self.cancelReconnect()
        } else {
            self.reconnect()
        }
    }
    
    private func handleError(_ error:Error) {
        self.delegate?.client(self, didReceiveError: error)
    }
    
    private func handleReceived(_ payload:[String: Any]) {
        do {
            let reply = try Reply(payload)
            self.delegate?.client(self, didReceiveReply: reply)
        } catch {
            self.handleError(error)
        }
    }
    
    private func handleHistory(_ history:[Any]?) {
        do {
            var replies = [Reply]()
            
            if let history = history {
                for historicMessage in history {
                    let reply = try Reply(historicMessage as! [String : Any])
                    replies.append(reply)
                }
            }
            
            self.delegate?.client(self, didReceiveHistory: replies)
        } catch {
            self.handleError(error)
        }
    }
    
    private func handleDelivered(_ payload:[String: Any]) {
        do {
            let message = try Message(payload)
            self.delegate?.client(self, didDeliverMessage: message)
        } catch {
            self.handleError(error)
        }
    }
    
    private func startKeepAlive() {
        self.keepAliveTimer = Timer.scheduledTimer(
            timeInterval: TimeInterval(self.keepAliveInterval),
            target: self,
            selector: #selector(ping),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopKeepAlive() {
        guard keepAliveTimer != nil else { return }
        keepAliveTimer?.invalidate()
        keepAliveTimer = nil
    }
}

/// Receive LiveClient events
public protocol LiveClientDelegate {
    
    /**
     Connection is open
     
     - Parameter client: Reference to the LiveCLient
     **/
    func clientDidConnect(_ client:LiveClient)
    
    /**
     The client is trying to reconnect
     
     - Parameter client: Reference to the LiveCLient
     **/
    func clientWillReconnect(_ client:LiveClient)
    
    /**
     The client has disconnected
     
     - Parameter client: Reference to the LiveCLient
     **/
    func clientDidDisconnect(_ client:LiveClient)
    
    /**
     Received a Reply from Flow.ai
     
     - Parameter client: Reference to the LiveCLient
     - Parameter reply: Reply message
     **/
    func client(_ client:LiveClient, didReceiveReply reply: Reply)
    
    /**
     Client just send a message to Flow.ai
     
     - Parameter client: Reference to the LiveCLient
     - Parameter message: Message being send
     **/
    func client(_ client:LiveClient, didSendMessage message: Message)
    
    /**
     The message being send was delivered to Flow.ai
     
     - Parameter client: Reference to the LiveCLient
     - Parameter message: Message that was delivered
     **/
    func client(_ client:LiveClient, didDeliverMessage message: Message)
    
    /**
     An error occured
     
     - Parameter error: The error
     **/
    func client(_ client:LiveClient, didReceiveError error: Error)
    
    /**
     History has been loaded
     
     - Parameter history: A collection of Reply objects
     **/
    func client(_ client:LiveClient, didReceiveHistory history: [Reply])
}

func fibs(_ n: Int) -> Int {
    
    if n == 0 {
        return 0
    } else if n == 1{
        return 1
    }
    
    return fibs(n - 1) + fibs(n - 2)
}
