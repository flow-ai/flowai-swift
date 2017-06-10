//
//  Message.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation

/// Message you send to Flow.ai
public class Message : Activity {
    
    /// Used to keep track of the message
    public var traceId:Int?
    
    /// The text to send
    public var speech:String!
    
    /// Direction is outbound
    private(set) public var direction:Direction = .outbound

    /// Data to send along with the Message
    private(set) public var metadata:Metadata = Metadata()
    
    /**
     Initializes a new Message
     
     - Parameters:
     - speech: Text tot send
     - originator: The sender of the message
     - traceId: Optional data to keep track of the Message
     - threadId: Optional threadId to send the message to
     - Returns: Message instance
     */
    public init(speech:String, originator:Originator, traceId:Int? = nil, threadId:String? = nil) {
        super.init()
        
        self.speech = speech
        self.originator = originator
        self.traceId = traceId
        self.threadId = threadId
    }
    
    init(_ data: [String: Any]) throws {
        
        super.init()
        
        guard let threadId = data["threadId"] as? String else {
            throw Exception.Serialzation("threadId not found")
        }
        
        self.threadId = threadId
        
        if let traceId = data["traceId"] as? Int {
            self.traceId = traceId
        }
        
        if let speech = data["speech"] as? String {
            self.speech = speech
        } else {
            self.speech = ""
        }

        if let originatorData = data["originator"] as? [String: Any] {
            self.originator = Originator(originatorData)
        } else {
            self.originator = Originator()
        }
        
        if let metadataData = data["metadata"] as? [String: Any] {
            self.metadata = Metadata(metadataData)
        } else {
            self.metadata = Metadata()
        }
    }
    
    public required init() { }
}
