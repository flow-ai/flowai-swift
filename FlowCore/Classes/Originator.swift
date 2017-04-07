//
//  Originator.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation
import HandyJSON

public struct Originator : HandyJSON {
    
    public var name:String = "Anonymous"
    private(set) public var role:String = "external"
    public var profile:Profile = Profile()
    internal(set) public var deviceId:String? = nil
    
    init(_ data:[String:Any]) {
        if let name = data["name"] as? String {
            self.name = name
        }
        
        if let role = data["role"] as? String {
            self.role = role
        }
        
        if let profileData = data["profile"] as? [String:Any] {
            self.profile = Profile(profileData)
        }
    }
    
    public init() {}
}

public struct Profile : HandyJSON {
    
    public var fullName:String? = nil
    public var firstName:String? = nil
    public var lastName:String? = nil
    public var picture:URL? = nil
    public var locale:String? = nil
    public var gender:String = "U"
    
    public init() {}
    
    init(_ data:[String:Any]) {
        if let fullName = data["fullName"] as? String {
            self.fullName = fullName
        }
        
        if let firstName = data["firstName"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String {
            self.lastName = lastName
        }
        
        if let picture = data["picture"] as? String {
            self.picture = URL(string: picture)
        }
        
        if let locale = data["locale"] as? String {
            self.locale = locale
        }
        
        if let gender = data["gender"] as? String {
            self.gender = gender
        }
    }
}
