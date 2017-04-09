//
//  Reply.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation
import HandyJSON

public class Reply : Activity {
    
    private(set) public var messages:[ReplyMessage] = []
        
    init(_ data: [String: Any]) throws {
        
        super.init()
        
        guard let threadId = data["threadId"] as? String else {
            throw Exception.Serialzation("threadId not found")
        }
        
        self.threadId = threadId
        
        if let originatorData = data["originator"] as? [String: Any] {
            self.originator = Originator(originatorData)
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

public struct ReplyMessage : HandyJSON {
    
    private(set) public var fallback:String!
    private(set) public var replyTo:String? = nil
    private(set) public var responses:[Response] = []
    private(set) public var contexts:[String] = []
    private(set) public var params:[String: String] = [:]
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

public struct Response : HandyJSON {

    private(set) public var type:String!
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
