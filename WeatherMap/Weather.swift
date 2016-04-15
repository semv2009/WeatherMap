//
//  Weather.swift
//  WeatherMap
//
//  Created by developer on 15.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import ObjectMapper
class Weather: Mappable{
    var clouds: Int?
    var humidity: Int?
    var pressure: Int?
    var temp: Double?
    var temp_max: Double?
    var temp_min: Double?
    var sunrise: Int?
    var sunset: Int?
    var description: String?
    var main: String?
    var windDeg: Int?
    var windSpeed: Int?
    
    required init?(_ map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        clouds <- map["clouds.all"]
        humidity <- map["main.humidity"]
        pressure <- map["main.pressure"]
        temp <- map["main.temp"]
        temp_max <- map["main.temp_max"]
        temp_min <- map["main.temp_min"]
        sunrise <- map["sys.sunrise"]
        sunset <- map["sys.sunset"]
        description <- map["weather.description"]
        main <- map["weather.main"]
        windDeg <- map["wind.deg"]
        windSpeed <- map["wind.speed"]
    }
}