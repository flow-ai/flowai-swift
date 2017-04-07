//
//  Exception.swift
//  FlowCore
//
//  Created by Gijs van de Nieuwegiessen on 03/04/2017.
//  Copyright © 2017 Flow.ai. All rights reserved.
//

import Foundation

enum Exception : Error {
    case Rest(String)
    case Socket(String)
    case DataFormat(String)
    case NoConnection()
    case JSON(String)

    case Serialzation(String)
}
