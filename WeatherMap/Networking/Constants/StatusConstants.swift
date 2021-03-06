//
//  StatusConstants.swift
//  WeatherMap
//
//  Created by developer on 16.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
struct StatusConstants {
    struct Loading {
        static let findLocation = "Find location..."
        static let load = "Loading..."
    }
    
    struct Failed {
        static let error = "Error"
        static let cityNotFind = "City doesn't exist"
        static let noInternet = "No Internet"
        static let noWeather = "Weahter don't find"
    }
    
}
