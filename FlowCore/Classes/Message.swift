//
//  Message.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation

public class Message : Activity {
    
    public var traceId:Int?
    public var speech:String!
    private(set) public var direction:Direction = .outbound
    private(set) public var metadata:Metadata = Metadata()
    
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
