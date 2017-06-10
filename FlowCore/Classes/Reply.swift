//
//  Reply.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation
import HandyJSON

/// Activity send by Flow.ai
public class Reply : Activity {
    
    /// Direction it was originally send
    private(set) public var direction:Direction = .inbound
    
    /// Collection of messages
    private(set) public var messages:[ReplyMessage] = []
        
    init(_ data: [String: Any]) throws {
        
        super.init()
        
        guard let threadId = data["threadId"] as? String else {
            throw Exception.Serialzation("threadId not found")
        }
        
        self.threadId = threadId
        
        if let originatorData = data["originator"] as? [String: Any] {
            self.originator = Originator(originatorData)
            
            if originator.role == "external" {
                self.direction = .outbound
            }
        } else {
            self.originator = Originator()
        }
        
        if let messagesData = data["messages"] as? [[String: Any]] {
            self.messages = try messagesData.map({ (messageData:[String: Any]) -> ReplyMessage in
                return try ReplyMessage(messageData)
            })
        }
    }
    
    public required init() { }
}

/// Message as send or received by Flow.ai
public struct ReplyMessage : HandyJSON {
    
    /// Message as spoken word
    private(set) public var fallback:String!
    
    /// Optional query this message replies to
    private(set) public var replyTo:String? = nil
    
    /// Optional Response templates
    private(set) public var responses:[Response] = []
    
    /// Context the message was send
    private(set) public var contexts:[String] = []
    
    /// Optional data
    private(set) public var params:[String: String] = [:]
    
    /// Optional intents that were found by Flow.ai
    private(set) public var intents:[String] = []
    
    public init() { }
    
    init(_ data: [String: Any]) throws {
        guard let fallback = data["fallback"] as? String else {
            throw Exception.Serialzation("fallback not found")
        }
        
        self.fallback = fallback
        
        if let replyTo = data["replyTo"] as? String {
            self.replyTo = replyTo
        }
        
        if let contexts = data["contexts"] as? [String] {
            self.contexts = contexts
        }
        
        if let params = data["params"] as? [String:String] {
            self.params = params
        }
        
        if let intents = data["intents"] as? [String] {
            self.intents = intents
        }
        
        if let responsesData = data["responses"] as? [[String: Any]] {
            self.responses = try responsesData.map({ (responseData:[String: Any]) -> Response in
                return try Response(responseData)
            })
        }

    }
}

/// Response template
public struct Response : HandyJSON {
    
    /// Type of the template
    private(set) public var type:String!
    
    /// Payload containing specific payload data
    private(set) public var payload:Template!
    
    public init() { }
    
    init(_ data: [String: Any]) throws {
        guard let type = data["type"] as? String else {
            throw Exception.Serialzation("response template has no type")
        }
        
        self.type = type
        
        guard let payload = data["payload"] as? [String: Any] else {
            throw Exception.Serialzation("response template has no payload")
        }
        
        switch(type) {
        case "text":
            self.payload = try TextTemplate(payload)
            break
        case "card":
            self.payload = try CardTemplate(payload)
            break
        case "image":
            self.payload = try ImageTemplate(payload)
            break
        case "carousel":
            self.payload = try TextTemplate(payload)
            break
        case "location":
            self.payload = try LocationTemplate(payload)
            break
        case "list":
            self.payload = try ListTemplate(payload)
            break
        case "buttons":
            self.payload = try ButtonsTemplate(payload)
            break
        default:
            break
        }

    }
}
