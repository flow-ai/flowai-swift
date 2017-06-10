//
//  Exception.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation


/**
 Errors
 - Rest: An error while calling the REST api
 - Socket: Error handling Socket messages
 - DataFormat: Error with the data format send or received
 - NoConnection: Error, no live connection
 - JSON: Error with JSON parsing
 */
enum Exception : Error {
    case Rest(String)
    case Socket(String)
    case DataFormat(String)
    case NoConnection()
    case JSON(String)

    case Serialzation(String)
}
