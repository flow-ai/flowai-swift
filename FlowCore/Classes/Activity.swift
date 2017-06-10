//
//  Activity.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 09/04/2017.
//
//

import Foundation
import HandyJSON

/// The base class for Messages being send and received
public class Activity : HandyJSON {
    
    /// Thread this message belongs to
    internal(set) public var threadId:String?
    
    // The Originator of the activity
    public var originator:Originator!
    
    public required init() {}
}
